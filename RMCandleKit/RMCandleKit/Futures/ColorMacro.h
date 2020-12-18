//
//  ColorMacro.h
//  GoldenTrader
//
//  Created by lsb on 15/5/26.
//  Copyright (c) 2015年 lsb. All rights reserved.
//

#ifndef GoldenTrader_ColorMacro_h
#define GoldenTrader_ColorMacro_h
//----------------------颜色类---------------------------
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
// 相同数值的颜色
#define RGBS(a)  [UIColor colorWithRed:(a)/255.0 green:(a)/255.0 blue:(a)/255.0 alpha:1.0]

// app 主色调的颜色
#define APPCORLOR   RGB(217, 58, 59)
#define NavBarColor RGBS(39)
#define GreenColor  RGB(30,140,56)
#define RedColor    RGB(234, 53, 53)
#define BlueColor    RGB(61, 129, 216)
#define GrayTextColor RGBS(102)
#define UnableColor   RGBS(204)
#define BorderColor   RGB (202,213,227)
#define BackColor     RGB (235,235,235)
#define DarkLineColor RGB (204,204,204)
#define YellowColor   RGB (255,165,48)
#define GrayColor     RGB(80, 96, 92)
#define MidGrayColor RGBS(204) //失效、辅助性文字
#define DarkGrayColor RGBS(153) //提示性文字
#define LightBlackColor RGBS(102) //辅助、默认状态文字
#define DarkBlackColor RGBS(51) //标题、正文等主要文字
#define liveCellLineColor RGBS(222)

//----------------------颜色类--------------------------

//----------------------字体大小-----------------//

#define FontSize(a) [UIFont systemFontOfSize:(a)]
#define SuperFont  [UIFont systemFontOfSize:18]
#define BigFont    [UIFont systemFontOfSize:16]
#define MidFont    [UIFont systemFontOfSize:14]
#define SmallFont    [UIFont systemFontOfSize:12]

#define ZagRegularFont  @"Zag Regular"
#define ZagBoldFont     @"Zag Bold"


//----------------------字体大小-----------------//

//----------------------通知--------------------//

#endif
