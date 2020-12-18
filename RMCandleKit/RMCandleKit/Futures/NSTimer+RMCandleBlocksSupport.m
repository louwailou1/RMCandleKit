//
//  NSTimer+RMCandleBlocksSupport.m
//  GoldenTrader
//
//  Created by lsb on 14-3-28.
//  Copyright (c) 2014年 lsb. All rights reserved.
//

#import "NSTimer+RMCandleBlocksSupport.h"

@implementation NSTimer (RMCandleBlocksSupport)

+(NSTimer *)lsb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(lsb_blockInvoke:) userInfo:[block copy] repeats:repeats];
}


+(void)lsb_blockInvoke:(NSTimer *)timer{
    void(^block)()=timer.userInfo;
    if (block) {
        block();
    }
}
@end
