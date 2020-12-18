//
//  YYTimeLineVolumeView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockTimeLineProtocol.h"
#import "RMCandleVolumePositionModel.h"
@interface YYTimeLineVolumeView : UIView

- (void)drawViewWithXPosition:(CGFloat)xPosition drawModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*)drawLineModels;

@end
