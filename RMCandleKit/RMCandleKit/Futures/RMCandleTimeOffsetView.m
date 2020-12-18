//
//  RMCandleTimeOffsetView.m
//  RMCandleKit
//
//  Created by blue on 2017/11/7.
//  Copyright © 2017年 lsb. All rights reserved.
//

#import "RMCandleTimeOffsetView.h"
#import "ColorMacro.h"

@implementation RMCandleTimeOffsetView

// 每一个小时或者每两个小时画时间刻度
//- (void)drawWithStartTime:(NSInteger)startTime EndTime:(NSInteger)endTime {
//    if (endTime < startTime) {return;}
//
//    //先移除旧的文字层
//    NSArray *tempArr = [self.layer.sublayers copy];
//    for (CALayer *layer in tempArr) {
//        if ([layer isKindOfClass:[CATextLayer class]]) {
//            [layer removeFromSuperlayer];
//        }
//    }
//
//
//    //总分钟数
//    NSInteger subMinute = (endTime - startTime)/100*60 + (endTime - startTime)%100;
//    //开始分钟数
//    NSInteger startMinute = startTime/100*60 + startTime%100;
//
//    //第一个时间的frame
//    CGFloat height = self.bounds.size.height;
//
//    NSInteger timeMargin = 60;
//
//    NSInteger timeCount =  subMinute/timeMargin;//能显示的时间刻度
//
//    if (timeCount >= 5) {
//        timeMargin= 120;
//        timeCount = subMinute/timeMargin;
//    }
//
//    CGFloat selfWidth = self.bounds.size.width;
//    CGFloat avgWidth  = selfWidth*(timeCount*timeMargin*1.0/subMinute)/timeCount;
//
//
//    for (NSInteger i = 0; i<timeCount; i++) {
//        NSString *currentTime = @"";
//        NSInteger currentMinute = startMinute + timeMargin*i;
//        currentTime = [self returnStringAccordToMinutes:currentMinute];
//        CATextLayer *textLayer = [self makeTextLayerWithText:currentTime];
//        textLayer.frame = CGRectMake(2 + avgWidth*i,0, 36, height);
//        [self.layer addSublayer:textLayer];
//    }
//}
    
    
- (void)drawWithShowTimeArr:(NSArray *)showTimeArr TimeScaleArr:(NSArray *)timeScaleArr {
    if (showTimeArr.count != timeScaleArr.count) {return;}
    
    //先移除旧的文字层
    NSArray *tempArr = [self.layer.sublayers copy];
    for (CALayer *layer in tempArr) {
        if ([layer isKindOfClass:[CATextLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CGFloat selfWidth   = self.bounds.size.width;
    CGFloat selfHeight  = self.bounds.size.height;
    
    for (NSInteger i = 0; i<showTimeArr.count; i++) {
        NSString *currentTime = showTimeArr[i];
        CATextLayer *textLayer = [self makeTextLayerWithText:currentTime];
        CGFloat x = 2 + selfWidth*[timeScaleArr[i] floatValue] - 35;
        if (i == 0) {
            x = 2 + selfWidth*[timeScaleArr[i] floatValue];
        }
        textLayer.frame = CGRectMake(x,0, 30, selfHeight);
        textLayer.alignmentMode = @"left";
        [self.layer addSublayer:textLayer];
    }
}
    

// 时间刻度只画一头一尾
- (void)drawWithHeaderTime:(NSInteger)startTime FooterTime:(NSInteger)endTime {
    if (endTime < startTime) {return;}
    
    //先移除旧的文字层
    NSArray *tempArr = [self.layer.sublayers copy];
    for (CALayer *layer in tempArr) {
        if ([layer isKindOfClass:[CATextLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CGFloat selfWidth   = self.bounds.size.width;
    CGFloat selfHeight  = self.bounds.size.height;
    
    // 开始分钟
    NSInteger startMinute = startTime/100*60 + startTime%100;
    NSString *startTimeStr = [self returnStringAccordToMinutes:startMinute];
    CATextLayer *textLayer1 = [self makeTextLayerWithText:startTimeStr];
    textLayer1.frame = CGRectMake(2 ,0 , 36, selfHeight);
    [self.layer addSublayer:textLayer1];
    
    // 结束分钟
    NSInteger endMinute = endTime/100*60 + endTime%100;
    NSString *endTimeStr = [self returnStringAccordToMinutes:endMinute];
    CATextLayer *textLayer2 = [self makeTextLayerWithText:endTimeStr];
    textLayer2.frame = CGRectMake(selfWidth-40-36 ,0, 36, selfHeight);
    [self.layer addSublayer:textLayer2];
}

- (NSString *)returnStringAccordToMinutes:(NSInteger)currentMinute {
    NSString *currentTime = @"";
    if (currentMinute/60 >= 24) {
        if (currentMinute%60 == 0) {
            currentTime = [NSString stringWithFormat:@"%ld:00",currentMinute/60-24];
        }else {
            currentTime = [NSString stringWithFormat:@"%ld:%ld",currentMinute/60-24,currentMinute%60];
        }
    }else if (currentMinute/60 >= 10) {
        if (currentMinute%60 == 0) {
            currentTime = [NSString stringWithFormat:@"%ld:00",currentMinute/60];
        }else {
            currentTime = [NSString stringWithFormat:@"%ld:%ld",currentMinute/60,currentMinute%60];
        }
        
    }else {
        if (currentMinute%60 == 0) {
            currentTime = [NSString stringWithFormat:@"0%ld:00",currentMinute/60];
        }else {
            currentTime = [NSString stringWithFormat:@"0%ld:%ld",currentMinute/60,currentMinute%60];
        }
    }
    return currentTime;
}

#pragma mark - private methods
- (CATextLayer *)makeTextLayerWithText:(NSString *)text {
    CATextLayer *textLayer = [CATextLayer layer] ;
    //textLayer.backgroundColor = APPCORLOR.CGColor;
    textLayer.foregroundColor = RGBS(120).CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.string = text;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    UIFont *font = [UIFont systemFontOfSize:10];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    return textLayer;
}

@end
