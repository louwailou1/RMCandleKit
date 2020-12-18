//
//  RMCandleKlineMaskView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/9.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockDataProtocol.h"
#import "RMCandleLinePositionModel.h"
@interface RMCandleKlineMaskView : UIView

//当前长按选中的model
@property (nonatomic, strong) id<RMCandleLineDataModelProtocol> selectedModel;

//当前长按选中的位置model
@property (nonatomic, strong) RMCandleLinePositionModel *selectedPositionModel;

//当前的滑动scrollview
@property (nonatomic, strong) UIScrollView *stockScrollView;

@end
