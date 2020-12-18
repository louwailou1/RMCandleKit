//
//  RMCandleVolumePositionModel.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMCandleVolumePositionModel.h"

@implementation RMCandleVolumePositionModel
+ (instancetype) modelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint dayDesc:(NSString *)dayDesc;
{
    RMCandleVolumePositionModel *volumePositionModel = [RMCandleVolumePositionModel new];
    volumePositionModel.StartPoint = startPoint;
    volumePositionModel.EndPoint = endPoint;
    volumePositionModel.DayDesc = dayDesc;
    return volumePositionModel;
}
@end
