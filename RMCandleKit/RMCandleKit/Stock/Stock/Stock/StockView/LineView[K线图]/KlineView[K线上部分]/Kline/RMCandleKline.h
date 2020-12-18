//
//  RMCandleKline.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/7.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockDataProtocol.h"
@class RMCandleLinePositionModel;
@interface RMCandleKline : UIView

- (instancetype)initWithContext:(CGContextRef)context drawModels:(NSArray <id<RMCandleLineDataModelProtocol>>*)drawLineModels linePositionModels:(NSArray <RMCandleLinePositionModel *>*)linePositionModels;

- (void)draw;

@end
