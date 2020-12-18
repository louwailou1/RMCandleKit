
//
//  RMCandleStockFiveRecordProtocol.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#ifndef RMCandleStockFiveRecordProtocol_h
#define RMCandleStockFiveRecordProtocol_h


#endif /* RMCandleStockFiveRecordProtocol_h */
#import <CoreGraphics/CoreGraphics.h>
//提供分时图数据源
@protocol RMCandleStockFiveRecordProtocol <NSObject>

@required

/**
 *  买价格数组
 */
@property (nonatomic, readonly) NSArray *BuyPriceArray;

/**
 *  卖价格数组
 */
@property (nonatomic, readonly) NSArray *SellPriceArray;

/**
 *  买成交量数组
 */
@property (nonatomic, readonly) NSArray *BuyVolumeArray;

/**
 *  卖成交量数组
 */
@property (nonatomic, readonly) NSArray *SellVolumeArray;

/**
 *  买5文字描述
 */
@property (nonatomic, readonly) NSArray *BuyDescArray;

/**
 *  卖5文字描述
 */
@property (nonatomic, readonly) NSArray *SellDescArray;

@optional

- (instancetype)initWithDict: (NSDictionary *)dict;

@end
