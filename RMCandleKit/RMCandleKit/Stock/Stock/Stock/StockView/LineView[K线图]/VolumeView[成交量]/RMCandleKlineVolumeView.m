//
//  RMCandleKlineVolumeView.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/7.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMCandleKlineVolumeView.h"
#import "RMCandleStockVariable.h"
#import "RMCandleViewConstant.h"
#import "RMCandleVolumePositionModel.h"
#import "UIColor+RMCandleStockTheme.h"
@interface RMCandleKlineVolumeView()

@property (nonatomic, strong) NSMutableArray *drawPositionModels;

/**
 上面K线的位置models数组
 */
@property (nonatomic, strong) NSArray *linePositionModels;


@property (nonatomic, strong) NSArray <id<RMCandleLineDataModelProtocol>> *drawLineModels;

@end

@implementation RMCandleKlineVolumeView


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!self.drawPositionModels) {
        return;
    }
    
    NSAssert(self.linePositionModels.count == self.drawPositionModels.count, @"K线图和成交量的个数不相等");
    
    
    __block CGFloat lastRectX = 0;

    [self.drawPositionModels enumerateObjectsUsingBlock:^(RMCandleVolumePositionModel  *_Nonnull pModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
//        UIColor *strokeColor = [[dataModel Open] floatValue] <= [[dataModel Close] floatValue] ? [UIColor YYStock_increaseColor] : [UIColor YYStock_decreaseColor];
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
        
        CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
        CGContextSetLineWidth(ctx, [RMCandleStockVariable lineWidth]);
        const CGPoint solidPoints[] = {pModel.StartPoint, pModel.EndPoint};
        CGContextStrokeLineSegments(ctx, solidPoints, 2);
        
        //绘制红色空心线
//        CGFloat gap = 2.f;
//        
//        if ([strokeColor isEqual:[UIColor YYStock_increaseColor]] && ABS(pModel.StartPoint.y - pModel.EndPoint.y) > gap) {
//            CGContextSetStrokeColorWithColor(ctx, [UIColor YYStock_bgColor].CGColor);
//            CGContextSetLineWidth(ctx, [RMCandleStockVariable lineWidth] - gap);
//            const CGPoint solidPoints[] = {CGPointMake(pModel.StartPoint.x, pModel.StartPoint.y + gap/2),CGPointMake(pModel.StartPoint.x, pModel.EndPoint.y - gap/2)};
//            CGContextStrokeLineSegments(ctx, solidPoints, 2);
//        }
    }];
    
    
    
    __block BOOL firstFlag = YES;
    [[[self.drawPositionModels reverseObjectEnumerator] allObjects] enumerateObjectsUsingBlock:^(RMCandleVolumePositionModel  *_Nonnull pModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //绘制日期
        if (pModel.DayDesc.length > 0) {
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor YYStock_topBarNormalTextColor]};
            CGRect rect1 = [pModel.DayDesc boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                        options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                            NSStringDrawingUsesFontLeading
                                                     attributes:attribute
                                                        context:nil];
            
            CGFloat width = rect1.size.width;
            
            if (firstFlag) {
                firstFlag = NO;

                if (pModel.StartPoint.x - width/2.f < 0) {
                    lastRectX = 0;
                    [pModel.DayDesc drawAtPoint:CGPointMake(0, pModel.EndPoint.y) withAttributes:attribute];
                } else {
                    if (pModel.StartPoint.x + width/2.f - MIN(self.parentScrollView.contentOffset.x,self.parentScrollView.contentSize.width - self.bounds.size.width) < self.parentScrollView.bounds.size.width) {
                        lastRectX = pModel.StartPoint.x - width/2.f;
                        [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x - width/2, pModel.EndPoint.y) withAttributes:attribute];
                    } else {
                        lastRectX = pModel.StartPoint.x + [RMCandleStockVariable lineWidth]/2.f - width;
                        [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x  + [RMCandleStockVariable lineWidth]/2.f - width, pModel.EndPoint.y) withAttributes:attribute];
                    }
                }
            } else if ( pModel.StartPoint.x + width/2.f < lastRectX - 50 ) {
                lastRectX = pModel.StartPoint.x - width/2.f;
                [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x - width/2, pModel.EndPoint.y) withAttributes:attribute];
            }
        }
    }];
}

- (void)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<RMCandleLineDataModelProtocol>>*)drawLineModels linePositionModels:(NSArray <RMCandleLinePositionModel *>*)linePositionModels {
    NSAssert(drawLineModels, @"数据源不能为空");
    _linePositionModels = linePositionModels;
    //转换为实际坐标
    [self convertToPositionModelsWithXPosition:xPosition drawLineModels:drawLineModels];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (NSArray *)convertToPositionModelsWithXPosition:(CGFloat)startX drawLineModels:(NSArray <id<RMCandleLineDataModelProtocol>>*)drawLineModels  {
    if (!drawLineModels) return nil;
    self.drawLineModels = drawLineModels;
    [self.drawPositionModels removeAllObjects];
    
    CGFloat minValue =  0;
    CGFloat maxValue =  [[[drawLineModels valueForKeyPath:@"Volume"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minY = YYStockLineVolumeViewMinY;
    CGFloat maxY = self.frame.size.height - YYStockLineVolumeViewMinY - YYStockLineDayHeight;
    
    CGFloat unitValue = (maxValue - minValue)/(maxY - minY);
    
    [drawLineModels enumerateObjectsUsingBlock:^(id<RMCandleLineDataModelProtocol>  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat xPosition = startX + idx * ([RMCandleStockVariable lineWidth] + [RMCandleStockVariable lineGap]);
        CGFloat yPosition = ABS(maxY - (model.Volume - minValue)/unitValue);
        CGPoint startPoint = CGPointMake(xPosition, (ABS(yPosition - maxY) > 0 && ABS(yPosition - maxY) < 0.5) ? maxY - 0.5 : yPosition);
        CGPoint endPoint = CGPointMake(xPosition, maxY);
        
        RMCandleVolumePositionModel *positionModel = [RMCandleVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint dayDesc:model.Day];
        [self.drawPositionModels addObject:positionModel];
        
    }];
    
    return self.drawPositionModels ;
}
- (NSMutableArray *)drawPositionModels {
    if (!_drawPositionModels) {
        _drawPositionModels = [NSMutableArray array];
    }
    return _drawPositionModels;
}

@end
