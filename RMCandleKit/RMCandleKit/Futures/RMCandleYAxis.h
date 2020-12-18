//
//  RMCandleYAxis.h
//  A50
//
//  Created by lsb on 16/4/13.
//  Copyright © 2016年 lsb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RMCandleYAxis : NSObject


@property (nonatomic, assign) double YOffset;// y 偏移点

@property (nonatomic, assign)double scale; // 比例尺 一个单位代表多少值

@property (nonatomic, assign)double datumValue; // 基准值

@property (nonatomic, assign) double scaleValue; // 刻度值



- (double)calculateYCoordinate:(double)value;



@end
