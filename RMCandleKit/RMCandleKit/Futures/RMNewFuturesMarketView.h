//
//  RMNewFuturesMarketView.h
//  RMCandleKit
//
//  Created by RMCandleKit on 2018/2/26.
//  Copyright © 2018年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilsMacro.h"

@interface RMNewFuturesMarketView : UIView
    
- (instancetype)initWithFrame:(CGRect)frame RefreshBlock:(RefreshBlock)refreshBlock;

- (void)dealTimeDataWithHigh:(NSString *)highStr Low:(NSString *)lowStr Times:(NSArray *)times Swing:(NSString *)swing ClosePrice:(NSString *)closePrice Accuracy:(NSString *)accuracy TimeOffset:(NSMutableArray *)timeOffset xAxisMaxValue:(NSInteger)xAxisMaxValue;
    
- (void)kLineModelWithDictionary:(NSArray<NSDictionary*> *)response RefreshViewType:(RefreshViewType)type;
    
- (void)dayKLineModelWithDictionary:(NSArray<NSDictionary*> *)response;
- (void)fiveKLineModelWithDictionary:(NSArray<NSDictionary*> *)response;
    
@end
