//
//  RMCandleAnimateView.m
//  A50
//
//  Created by lsb on 16/4/14.
//  Copyright © 2016年 lsb. All rights reserved.
//

#import "RMCandleAnimateView.h"
#import "ColorMacro.h"

@implementation RMCandleAnimateView

- (id)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self setupWithFrame:frame];
    }
    return self;
}
- (void)setupWithFrame:(CGRect)frame {
    
    CAShapeLayer *outerLayer = [CAShapeLayer layer];
    CAShapeLayer *innerLayer = [CAShapeLayer layer];
    outerLayer.lineWidth = 0.5f;
    outerLayer.strokeColor = RedColor.CGColor;
    outerLayer.fillColor = nil;
    innerLayer.fillColor = RedColor.CGColor;
    [self.layer addSublayer:outerLayer];
    [self.layer addSublayer:innerLayer];

    outerLayer.frame = self.bounds;
    innerLayer.frame = self.bounds;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat realWidth= width>height ? height :width;
    CGFloat radius =(realWidth-1)/2.0;
    CGPoint  center = CGPointMake(width/2.0, height/2.0);
    outerLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius: radius startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    innerLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:1 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.65;
    animation.fromValue = @(1);
    animation.toValue  = @(1.4);
    animation.repeatCount = HUGE;
    animation.autoreverses = YES;
    [self.layer addAnimation:animation forKey:nil];
    
}
@end
