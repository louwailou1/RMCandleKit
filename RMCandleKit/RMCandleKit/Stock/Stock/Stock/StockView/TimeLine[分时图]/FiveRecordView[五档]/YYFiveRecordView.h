//
//  YYFiveRecordView.h
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMCandleStockFiveRecordProtocol.h"
@interface YYFiveRecordView : UITableView <UITableViewDataSource>
@property (nonatomic, strong) id<RMCandleStockFiveRecordProtocol> fiveRecordModel;
- (void)reDrawWithFiveRecordModel:(id<RMCandleStockFiveRecordProtocol>)fiveRecordModel;
@end
