//
//  RMCandleBaseMinuteView.h
//  RMCandleKit
//
//  Created byRMCandleKit on 2019/3/25.
//  Copyright © 2019RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMCandleBaseMinuteView : UIView

@property (nonatomic, strong) UIColor *stockBackGroundColor;

- (void)minuteModelWithDictionary:(NSArray<NSDictionary*> *)response;

@property (nonatomic, strong) UIView *indicatorBgView;

@end

NS_ASSUME_NONNULL_END
