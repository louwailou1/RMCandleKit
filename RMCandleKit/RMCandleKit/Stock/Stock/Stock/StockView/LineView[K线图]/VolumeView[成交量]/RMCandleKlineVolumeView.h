//
//  RMCandleKlineVolumeView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/7.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockDataProtocol.h"
#import "RMCandleLinePositionModel.h"
@interface RMCandleKlineVolumeView : UIView

@property (nonatomic, weak) UIScrollView *parentScrollView;

- (void)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<RMCandleLineDataModelProtocol>>*)drawLineModels linePositionModels:(NSArray <RMCandleLinePositionModel *>*)linePositionModels;

@end
