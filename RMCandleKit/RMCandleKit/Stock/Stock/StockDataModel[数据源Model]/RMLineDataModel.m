//
//  RMLineDataModel.m
//  RMCandleKit
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMLineDataModel.h"
@interface RMLineDataModel()

/**
 持有字典数组，用来计算ma值
 */

@end
@implementation RMLineDataModel
{
    NSDictionary * _dict;
    NSString *Close;
    NSString *Open;
    NSString *Low;
    NSString *High;
    NSString *Volume;
    CGFloat MA5;
    CGFloat MA10;
    CGFloat MA20;
    
}

- (NSString *)Day {
    return self.showDay ? : @"";
    
//    NSString *day = [_dict[@"day"] stringValue];
//    return [NSString stringWithFormat:@"%@-%@-%@",[day substringToIndex:4],[day substringWithRange:NSMakeRange(4, 2)],[day substringWithRange:NSMakeRange(6, 2)]];
//    
//    if (self.parentDictArray.count % 5 == ([self.parentDictArray indexOfObject:_dict] + 1 )%5 ) {
//        return [NSString stringWithFormat:@"%@-%@-%@",[day substringToIndex:4],[day substringWithRange:NSMakeRange(4, 2)],[day substringWithRange:NSMakeRange(6, 2)]];
//    }
//    return @"";
}

- (NSString *)DayDatail {
    return _dict[@"day"];
}

- (id<RMCandleLineDataModelProtocol>)preDataModel {
    if (_preDataModel != nil) {
        return _preDataModel;
    } else {
        return [[RMLineDataModel alloc]init];
    }
}

- (NSNumber *)Open {
//    NSLog(@"%i",[[_dict[@"day"] stringValue] hasSuffix:@"01"]);
    return _dict[@"open"];
}

- (NSNumber *)Close {
    return _dict[@"close"];
}

- (NSNumber *)High {
    return _dict[@"high"];
}

- (NSNumber *)Low {
    return _dict[@"low"];
}

- (CGFloat)Volume {
    return [_dict[@"volume"] floatValue]/100.f;
}

- (BOOL)isShowDay {
    return self.showDay.length > 0;
//    return [[_dict[@"day"] stringValue] hasSuffix:@"01"];
}

- (CGFloat )MA5 {
    return MA5;
}

- (CGFloat )MA10 {
    return MA10;
}

- (CGFloat )MA20 {
    return MA20;
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _dict = dict;
        Close = _dict[@"close"];
        Open = _dict[@"open"];
        High = _dict[@"high"];
        Low = _dict[@"low"];
        Volume = _dict[@"volume"];
    }
    return self;
}

- (void)updateMA:(NSUInteger )index {
    
    if (index >= 19) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-19, 20)];
        int i = 0;
        CGFloat subs20 = 0.0;
        CGFloat subs10 = 0.0;
        CGFloat subs5  = 0.0;
        for (NSDictionary *dic in array) {
            CGFloat closeValue = [dic[@"close"] floatValue];
            subs20 += closeValue;
            if (i >= 10) {
                subs10 += closeValue;
                if (i >= 15) {
                    subs5 += closeValue;
                }
            }
            i++;
        }
        MA5  = subs5/5;
        MA10 = subs10/10;
        MA20 = subs20/20;
    }else if (index >= 9) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-9, 10)];
        int i = 0;
        CGFloat subs10 = 0.0;
        CGFloat subs5  = 0.0;
        for (NSDictionary *dic in array) {
            CGFloat closeValue = [dic[@"close"] floatValue];
            subs10 += closeValue;
            if (i >= 5) {
                subs5 += closeValue;
            }
            i++;
        }
        MA5  = subs5/5;
        MA10 = subs10/10;
        MA20 = 0;
    }else if (index >= 4) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-4, 5)];
        MA5 = [[[array valueForKeyPath:@"close"] valueForKeyPath:@"@avg.floatValue"] floatValue];
        MA10 = 0;
        MA20 = 0;
    }
    
    
    
    
    
    
    /*
    if (index >= 4) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-4, 5)];
        MA5 = [[[array valueForKeyPath:@"close"] valueForKeyPath:@"@avg.floatValue"] floatValue];
    } else {
        MA5 = 0;
    }
    
    if (index >= 9) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-9, 10)];
        MA10 = [[[array valueForKeyPath:@"close"] valueForKeyPath:@"@avg.floatValue"] floatValue];
    } else {
        MA10 = 0;
    }
    
    if (index >= 19) {
        NSArray *array = [_parentDictArray subarrayWithRange:NSMakeRange(index-19, 20)];
        MA20 = [[[array valueForKeyPath:@"close"] valueForKeyPath:@"@avg.floatValue"] floatValue];
    } else {
        MA20 = 0;
    }
    */
}


@end
