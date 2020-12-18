//
//  YYTimeLineView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockTimeLineProtocol.h"
@interface YYTimeLineView : UIView
- (NSArray *)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*)drawLineModels  maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

@end
