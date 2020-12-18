//
//  RMCandleStockViewTTimeLine.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockTimeLineProtocol.h"
#import "RMCandleStockFiveRecordProtocol.h"

@protocol RMStockViewTimeLinePressProtocol;

@interface RMCandleStockViewTTimeLine : UIView

//RMCandleKit
@property (nonatomic, weak) UITableView *tableView;

/**
 长按view的代理
 */
@property (nonatomic, weak) id<RMStockViewTimeLinePressProtocol> delegate;

/**
 构造器
 
 @param timeLineModels 数据源
 @param isShowFiveRecord 是否显示五档数据
 @param fiveRecordModel 五档数据源
 
 @return RMCandleStockViewTTimeLine对象
 */
- (instancetype)initWithTimeLineModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*) timeLineModels isShowFiveRecord:(BOOL)isShowFiveRecord fiveRecordModel:(id<RMCandleStockFiveRecordProtocol>)fiveRecordModel;


/**
 重绘视图

 @param timeLineModels  分时线数据源
 @param isShowFiveRecord 是否显示五档图
 @param fiveRecordModel 五档数据源
 */
- (void)reDrawWithTimeLineModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*) timeLineModels isShowFiveRecord:(BOOL)isShowFiveRecord fiveRecordModel:(id<RMCandleStockFiveRecordProtocol>)fiveRecordModel;
@end

@protocol RMStockViewTimeLinePressProtocol <NSObject>

/**
 长按代理
 
 @param stockView 长按的view
 @param model     长按时选中的数据
 */
- (void) YYStockView:(RMCandleStockViewTTimeLine *)stockView selectedModel:(id<RMCandleStockTimeLineProtocol>)model;
@end
