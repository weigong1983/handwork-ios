//
//  API.h
//  API 接口定义
//
//  Created by ios on 15-1-30.
//  Copyright (c) 2015年 代言网. All rights reserved.
//

#ifndef __HANDWORK_API__
#define __HANDWORK_API__


/** 是否测试环境： 1表示测试环境； 0表示正式环境 */
#define IS_DEBUG 0

#define NETWORK_TIMEOUT 120.0

#define STATUS_INVALID      10010 // 无效点用户授权信息（账号出现异地登录时调用api会返回此错误码）
#define STATUS_DISABLE      10080 // 账号禁用

/** 服务器API请求测试地址前缀 */
#define API_BASE_DEBUG                 @"http://api.daiyan123.com/ArtApi/index.php/"
/** 服务器API请求正式地址前缀 */
#define API_BASE                       @"http://api.shouzuopin.com/ArtApi/index.php/"

/** 服务条款基网址 */
#define URL_SERVICE_TERM_BASE          @"http://api.shouzuopin.com/ArtApi/index.php/ShowPage/getTermofservice/token/"

/** 活动详情基网址 */
#define URL_ACT_DETAIL_BASE             @"http://api.shouzuopin.com/ArtApi/index.php/ShowPage/detailActivity"

/** APP下载页面 */
#define URL_APP_DOWNLOAD             @"http://app.shouzuopin.com/"

/** 服务器端提供的APP API接口访问密钥 */
#define API_KEY                        @"14h22z51j08x02u"

#define API_SECRET_DEFAULT             @"1717todo2900rmqo4219mygo2511wsqf"         //默认的
#define API_SECRET                     @"secret"                                   //服务器
#define API_TOKEN                      @"token"
#define API_UID                        @"uid"
#define API_ISAUTH                     @"isauth"

#define API_TOURISTS                   @"tourists"

/** 服务器端提供的APP API接口 模块 账号/消息   */
#define MODULE_NAME_ACCOUNT            @"Account"        //账户
#define MODULE_NAME_MESSAGES           @"Messages"       //消息

#define FONT_SIZE_13                   13
#define FONT_SIZE_14                   14
#define FONT_SIZE_15                   15
#define FONT_SIZE_16                   16
#define FONT_SIZE_17                   17
#define FONT_SIZE_18                   18

/** 服务器端提供的APP API接口 方法         */
#define API_REGISTER          @"register"          //注册
#define API_LOGIN             @"login"             //登录
#define API_LOGOUT            @"logout"            //登出
#define API_UPDATEPWD         @"updatePwd"         //密码修改
#define API_FORGETPASSWORD    @"forgetPassword"    //忘记密码

#define API_GETUSERINFO       @"getUserInfo"       //获取用户信息 自己
#define API_getOtherUserInfo  @"getOtherUserInfo"  //获取用户信息 别人
#define API_SETUSERINFO       @"setUserInfo"       //设置用户信息
#define API_pushAvatar        @"pushAvatar"        //设置用户信息 pushAvatar
#define API_LOSTPWD           @"lostPwd"           //丢失密码
#define API_FEEDBACK          @"feedback"          //用户反馈
#define API_PUSHAVATAR        @"pushAvatar"        //修改头像
#define API_GETCODE           @"getCode"           //获取验证码
#define API_GETINDEXINFO      @"getIndexInfo"      //获取首页消息
#define API_GETcommonweal     @"commonweal"        //获取公益广场信息
#define API_getMyIndex        @"getMyIndex"        //获取别人首页消息
#define API_PUSHAVATAR        @"pushAvatar"        //修改头像
#define API_DETAIL            @"detail"            //各种详情
#define API_JoinSpokes        @"joinSpokes"        // 获取我参与的代言信息

#define API_PeopleCard        @"peopleCard"        // 获取我参与的代言信息
#define API_CheckUserHasNew   @"checkUserHasNew"   // 获取用户是否有最新消息
#define API_SpokesBymeOrOther @"spokesBymeOrOther" // 获取自己代言信息
#define API_reMessageOk       @"reMessageOk"       // 评论
#define API_addOk             @"addOk"             // 添加代言

#define API_cancelClick       @"cancelClick"       // 取消点赞
#define API_upClick           @"upClick"           // 点赞

#define API_Enlist            @"enlist"            // 代言现场



#endif
