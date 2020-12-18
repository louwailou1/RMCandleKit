//
//  RMTimeLineView.h
//  RMCandleKit
//
//  Created by RMCandleKit on 2017/10/11.
//  Copyright © 2017年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMTimeLineView : UIView

@property (nonatomic, strong) UIColor *dottedLineColor;

@property (nonatomic, assign) CGFloat dottedLineLength;

- (void)reset;

- (void)dealTimeDataWithHigh:(NSString *)highStr Low:(NSString *)lowStr Times:(NSArray *)times Swing:(NSString *)swing ClosePrice:(NSString *)closePrice Accuracy:(NSString *)accuracy TimeOffset:(NSMutableArray *)timeOffset xAxisMaxValue:(NSInteger)xAxisMaxValue;

@end
