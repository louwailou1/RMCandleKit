//
//  NSTimer+RMCandleBlocksSupport.h
//  GoldenTrader
//
//  Created by lsb on 14-3-28.
//  Copyright (c) 2014年 lsb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (RMCandleBlocksSupport)
/**
 *  使用block来解决NStimer 循环引用的问题
 *
 *  @param interval 时间间隔
 *  @param block     block
 *  @param repeats  是否重复
 *
 *  @return 当前timer
 */
+(NSTimer *)lsb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block repeats:(BOOL)repeats;


@end
