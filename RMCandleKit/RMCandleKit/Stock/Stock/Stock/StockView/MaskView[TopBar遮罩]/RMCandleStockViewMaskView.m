//
//  RMCandleStockViewMaskView.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/16.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMCandleStockViewMaskView.h"
#import "RMCandleViewConstant.h"
#import "RMCandleStockVariable.h"
#import "UIColor+RMCandleStockTheme.h"

@interface RMCandleStockViewMaskView()

@property (nonatomic, copy) NSArray *drawKlineDescTexts;

@property (nonatomic, copy) NSArray *drawTimeLineDescTexts;


@end
@implementation RMCandleStockViewMaskView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawDashLine:rect];
}

/**
 绘制长按的背景线
 */
- (void)drawDashLine:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //绘制背景
    CGContextSetFillColorWithColor(ctx, [UIColor YYStock_bgColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    switch (self.stockType) {
        case YYStockTypeLine:
            [self drawLineMask:ctx rect:rect];
            break;
        case YYStockTypeTimeLine:
            [self drawTimeLineMask:ctx rect:rect];
            break;
        default:
            break;
    }
}



/**
 绘制分时的Mask
 
 @param ctx  context
 @param rect rect
 */
- (void)drawTimeLineMask:(CGContextRef)ctx rect:(CGRect)rect {
    //绘制选中日期
    CGContextSetStrokeColorWithColor(ctx, [UIColor YYStock_textColor].CGColor);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor YYStock_textColor]};
    NSString *drawText = [self.selectedModel DayDatail];
    CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
    CGRect drawRect= CGRectMake(YYStockTimeLineViewLeftGap, (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor YYStock_textColor]};
    
    CGFloat gap = 95;
    [self.drawTimeLineDescTexts enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(50 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor YYStock_topBarSelectedTextColor]};
    [[self drawTimeLineTexts] enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(50 + 37 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    //绘制选中成交量
//    drawText = @"成交量：";
//    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor YYStock_textColor]};
//    textRect = [self rectOfNSString:drawText attribute:attribute];
//    drawRect = CGRectMake(50 + 290 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
//    [drawText drawInRect:drawRect withAttributes:attribute];
    
    
    CGFloat volume = [self.selectedModel Volume];
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor YYStock_topBarSelectedTextColor]};
    //尝试转为万手
    CGFloat wVolume = volume/10000.f;
    if (wVolume > 1) {
        //尝试转为亿手
        CGFloat yVolume = wVolume/10000.f;
        if (yVolume > 1) {
            drawText = [NSString stringWithFormat:@"%.2f  亿手",yVolume];
        } else {
            drawText = [NSString stringWithFormat:@"%.2f  万手",wVolume];
        }
    } else {
        drawText = [NSString stringWithFormat:@"%.2f  手",volume];
    }
    textRect = [self rectOfNSString:drawText attribute:attribute];
    drawRect = CGRectMake(50 + 340 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
}

/**
 绘制K线的Mask

 @param ctx  context
 @param rect rect
 */
- (void)drawLineMask:(CGContextRef)ctx rect:(CGRect)rect {
    //绘制选中日期
    CGContextSetStrokeColorWithColor(ctx, [UIColor YYStock_textColor].CGColor);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor YYStock_textColor]};
    NSString *drawText = [self.selectedModel DayDatail];
    CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
    CGRect drawRect= CGRectMake(YYStockTimeLineViewLeftGap, (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor YYStock_textColor]};
    
    CGFloat gap = 75;
    [self.drawKlineDescTexts enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(90 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor YYStock_topBarSelectedTextColor]};
    [[self drawKlineTexts] enumerateObjectsUsingBlock:^(NSString *  _Nonnull drawText, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect textRect = [self rectOfNSString:drawText attribute:attribute];
        CGRect drawRect = CGRectMake(90 + 20 + gap * idx , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
        [drawText drawInRect:drawRect withAttributes:attribute];
    }];
    
    //绘制选中成交量
    drawText = @"成交量：";
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor YYStock_textColor]};
    textRect = [self rectOfNSString:drawText attribute:attribute];
    drawRect = CGRectMake(90 + 300 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
    
    
    CGFloat volume = [self.selectedModel Volume];
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor YYStock_topBarSelectedTextColor]};
    //尝试转为万手
    CGFloat wVolume = volume/10000.f;
    if (wVolume > 1) {
        //尝试转为亿手
        CGFloat yVolume = wVolume/10000.f;
        if (yVolume > 1) {
            drawText = [NSString stringWithFormat:@"%.2f  亿手",yVolume];
        } else {
            drawText = [NSString stringWithFormat:@"%.2f  万手",wVolume];
        }
    } else {
        drawText = [NSString stringWithFormat:@"%.2f  手",volume];
    }
    textRect = [self rectOfNSString:drawText attribute:attribute];
    drawRect = CGRectMake(90 + 350 , (rect.size.height - textRect.size.height)/2.f, textRect.size.width, textRect.size.height);
    [drawText drawInRect:drawRect withAttributes:attribute];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

- (NSArray *)drawKlineDescTexts {
    if (!_drawKlineDescTexts) {
        _drawKlineDescTexts = @[@"高：",@"开：",@"低：",@"收："];
    }
    return _drawKlineDescTexts;
}

- (NSArray *)drawTimeLineDescTexts {
    if (!_drawTimeLineDescTexts) {
        _drawTimeLineDescTexts = @[@"价格：",@"涨跌：",@"均价："];
    }
    return _drawTimeLineDescTexts;
}


- (NSArray *)drawKlineTexts {
    return @[
             [NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,[self.selectedModel.High floatValue]],
             [NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,[self.selectedModel.Open floatValue]],
             [NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,[self.selectedModel.Low floatValue]],
             [NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,[self.selectedModel.Close floatValue]],
             ];
}

- (NSArray *)drawTimeLineTexts {
    return @[
             [NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,[((id<RMCandleStockTimeLineProtocol>)self.selectedModel).Price floatValue]],
             [NSString stringWithFormat:@"%.2f%%",([[((id<RMCandleStockTimeLineProtocol>)self.selectedModel) Price] floatValue] - [((id<RMCandleStockTimeLineProtocol>)self.selectedModel) AvgPrice])*100/[((id<RMCandleStockTimeLineProtocol>)self.selectedModel) AvgPrice]],
             [NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,((id<RMCandleStockTimeLineProtocol>)self.selectedModel).AvgPrice],
             ];
}
@end
