//
//  MAline.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/8.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAline : UIView


- (instancetype)initWithContext:(CGContextRef)context;

- (void)drawWithColor:(UIColor *)lineColor maPositions:(NSArray *)maPositions;

@end
