/*
 作者：  RMCandleKit
 文件：  UIColor+RMCandleStockTheme.m
 版本：  1.0 <2016.10.05>
 */

#import "UIColor+RMCandleStockTheme.h"

@implementation UIColor (RMCandleStockTheme)

+ (UIColor *)colorWithHex:(UInt32)hex {
    return [UIColor colorWithHex:hex alpha:1.f];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

/************************************K线颜色配置***************************************/

/**
 *  整体背景颜色
 */
+(UIColor *)YYStock_bgColor {
    return [UIColor colorWithHex:0xFFFFFF];
}

/**
 *  K线图背景辅助线颜色
 */
+(UIColor *)YYStock_bgLineColor {
    return [UIColor colorWithHex:0xE3E3E3];
}

/**
 *  主文字颜色
 */
+(UIColor *)YYStock_textColor {
    return [UIColor colorWithHex:0xFFFFFF];
}


/**
 *  MA5线颜色
 */
+(UIColor *)YYStock_MA5LineColor {
    return [UIColor colorWithHex:0xFEB911];
}

/**
 *  MA10线颜色
 */
+(UIColor *)YYStock_MA10LineColor {
    return [UIColor colorWithHex:0x60CFFF];
}

/**
 *  MA20线颜色
 */
+(UIColor *)YYStock_MA20LineColor {
    return [UIColor colorWithHex:0xF184F5];
}

/**
 *  长按线颜色
 */
+(UIColor *)YYStock_selectedLineColor {
    return [UIColor colorWithHex:0xACAAA9];
}

/**
 *  长按出现的圆点的颜色
 */
+(UIColor *)YYStock_selectedPointColor {
    return [UIColor YYStock_increaseColor                                                                                  ];
}

/**
 *  长按出现的方块背景颜色
 */
+(UIColor *)YYStock_selectedRectBgColor {
    return [UIColor colorWithHex:0x659EE0];
}

/**
 *  长按出现的方块文字颜色
 */
+(UIColor *)YYStock_selectedRectTextColor {
    return [UIColor colorWithHex:0xffffff];
}

/**
 *  分时线颜色
 */
+(UIColor *)YYStock_TimeLineColor {
//    return [UIColor colorWithRed:43.0/255 green:132.0/255 blue:252.0/255 alpha:1];
    return [UIColor colorWithRed:50.0/255 green:159.0/255 blue:210.0/255 alpha:1];
}

/**
 *  分时均线颜色
 */
+(UIColor *)YYStock_averageTimeLineColor {
    return [UIColor colorWithRed:152.0/255 green:152.0/255 blue:152.0/255 alpha:1];
}

/**
 *  分时线下方背景色
 */
+(UIColor *)YYStock_timeLineBgColor {
//    return [UIColor colorWithRed:43.0/255 green:132.0/255 blue:252.0/255 alpha:0.1f];
    return [UIColor colorWithRed:126.0/255 green:206.0/255 blue:253.0/255 alpha:0.25f];
}

/**
 *  涨的颜色
 */
+(UIColor *)YYStock_increaseColor {
    return [UIColor colorWithHex:0xFF0000];
}

/**
 *  跌的颜色
 */
+(UIColor *)YYStock_decreaseColor {
    return [UIColor colorWithHex:0x009200];
}


/************************************TopBar颜色配置***************************************/

/**
 *  顶部TopBar文字默认颜色
 */
+(UIColor *)YYStock_topBarNormalTextColor {
//    return [UIColor colorWithHex:0xAFAFB3];
    return [UIColor colorWithHex:0x8991A6];
}

/**
 *  顶部TopBar文字选中颜色
 */
+(UIColor *)YYStock_topBarSelectedTextColor {
    return [UIColor colorWithHex:0xFFFFFF];
    
    //return [UIColor colorWithHex:0x4A90E2];
}

/**
 *  顶部TopBar选中块辅助线颜色
 */
+(UIColor *)YYStock_topBarSelectedLineColor {
    return [UIColor colorWithHex:0xFFFFFF];
    //return [UIColor colorWithHex:0x4A90E2];
}

@end
