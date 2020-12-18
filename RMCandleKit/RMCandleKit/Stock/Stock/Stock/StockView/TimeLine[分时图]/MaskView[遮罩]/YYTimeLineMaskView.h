//
//  YYTimeLineMaskView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockTimeLineProtocol.h"

@interface YYTimeLineMaskView : UIView

//当前长按选中的model
@property (nonatomic, strong) id<RMCandleStockTimeLineProtocol> selectedModel;

//当前长按选中的位置model
@property (nonatomic, assign) CGPoint selectedPoint;

//当前的滑动scrollview
@property (nonatomic, strong) UIScrollView *stockScrollView;

@end
