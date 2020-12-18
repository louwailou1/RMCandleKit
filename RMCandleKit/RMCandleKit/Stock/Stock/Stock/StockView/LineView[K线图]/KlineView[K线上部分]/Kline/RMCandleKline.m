//
//  RMCandleKline.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/7.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMCandleKline.h"
#import "UIColor+RMCandleStockTheme.h"
#import "RMCandleLinePositionModel.h"
#import "RMCandleStockVariable.h"
#import "RMCandleViewConstant.h"
@interface RMCandleKline()
@property (nonatomic, assign) CGContextRef context;
/**
 *  K线的位置model
 */
@property (nonatomic, strong) NSArray <RMCandleLinePositionModel *>*linePositionModels;

/**
 *  K线的位置model
 */
@property (nonatomic, strong) NSArray <id<RMCandleLineDataModelProtocol>> *drawLineModels;
@end

@implementation RMCandleKline


- (instancetype)initWithContext:(CGContextRef)context drawModels:(NSArray <id<RMCandleLineDataModelProtocol>>*)drawLineModels linePositionModels:(NSArray <RMCandleLinePositionModel *>*)linePositionModels {
    self = [super init];
    if (self) {
        _context = context;
        _drawLineModels = drawLineModels;
        _linePositionModels = linePositionModels;
    }
    return self;
}

- (void)draw {
    if (!self.linePositionModels || !self.context) return;
    
    CGContextRef ctx = self.context;
    
    [self.linePositionModels enumerateObjectsUsingBlock:^(RMCandleLinePositionModel * _Nonnull linePositionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIColor *strokeColor;
        if ([[self.drawLineModels[idx] Open] floatValue] < [[self.drawLineModels[idx] Close] floatValue]) {
            strokeColor = [UIColor YYStock_increaseColor];
        } else if ([[self.drawLineModels[idx] Open] floatValue] > [[self.drawLineModels[idx] Close] floatValue]) {
            strokeColor = [UIColor YYStock_decreaseColor];
        } else {
            if ([[self.drawLineModels[idx] Open] floatValue] >= [[[self.drawLineModels[idx] preDataModel] Close] floatValue]) {
                strokeColor = [UIColor YYStock_increaseColor];
            } else {
                strokeColor = [UIColor YYStock_decreaseColor];
            }
        }
        
//        UIColor *strokeColor = [[self.drawLineModels[idx] Open] floatValue] <= [[self.drawLineModels[idx] Close] floatValue]? [UIColor YYStock_increaseColor] : [UIColor YYStock_decreaseColor];l
        
        
        
        CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
        
        CGContextSetLineWidth(ctx, [RMCandleStockVariable lineWidth]);
        const CGPoint solidPoints[] = {linePositionModel.OpenPoint, linePositionModel.ClosePoint};
        CGContextStrokeLineSegments(ctx, solidPoints, 2);
        
        CGContextSetLineWidth(ctx, YYStockShadowLineWidth);
        const CGPoint shadowPoints[] = {linePositionModel.HighPoint, linePositionModel.LowPoint};
        CGContextStrokeLineSegments(ctx, shadowPoints, 2);
        
        //绘制红色空心线
//        CGFloat gap = 2.f;
//        if ([[self.drawLineModels[idx] Open] floatValue] <= [[self.drawLineModels[idx] Close] floatValue] && ABS(linePositionModel.OpenPoint.y - linePositionModel.ClosePoint.y) > gap) {
//            CGContextSetStrokeColorWithColor(ctx, [UIColor YYStock_bgColor].CGColor);
//            CGContextSetLineWidth(ctx, [RMCandleStockVariable lineWidth] - gap);
//            const CGPoint solidPoints[] = {CGPointMake(linePositionModel.OpenPoint.x, linePositionModel.OpenPoint.y - gap/2.f),CGPointMake(linePositionModel.ClosePoint.x, linePositionModel.ClosePoint.y + gap/2.f)};
//            CGContextStrokeLineSegments(ctx, solidPoints, 2);
//        }
    }];

}

@end
