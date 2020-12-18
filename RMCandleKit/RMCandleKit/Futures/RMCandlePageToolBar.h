//
//  RMCandlePageToolBar.h
//  RMCandleKit
//
//  Created by RMCandleKit on 15/6/9.
//  Copyright (c) 2015年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RMCandlePageToolBarDelegate <NSObject>

-(void)itemButtonClickAtIndex:(NSInteger)index;

@end


@interface RMCandlePageToolBar : UIView

@property (nonatomic,weak) id<RMCandlePageToolBarDelegate>delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

-(instancetype)initWithTitles:(NSArray *)titles;

@end
