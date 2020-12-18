//
//  RMCandleStockViewKKline.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockDataProtocol.h"

@protocol RMStockViewLongPressProtocol;

@interface RMCandleStockViewKKline : UIView

/**
 长按view的代理
 */
@property (nonatomic, weak) id<RMStockViewLongPressProtocol> delegate;

/**
 构造器

 @param lineModels 数据源
 
 @return RMCandleStockViewKKline对象
 */
- (instancetype)initWithLineModels:(NSArray <id<RMCandleLineDataModelProtocol>>*) lineModels;


/**
 重绘视图
 
 @param lineModels  K线数据源
 */
- (void)reDrawWithLineModels:(NSArray <id<RMCandleLineDataModelProtocol>>*) lineModels;
@end

@protocol RMStockViewLongPressProtocol <NSObject>

/**
 长按代理

 @param stockView 长按的view
 @param model     长按时选中的数据
 */
- (void) YYStockView:(RMCandleStockViewKKline *)stockView selectedModel:(id<RMCandleLineDataModelProtocol>)model;
@end
