//
//  RMCandleLinePositionModel.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMCandleLinePositionModel.h"

@implementation RMCandleLinePositionModel
+ (instancetype) modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint
{
    RMCandleLinePositionModel *model = [RMCandleLinePositionModel new];
    model.OpenPoint = openPoint;
    model.ClosePoint = closePoint;
    model.HighPoint = highPoint;
    model.LowPoint = lowPoint;
    return model;
}
@end
