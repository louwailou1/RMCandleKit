//
//  RMCandleStockScrollView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/7.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleViewConstant.h"
@interface RMCandleStockScrollView : UIScrollView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) YYStockType stockType;

@property (nonatomic, assign) BOOL isShowBgLine;
@end
