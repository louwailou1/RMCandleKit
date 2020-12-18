//
//  RMCandleConStant.m
//  RMCandleKit
//
//  Created byRMCandleKit on 2019/1/8.
//  Copyright © 2019年RMCandleKit. All rights reserved.
//

#import "RMCandleConStant.h"

@implementation RMCandleConStant

+ (instancetype)sharedInstance {
    static RMCandleConStant *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (NSString *)accuracy {
    if (_accuracy == nil) {
        return @"%.2f";
    }
    return _accuracy;
}

@end
