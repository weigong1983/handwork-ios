//
//  DataModel.h
//  Handwork
//
//  Created by apple on 15-5-12.
//  Copyright (c) 2015年 周文超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic,strong)NSString *s_gdname;         //作品名称
@property (nonatomic,strong)NSString *s_gdprice;        //作品价格
@property (nonatomic,strong)NSString *s_saleprice;      //作品销售价格
@property (nonatomic,strong)NSString *s_description;    //描述
@property (nonatomic,strong)NSString *s_image;          //作品图片
@property (nonatomic,strong)NSString *s_image_small;    //小图
@property (nonatomic,strong)NSString *s_gdtop;          //是否置顶
@property (nonatomic,strong)NSString *s_mgid;           ///作品编号
@property (nonatomic,strong)NSString *s_gdview;          //作品浏览数
@property (nonatomic,strong)NSString *s_isdel;          //是否删除 1 为删除
@property (nonatomic,strong)NSString *s_madeaddress;    //产地
@property (nonatomic,strong)NSString *s_createtime;     //创建时间
@property (nonatomic,strong)NSString *s_updatetime;     //更新时间
@property (nonatomic,strong)NSString *s_status;         //状态
@property (nonatomic,strong)NSString *s_iscollect;      //判断是否收藏作品
@property (nonatomic,strong)NSString *s_isupclick;      //判断是否点赞作品
@property (nonatomic,strong)NSString *s_classid;        //所属类型
@property (nonatomic,strong)NSString *s_marktype;       //标价方式
@property (nonatomic,strong)NSString *s_issale;         //是否出售（状态）
@property (nonatomic,strong)NSString *s_address;        //地址
@property (nonatomic,strong)NSString *s_voicetype;
@property (nonatomic,strong)NSString *s_title;          //标题
@property (nonatomic,strong)NSString *s_upclickcount;   //总点赞数
@property (nonatomic,strong)NSString *s_remsgcount;     //总评论数
@property (nonatomic,strong)NSString *s_push;           //是否推荐
@property (nonatomic,strong)NSString *s_realname;       //真实姓名
@property (nonatomic,strong)NSString *s_workscount;     //作品总个数
@property (nonatomic,strong)NSMutableArray* arr_worksinfo;
@property (nonatomic,strong)NSString *s_photo;          //作者头像
@property (nonatomic,strong)NSString *s_nickname;       //昵称
@property (nonatomic,strong)NSString *s_callname;       //称号
@property (nonatomic,strong)NSString *s_voicepath;       //音频文件路径
@property (nonatomic,strong)NSURL *url_path;
@property (nonatomic,strong)NSString* s_signature;
@property (nonatomic,strong)NSString *s_Intangibleheritage;   //非遗
@property (nonatomic,strong)NSString *s_madeclassid;          //所属工艺师类型
@property (nonatomic,strong)NSMutableArray* arr_mgid;
@property (nonatomic,strong)NSString* s_remessage;
@property (nonatomic,strong)NSString *s_uid;                  //非遗
@property (nonatomic,strong)NSString *s_introduce;            //简介网页路径
@property (nonatomic,strong)NSString *s_position;             //精度position
@property (nonatomic,strong)NSString *s_content;
@property (nonatomic,strong)NSString *fillColor;          // 填充色
@end
