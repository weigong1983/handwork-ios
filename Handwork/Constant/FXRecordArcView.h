#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define MAX_RECORD_DURATION 60.0
#define WAVE_UPDATE_FREQUENCY   0.1
#define SILENCE_VOLUME   45.0
#define SOUND_METER_COUNT  6
#define HUD_SIZE  self.frame.size.width

@class FXRecordArcView;
@protocol FXRecordArcViewDelegate <NSObject>

- (void)recordArcView:(FXRecordArcView *)arcView voiceRecorded:(NSString *)recordPath length:(float)recordLength;

@end

@interface FXRecordArcView : UIView<AVAudioRecorderDelegate>
@property(weak, nonatomic) id<FXRecordArcViewDelegate> delegate;
@property(readwrite, nonatomic, strong) UILabel *timeLabel;
- (void)startForFilePath:(NSString *)filePath;
- (void)commitRecording;

@end
