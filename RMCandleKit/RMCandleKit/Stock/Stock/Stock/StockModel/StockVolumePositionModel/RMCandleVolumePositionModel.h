//
//  RMCandleVolumePositionModel.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface RMCandleVolumePositionModel : NSObject
/**
 *  开始点
 */
@property (nonatomic, assign) CGPoint StartPoint;

/**
 *  结束点
 */
@property (nonatomic, assign) CGPoint EndPoint;

/**
 *  日期
 */
@property (nonatomic, copy) NSString *DayDesc;

/**
 *  工厂方法
 */
+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dayDesc:(NSString *)dayDesc;
@end
