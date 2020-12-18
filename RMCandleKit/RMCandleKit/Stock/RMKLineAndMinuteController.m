//
//  RMKLineAndMinuteController.m
//  eightThousandPoints
//
//  Created by RMCandleKit on 2017/8/6.
//  Copyright © 2017年 RMCandleKit. All rights reserved.
//

#import "RMKLineAndMinuteController.h"
#import "UIColor+RMCandleStockTheme.h"
#import <Masonry/Masonry.h>
#import "RMFiveRecordModel.h"
#import "RMLineDataModel.h"
#import "RMTimeLineModel.h"
#import "RMCandleStockVariable.h"
#import "RMStock.h"

@interface RMKLineAndMinuteController ()<YYStockDataSource>
/**
 K线数据源
 */
@property (strong, nonatomic) NSMutableDictionary *stockDatadict;
@property (copy, nonatomic) NSArray *stockDataKeyArray;
@property (copy, nonatomic) NSArray *stockTopBarTitleArray;
@property (strong, nonatomic) RMFiveRecordModel *fiveRecordModel;

@property (strong, nonatomic) RMStock *stock;

@end

@implementation RMKLineAndMinuteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStockView];
}

- (void)initStockView {
    [RMCandleStockVariable setStockLineWidthArray:@[@6,@6,@6,@6]];
    
    RMStock *stock = [[RMStock alloc]initWithFrame:self.view.frame dataSource:self tableView:self.tableView];
    _stock = stock;
    stock.tableView = self.tableView;
    [self.view addSubview:stock.mainView];
    [stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


//处理五档图转model
- (void)fiveModelWithDictionary:(NSDictionary *)response{
    dispatch_queue_t queue = dispatch_queue_create("minutes", 0);
    dispatch_async(queue, ^{
        if (self.isShowFiveRecord) {
            self.fiveRecordModel = [[RMFiveRecordModel alloc]initWithDict:response];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.stock draw];
        });
    });
}


// 处理kline转model
- (void)kLineModelWithDictionary:(NSArray<NSDictionary*> *)response{
    
    dispatch_queue_t queue = dispatch_queue_create("dayhqs", 0);
    dispatch_async(queue, ^{
        
        NSMutableArray *array = [NSMutableArray array];
        __block RMLineDataModel *preModel;
        //NSLog(@"---???????");
        int i = 0;
        for (id obj in response) {
            @autoreleasepool {
                RMLineDataModel *model = [[RMLineDataModel alloc]initWithDict:obj];
                model.preDataModel = preModel;
                model.parentDictArray = response;
                [model updateMA:i];
                
                if ([response count] % 18 == (i + 1 )%18 ) {
                    model.showDay = obj[@"day"];
                }
                
                [array addObject: model];
                preModel = model;
                i++;
            }
        }
        //NSLog(@"----%lu",(unsigned long)array.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.stockDatadict setObject:array forKey:@"dayhqs"];
            [self.stock draw];
        });
    });
    
    
}

// 处理分时转model
- (void)minuteModelWithDictionary:(NSArray<NSDictionary*> *)response{
    
    [self.stockDatadict removeObjectForKey:@"minutes"];
    //NSLog(@"---???");
    NSMutableArray *array = [NSMutableArray array];
    [response enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            RMTimeLineModel *model = [[RMTimeLineModel alloc]initWithDict:obj];
            [array addObject: model];
        }
    }];
    //NSLog(@"----???");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.stockDatadict setObject:array forKey:@"minutes"];
        [self.stock singleDrawMinute];
    });
}

/*******************************************股票数据源代理*********************************************/
-(NSArray <NSString *> *) titleItemsOfStock:(RMStock *)stock {
    return self.stockTopBarTitleArray;
}

-(NSArray *) RMStock:(RMStock *)stock stockDatasOfIndex:(NSInteger)index {
    return index < self.stockDataKeyArray.count ? self.stockDatadict[self.stockDataKeyArray[index]] : nil;
}

-(YYStockType)stockTypeOfIndex:(NSInteger)index {
    return index == 0 ? YYStockTypeTimeLine : YYStockTypeLine;
}

- (id<RMCandleStockFiveRecordProtocol>)fiveRecordModelOfIndex:(NSInteger)index {
    return self.fiveRecordModel;
}

- (BOOL)isShowfiveRecordModelOfIndex:(NSInteger)index {
    return self.isShowFiveRecord;
}

/*******************************************getter*********************************************/
- (NSMutableDictionary *)stockDatadict {
    if (!_stockDatadict) {
        _stockDatadict = [NSMutableDictionary dictionary];
    }
    return _stockDatadict;
}

- (NSArray *)stockDataKeyArray {
    if (!_stockDataKeyArray) {
        _stockDataKeyArray = @[@"minutes",@"dayhqs"];
    }
    return _stockDataKeyArray;
}

- (NSArray *)stockTopBarTitleArray {
    if (!_stockTopBarTitleArray) {
        _stockTopBarTitleArray = @[@"分时",@"日K"];
        //        _stockTopBarTitleArray = @[@"分时",@"日K",@"周K",@"月K"];
    }
    return _stockTopBarTitleArray;
}

- (NSString *)getToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)dealloc {
    //NSLog(@"DEALLOC");
}

@end
