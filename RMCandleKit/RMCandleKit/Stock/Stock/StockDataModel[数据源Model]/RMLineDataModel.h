//
//  RMLineDataModel.h
//  RMCandleKit
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "RMCandleStockDataProtocol.h"

/**
 外部实现
 */
@interface RMLineDataModel : NSObject <RMCandleLineDataModelProtocol>

- (void)updateMA:(NSUInteger )index;

@property (nonatomic, strong) NSArray *parentDictArray;


//@property (nonatomic, assign) BOOL isShowDay;
// 这个sb作者 代理居然写strong，对象释放不了，害老子查找错误半天
@property (nonatomic, weak) id<RMCandleLineDataModelProtocol> preDataModel;
@property (nonatomic, strong) NSString *showDay;
@end
