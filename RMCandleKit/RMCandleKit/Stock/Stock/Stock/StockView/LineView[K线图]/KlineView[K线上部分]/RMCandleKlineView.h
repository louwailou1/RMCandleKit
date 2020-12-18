//
//  RMCandleKlineView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/6.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockDataProtocol.h"

@interface RMCandleKlineView : UIView

- (NSArray *)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSMutableArray <id<RMCandleLineDataModelProtocol>>*)drawLineModels  maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

@end
