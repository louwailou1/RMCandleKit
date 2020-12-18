//
//  RMCandleStockViewMaskView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/16.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockDataProtocol.h"
#import "RMCandleStockTimeLineProtocol.h"
#import "RMCandleViewConstant.h"

@interface RMCandleStockViewMaskView : UIView

/**
 当前长按选中的model
 */
@property (nonatomic, strong) id<RMCandleLineDataModelProtocol> selectedModel;

/**
 K线类型
 */
@property (nonatomic, assign) YYStockType stockType;

@end
