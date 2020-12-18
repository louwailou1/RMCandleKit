//
//  RMCandleTimeOffsetView.h
//  RMCandleKit
//
//  Created by blue on 2017/11/7.
//  Copyright © 2017年 lsb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCandleTimeOffsetView : UIView

@property (nonatomic, copy) NSArray *timeOffsets;

//- (void)drawWithStartTime:(NSInteger)startTime EndTime:(NSInteger)endTime;

- (void)drawWithShowTimeArr:(NSArray *)showTimeArr TimeScaleArr:(NSArray *)timeScaleArr;

- (void)drawWithHeaderTime:(NSInteger)startTime FooterTime:(NSInteger)endTime;

@end
