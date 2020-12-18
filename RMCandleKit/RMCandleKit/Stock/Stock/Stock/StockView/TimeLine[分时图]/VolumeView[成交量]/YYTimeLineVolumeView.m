//
//  YYTimeLineVolumeView.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "YYTimeLineVolumeView.h"
#import "RMCandleStockVariable.h"
#import "RMCandleViewConstant.h"
#import "UIColor+RMCandleStockTheme.h"
@interface YYTimeLineVolumeView()

@property (nonatomic, strong) NSMutableArray *drawPositionModels;

@end
@implementation YYTimeLineVolumeView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!self.drawPositionModels) {
        return;
    }
    
    CGFloat lineMaxY = self.frame.size.height - YYStockLineDayHeight - YYStockLineVolumeViewMinY;
    
    //绘制背景色
    RMCandleVolumePositionModel *lastModel = self.drawPositionModels.lastObject;
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:1 alpha:0.1f].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, lastModel.EndPoint.x, lineMaxY));
    

    
    [self.drawPositionModels enumerateObjectsUsingBlock:^(RMCandleVolumePositionModel  *_Nonnull pModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //绘制成交量线
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1].CGColor);
        CGContextSetLineWidth(ctx, [RMCandleStockVariable timeLineVolumeWidth]);
        const CGPoint solidPoints[] = {pModel.StartPoint, pModel.EndPoint};
        CGContextStrokeLineSegments(ctx, solidPoints, 2);
        
        //绘制日期
        if (pModel.DayDesc.length > 0) {
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor YYStock_topBarNormalTextColor]};
            CGRect rect = [pModel.DayDesc boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                           NSStringDrawingUsesFontLeading
                                                    attributes:attribute
                                                       context:nil];
            
            CGFloat width = rect.size.width;
            if (pModel.StartPoint.x - width/2.f < 0) {
                //最左边判断
                [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x, 0) withAttributes:attribute];
            } else if(pModel.StartPoint.x + width/2.f > self.bounds.size.width) {
                //最右边判断
                [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x - width, 0) withAttributes:attribute];
            } else {
                [pModel.DayDesc drawAtPoint:CGPointMake(pModel.StartPoint.x - width/2.f, 0) withAttributes:attribute];
            }
        }
    }];
    
}

- (void)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*)drawLineModels {
    NSAssert(drawLineModels, @"数据源不能为空");
    //转换为实际坐标
    [self convertToPositionModelsWithXPosition:xPosition drawLineModels:drawLineModels];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)convertToPositionModelsWithXPosition:(CGFloat)startX drawLineModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*)drawLineModels  {
    if (!drawLineModels) return;
    
    [self.drawPositionModels removeAllObjects];
    
    CGFloat minValue =  [[[drawLineModels valueForKeyPath:@"Volume"] valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat maxValue =  [[[drawLineModels valueForKeyPath:@"Volume"] valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minY = YYStockLineVolumeViewMinY+20;
    CGFloat maxY = self.frame.size.height - YYStockLineVolumeViewMinY - YYStockLineDayHeight;
    
    CGFloat unitValue = (maxValue - minValue)/(maxY - minY);
    
    [drawLineModels enumerateObjectsUsingBlock:^(id<RMCandleStockTimeLineProtocol>  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat xPosition = startX + idx * ([RMCandleStockVariable timeLineVolumeWidth] + YYStockTimeLineViewVolumeGap);
        CGFloat yPosition = ABS(maxY - (model.Volume - minValue)/unitValue);
        
        CGPoint startPoint = CGPointMake(xPosition, ABS(yPosition - maxY) > 1 ? yPosition : maxY );
        CGPoint endPoint = CGPointMake(xPosition, maxY);
        
        NSString *dayDesc = model.isShowTimeDesc ? model.TimeDesc : @"";
        
        RMCandleVolumePositionModel *positionModel = [RMCandleVolumePositionModel modelWithStartPoint:startPoint endPoint:endPoint dayDesc:dayDesc];
        [self.drawPositionModels addObject:positionModel];
        
    }];
}
- (NSMutableArray *)drawPositionModels {
    if (!_drawPositionModels) {
        _drawPositionModels = [NSMutableArray array];
    }
    return _drawPositionModels;
}
@end
