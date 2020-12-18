//
//  RMCandleBaseKLineView.h
//  RMCandleKit
//
//  Created by RMCandleKit on 2017/9/7.
//  Copyright © 2017年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMCandleBaseKLineView : UIView

@property (nonatomic, strong) UIColor *stockBackGroundColor;

- (void)kLineModelWithDictionary:(NSArray<NSDictionary*> *)response;

@property (nonatomic, strong) UIView *indicatorBgView;

@end
