//
//  RMTimeLineModel.m
//  RMCandleKit
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMTimeLineModel.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation RMTimeLineModel
{
    NSDictionary * _dict;
    NSString *Price;
    NSString *Volume;
}

- (NSString *)TimeDesc {
    //NSLog(@"%@",_dict[@"minute"]);
    if ([_dict[@"minute"] isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if( [_dict[@"minute"] isEqualToString:@"0931"]) {
        return @"09:30";
    }else if([_dict[@"minute"] isEqualToString:@"1301"]) {
        return @"11:30/13:00";
    } else if( [_dict[@"minute"] isEqualToString:@"1459"]) {
        return @"15:00";
    } else {
        return _dict[@"minute"];
    }
}

- (NSString *)DayDatail {
    return _dict[@"minute"];
}

//前一天的收盘价
- (CGFloat )AvgPrice {
    return [_dict[@"avgPrice"] floatValue];
}

- (NSNumber *)Price {
    return _dict[@"price"];
}

- (CGFloat)Volume {
    return [_dict[@"volume"] floatValue]/100.f;
}

- (BOOL)isShowTimeDesc {
    //9:30-11:30,13:00-15:00
    //11:30和13:00挨在一起，显示一个就够了
    //最后一个服务器返回的minute不是960,故只能特殊处理
    return [_dict[@"minute"] isEqualToString:@"0931"] ||  [_dict[@"minute"] isEqualToString:@"1301"] ||  [_dict[@"minute"] isEqualToString:@"1459"];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
        Price = _dict[@"price"];
        Volume = _dict[@"volume"];
    }
    return self;
}

@end
