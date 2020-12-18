//
//  RMCandlePageToolBar.m
//  RMCandleKit
//
//  Created by RMCandleKit on 15/6/9.
//  Copyright (c) 2015年 RMCandleKit. All rights reserved.
//

#import "RMCandlePageToolBar.h"
#import "ColorMacro.h"
#import "RMCandleLineView.h"

#define WIDTH         CGRectGetWidth([UIScreen mainScreen].bounds)

@interface RMCandlePageToolBar (){
    NSInteger currentSelectIndex;
    CGFloat  offsetWidth;
    NSLayoutConstraint *leftConstraint;
}
@end

@implementation RMCandlePageToolBar



-(void)dealloc{
    _delegate=nil;
}

-(instancetype)initWithTitles:(NSArray *)titles{
    self=[super init];
    if (self) {
        [self setupWithTitles:titles];

    }
    return self;
}
-(void)setupWithTitles:(NSArray *)titles{
    self.backgroundColor=[UIColor whiteColor];
    NSInteger count=titles.count;
    CGFloat width=WIDTH/(count*1.0);
    offsetWidth=width;
    currentSelectIndex=0;
    for (int i=0; i<count; i++) {
        UIButton *btn=[self itemButton];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag=(i+1000);
        btn.frame=CGRectMake(width*i, 2, width,26);
    }
    UIButton *btn=(UIButton *)[self viewWithTag:1000];
    btn.selected=YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    UIView *botomView=[UIView new];
    botomView.backgroundColor=[UIColor redColor];
    botomView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:botomView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[botomView(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(botomView)]];
    leftConstraint=[NSLayoutConstraint constraintWithItem:botomView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:(offsetWidth-80)/2.0];
    [self addConstraint:leftConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:[botomView(2)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(botomView)]];

}
-(UIButton *)itemButton{
    UIButton *btn=[UIButton new];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            CGRect frame = view.frame;
            frame.size.height = self.bounds.size.height-4;
            view.frame = frame;
        }
    }
}


-(void)itemBtnClick:(UIButton *)btn{
    NSInteger tag=btn.tag-1000;
    [self changeSelectItemButton:tag];
    [_delegate itemButtonClickAtIndex:tag];
}

- (void)changeSelectItemButton:(NSInteger)index{
    if (index == currentSelectIndex) {
        return;
    }
    UIButton *btn = (UIButton *)[self viewWithTag:currentSelectIndex+1000];
    UIButton *selectBtn=(UIButton *)[self viewWithTag:index+1000];
    selectBtn.selected=YES;
    btn.selected=NO;
    currentSelectIndex=index;
    [self moveBotomViewPostionWithOffset:currentSelectIndex];

    
}
-(void)moveBotomViewPostionWithOffset:(NSInteger)offset{
    leftConstraint.constant=offset*offsetWidth+(offsetWidth-80)/2.0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //设置线条样式
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    //设置线条粗细宽度
//    CGContextSetLineWidth(context, 2);
//    
//    //设置颜色
//    CGContextSetStrokeColorWithColor(context,BackColor.CGColor);
//    //开始一个起始路径
//    CGContextBeginPath(context);
//    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
//    CGContextMoveToPoint(context, 0, rect.size.height-1);
//    //设置下一个坐标点
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height) ;
//    //连接上面定义的坐标点
//    CGContextStrokePath(context);
//}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self changeSelectItemButton:selectedIndex];
}

- (NSInteger)selectedIndex {
    return currentSelectIndex;
}
@end
