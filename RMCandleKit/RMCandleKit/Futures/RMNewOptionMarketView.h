//
//  RMNewOptionMarketView.h
//  RMCandleKit
//
//  Created by RMCandleKit on 2018/12/11.
//  Copyright © 2018年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilsMacro.h"



@interface RMNewOptionMarketView : UIView

- (instancetype)initWithFrame:(CGRect)frame RefreshBlock:(RefreshBlock)refreshBlock;

- (void)dealTimeDataWithHigh:(NSString *)highStr Low:(NSString *)lowStr Times:(NSArray *)times Swing:(NSString *)swing ClosePrice:(NSString *)closePrice Accuracy:(NSString *)accuracy TimeOffset:(NSMutableArray *)timeOffset xAxisMaxValue:(NSInteger)xAxisMaxValue;

- (void)kLineModelWithDictionary:(NSArray<NSDictionary*> *)response RefreshViewType:(RefreshViewType)type;

@end
