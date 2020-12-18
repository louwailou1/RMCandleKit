//
//  RMStock.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMCandleStockDataProtocol.h"
#import "RMCandleStockFiveRecordProtocol.h"
#import "RMCandleViewConstant.h"
@class RMStock;

@protocol RMStockHideTouchViewDelegate

@optional
- (void)hideTouchView;
- (void)showTouchView;

@end

@protocol YYStockDataSource <NSObject>
@required

/**
 K线的数据源
 */
-(NSArray *) RMStock:(RMStock *)stock stockDatasOfIndex:(NSInteger)index;

/**
 K线的顶部栏文字
 */
-(NSArray <NSString *> *) titleItemsOfStock:(RMStock *)stock;

/**
 K线的类型
 */
-(YYStockType)stockTypeOfIndex:(NSInteger)index;

@optional

/**
 分时图是否显示五档数据
 */
-(BOOL)isShowfiveRecordModelOfIndex:(NSInteger)index;

/**
 五档图数据源
 */
-(id<RMCandleStockFiveRecordProtocol>)fiveRecordModelOfIndex:(NSInteger)index;

@end

@interface RMStock : NSObject

//RMCandleKit
@property (nonatomic, weak) UITableView *tableView;

/**
 RMStock的ContentView
 */
@property (nonatomic, strong) UIView *mainView;

/**
 构造器

 @param frame      frame
 @param dataSource 数据源

 @return RMStock对象
 */
- (instancetype)initWithFrame:(CGRect)frame dataSource:(id)dataSource tableView:(UITableView *)tableview;

/**
 单独绘制分时
 */
- (void)singleDrawMinute;

/**
 开始绘制
 */
- (void)draw;

/**
 stockView的容器
 */
@property (nonatomic, strong) UIView *containerView;

/**
 当前选中的ViewIndex
 */
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id<RMStockHideTouchViewDelegate> delegate;

@end
