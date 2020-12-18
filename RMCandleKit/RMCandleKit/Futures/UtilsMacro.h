//
//  UtilsMacro.h
//  StockGroup
//
//  Created by lsb on 14/10/22.
//  Copyright (c) 2014年 lsb. All rights reserved.
//


/**
 *  存放一些常用的宏定义（比如 颜色等）
 */

#ifndef StockGroup_UtilsMacro_h
#define StockGroup_UtilsMacro_h

typedef enum RefreshViewType: NSUInteger {
    RefreshTimeType,
    RefreshOneKline,
    RefreshThreeKline,
    RefreshFiveKline,
    RefreshFifteenKline,
    RefreshSixtyKline,
    RefreshDayKline
} RefreshViewType;

typedef void(^RefreshBlock)(RefreshViewType);

//----------------地址或者域名---------------
//依次排列 实盘 模拟 行情 新实盘API 新模拟API
#if ProductEnv || AppStore

#define kTruthBaseHost @"http://www.mugusx.com"
#define kSimulateBaseHost @"http://sim.mugusx.com"
#define k_KlineBaseHost @"http://quota.mugusx.com"
#define kNewTruthBaseHost @"http://api.mugusx.com"
#define kNewSimulateBaseHost @"http://api.mugusx.com"

#elif DEBUG || TestEnv

#define kTruthBaseHost @"http://192.168.1.150:8000"
#define kSimulateBaseHost @"http://192.168.1.150:8002"
#define k_KlineBaseHost @"http://192.168.1.150:8010"
#define kNewTruthBaseHost @"http://192.168.1.150:8050"
#define kNewSimulateBaseHost @"http://192.168.1.150:8050"

#endif

//渠道包标识
#define x_agentID @"74"

//#define kTruthBaseHost @"http://www.grey.mugusx.com"
//#define kSimulateBaseHost @"http://sim.grey.mugusx.com"
//#define k_KlineBaseHost @"http://quota.grey.mugusx.com"
//#define kNewTruthBaseHost @"http://api.grey.mugusx.com"
//#define kNewSimulateBaseHost @"http://api.grey.mugusx.com"

// 期货赢家2.0
//#define kTruthBaseHost @"http://www.39xz.cn"
//#define kSimulateBaseHost @"http://sim.39xz.cn"
//#define k_KlineBaseHost @"http://quota.39xz.cn"
//#define kNewTruthBaseHost @"http://api.39xz.cn"
//#define kNewSimulateBaseHost @"http://api.39xz.cn"


#define isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height==2436 : NO)


//------------G－C－D-----------------------------------
#define ASYNC_THREAD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN_THREAD(block) dispatch_async(dispatch_get_main_queue(),block)


#define AFTER_THREAD(block,t) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, t * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block)
#define AFTER_MAIN_THREAD(block,t) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, t * NSEC_PER_SEC), dispatch_get_main_queue(),block)

//------------G－C－D-----------------------------------

#define SEND_NOTIFICATION(name)  [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil]

#define SEND_NOTIFICATIONWITHOBJ(name,obj)  [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj]

#define  REGISTER_NOTIFICATION (target,sel,name,obj) [[NSNotificationCenter defaultCenter] addObserver:target selector:sel name:name object:obj]


//----------------------图片----------------------------

//定义UIImage对象
#define UIImageNamed(name) [UIImage imageNamed:name]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------


#define NSSTRINGWITHFORMAT(str) [NSString stringWithFormat:@"%@",str]




#define CREATE_SHARED_MANAGER(CLASS_NAME) \
+ (instancetype)sharedManager { \
static CLASS_NAME *_instance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[CLASS_NAME alloc] init]; \
}); \
\
return _instance; \
}

#define CREATE_SHARED_INSTANCE(CLASS_NAME) \
+ (instancetype)sharedInstance { \
static CLASS_NAME *_instance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[CLASS_NAME alloc] init]; \
}); \
\
return _instance; \
}


static  inline CGSize CalculateBestSizeOfImageShow(CGFloat maxWidth,CGSize imageSize){
    CGFloat height = imageSize.height;
    CGFloat width = imageSize.width;
    CGFloat ratio = width/height*1.0;
    while (width>maxWidth) {
        width = width/2.0;
    }
    return CGSizeMake(width, width/ratio);
}


#endif
