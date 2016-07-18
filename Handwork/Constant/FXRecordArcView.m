#import "FXRecordArcView.h"

@interface FXRecordArcView (){
    int soundMeters[SOUND_METER_COUNT];
}

@property(readwrite, nonatomic, strong) NSDictionary *recordSettings;
@property(readwrite, nonatomic, strong) AVAudioRecorder *recorder;
@property(readwrite, nonatomic, strong) NSString *recordPath;
@property(readwrite, nonatomic, strong) NSTimer *timer;

@property(readwrite, nonatomic, assign) CGFloat recordTime;
@property(readwrite, nonatomic, assign) CGRect hudRect;

@end

@implementation FXRecordArcView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.recordSettings = @{AVFormatIDKey : @(kAudioFormatLinearPCM), AVEncoderBitRateKey:@(16),AVEncoderAudioQualityKey : @(AVAudioQualityMax), AVSampleRateKey : @(8000.0), AVNumberOfChannelsKey : @(1)};
        for(int i=0; i<SOUND_METER_COUNT; i++) {
            soundMeters[i] = SILENCE_VOLUME;
        }
        
        self.backgroundColor = [UIColor clearColor];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:35];
        self.timeLabel.center = CGPointMake(frame.size.width / 2.0 + 2, frame.size.height - 20);
        [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.timeLabel];
        
        self.hudRect = CGRectMake(self.center.x - (frame.size.width / 2), self.center.y - (frame.size.width / 2), frame.size.width, frame.size.width);
    }
    return self;
}

- (void)startForFilePath:(NSString *)filePath{
    NSLog(@"file path:%@",filePath);
    if (self.recorder.isRecording) {
        return;
    }
    self.recordTime = 0.0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
	}
	[audioSession setActive:YES error:&err];
	err = nil;
	if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
	}
    self.recordPath = filePath;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //NSDate *existedData = (NSDate*)[NSData dataWithContentsOfFile:[url path] options:NSDataReadingMapped error:&err];
    NSDate *existedData = (NSDate*)[NSData dataWithContentsOfFile:[url path] options:NSDataReadingMapped error:&err];
    if (existedData) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.recordSettings error:&err];
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    
    [self.recorder recordForDuration:MAX_RECORD_DURATION];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

- (void)commitRecording{
    [self.recorder stop];
}

- (void)updateMeters{
    [self.recorder updateMeters];
    if (self.recordTime > 60.0) {
        return;
    }
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    [self.timeLabel setText:[NSString stringWithFormat:@"%.0fs",self.recordTime]];
    if ([self.recorder averagePowerForChannel:0] < -SILENCE_VOLUME) {
        [self addSoundMeterItem:SILENCE_VOLUME];
        return;
    }
    [self addSoundMeterItem:[self.recorder averagePowerForChannel:0]];
    NSLog(@"volume:%f",[self.recorder averagePowerForChannel:0]);
}

- (void)addSoundMeterItem:(int)lastValue{
    for(int i=0; i<SOUND_METER_COUNT - 1; i++) {
        soundMeters[i] = soundMeters[i+1];
    }
    soundMeters[SOUND_METER_COUNT - 1] = lastValue;
    
    [self setNeedsDisplay];
}

#pragma mark - Drawing operations

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    int baseLine = self.frame.size.height/2;
    static int multiplier = 1;
    int maxLengthOfWave = 45;
    int maxValueOfMeter = 400;
    int yHeights[6];
    float segement[6] = {0.05, 0.2, 0.35, 0.25, 0.1, 0.05};
    
    [[UIColor colorWithRed:55/255.0 green:180/255.0 blue:252/255.0 alpha:1] set];
    CGContextSetLineWidth(context, 2.0);
    
    
    for(int x = SOUND_METER_COUNT - 1; x >= 0; x--)
    {
        int multiplier_i = ((int)x % 2) == 0 ? 1 : -1;
        CGFloat y = ((maxValueOfMeter * (maxLengthOfWave - abs(soundMeters[(int)x]))) / maxLengthOfWave);
        yHeights[SOUND_METER_COUNT - 1 - x] = multiplier_i * y * segement[SOUND_METER_COUNT - 1 - x]  * multiplier+ baseLine;
        //NSDLOG(@"i:%d, f:%d",5 + x - SOUND_METER_COUNT + 1, yHeights[5 + x - SOUND_METER_COUNT + 1]);
    }
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:2.0 alpha:0.8 percent:1.0 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.4 percent:0.66 segementArray:segement];
    [self drawLinesWithContext:context BaseLine:baseLine HeightArray:yHeights lineWidth:1.0 alpha:0.2 percent:0.33 segementArray:segement];
    multiplier = -multiplier;
}

- (void) drawLinesWithContext:(CGContextRef)context BaseLine:(float)baseLine HeightArray:(int*)yHeights lineWidth:(CGFloat)width alpha:(CGFloat)alpha percent:(CGFloat)percent segementArray:(float *)segement{
    
    CGFloat start = 0;
    [[UIColor colorWithRed:55/255.0 green:180/255.0 blue:252/255.0 alpha:1] set];
    CGContextSetLineWidth(context, width);
    
    for (int i = 0; i < 6; i++) {
        if (i % 2 == 0) {
            CGContextMoveToPoint(context, start, baseLine);
            
            CGContextAddCurveToPoint(context, HUD_SIZE *segement[i] / 2 + start, (yHeights[i] - baseLine)*percent + baseLine, HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1] / 2 + start, (yHeights[i + 1] - baseLine)*percent + baseLine,HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1] + start , baseLine);
            start += HUD_SIZE *segement[i] + HUD_SIZE *segement[i + 1];
        }
    }
    
    CGContextStrokePath(context);
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"error : %@",error);
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [self.timer invalidate];
    if ([self.delegate respondsToSelector:@selector(recordArcView:voiceRecorded:length:)]) {
        [self.delegate recordArcView:self voiceRecorded:self.recordPath length:self.recordTime];
    }
    [self setNeedsDisplay];
    //录音的时候因为设置的音频会话是录音模式，所以录音完成后要把音频会话设置回听筒模式或者扬声器模式，根据切换器的值判断
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
}


- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.recorder.delegate = nil;
}

@end
