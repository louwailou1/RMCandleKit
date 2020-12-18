//
//  RMStock.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/5.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMStock.h"
#import "RMCandleTopBarView.h"
#import "RMCandleViewConstant.h"
#import "RMCandleStockViewKKline.h"
#import "RMCandleStockViewTTimeLine.h"
#import "UIColor+RMCandleStockTheme.h"
#import "RMCandleStockViewMaskView.h"
#import "RMCandleStockVariable.h"
#import <Masonry/Masonry.h>
@interface RMStock()<RMCandleTopBarViewDelegate, RMStockViewLongPressProtocol, RMStockViewTimeLinePressProtocol>
/**
 *  数据源
 */
@property (nonatomic, weak) id<YYStockDataSource> dataSource;

/**
 顶部TopBarView
 */
@property (nonatomic, strong) RMCandleTopBarView *topBarView;

/**
 长按时出现的遮罩View
 */
@property (nonatomic, strong) RMCandleStockViewMaskView *maskView;

@property (nonatomic, strong) NSMutableArray <__kindof UIView *>*stockViewArray;

@end

@implementation RMStock

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id)dataSource tableView:(UITableView *)tableview {
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        self.mainView = [[UIView alloc] initWithFrame:frame];
        self.tableView = tableview;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self initUI_TopBarView];
    [self initUI_StockContainerView];
}

- (void)initUI_TopBarView {
    _topBarView = [[RMCandleTopBarView alloc]initWithItems:[self.dataSource titleItemsOfStock:self] distributionStyle:YYTopBarDistributionStyleInScreen];
    [self.mainView addSubview:_topBarView];
    [_topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.mainView);
        make.height.equalTo(@YYStockTopBarViewHeight);
    }];
    _topBarView.delegate = self;
}

- (void)initUI_StockContainerView {
    self.stockViewArray = [NSMutableArray array];
    self.containerView = ({
        UIView *view = [UIView new];
        [self.mainView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.mainView);
            make.top.equalTo(self.topBarView.mas_bottom).offset(YYStockViewGap);
        }];
        view;
    });
    for (int i = 0; i < [[self.dataSource titleItemsOfStock:self] count]; i++) {
        UIView *stockView;
        if ([self.dataSource stockTypeOfIndex:i] == YYStockTypeTimeLine) {
            //判断是否加载五档图
            if ([self.dataSource respondsToSelector:@selector(isShowfiveRecordModelOfIndex:)]) {
                stockView =  [[RMCandleStockViewTTimeLine alloc]initWithTimeLineModels:[self.dataSource RMStock:self stockDatasOfIndex:i] isShowFiveRecord:  [self.dataSource isShowfiveRecordModelOfIndex:self.currentIndex] fiveRecordModel:[self.dataSource fiveRecordModelOfIndex:i]];
            } else {
                stockView =  [[RMCandleStockViewTTimeLine alloc]initWithTimeLineModels:[self.dataSource RMStock:self stockDatasOfIndex:i] isShowFiveRecord: NO fiveRecordModel:[self.dataSource fiveRecordModelOfIndex:i]];
            }
            ((RMCandleStockViewTTimeLine *)stockView).delegate = self;
            ((RMCandleStockViewTTimeLine *)stockView).tableView = self.tableView;
        } else {
            stockView =  [[RMCandleStockViewKKline alloc]initWithLineModels:[self.dataSource RMStock:self stockDatasOfIndex:i]];
            ((RMCandleStockViewKKline *)stockView).delegate = self;
            stockView.hidden = YES;
        }
        stockView.backgroundColor = [UIColor YYStock_bgColor];
        [self.containerView addSubview:stockView];
        [stockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerView);
        }];
        [self.stockViewArray addObject:stockView];
    }
}

/**
 单独绘制分时
 */
- (void)singleDrawMinute {
    //更新数据
    NSInteger index = self.currentIndex;
    if ([self.stockViewArray[index] isKindOfClass:[RMCandleStockViewTTimeLine class]]) {
        RMCandleStockViewTTimeLine *stockView = (RMCandleStockViewTTimeLine *)(self.stockViewArray[index]);
        if ([self.dataSource respondsToSelector:@selector(isShowfiveRecordModelOfIndex:)]) {
            [stockView reDrawWithTimeLineModels:[self.dataSource RMStock:self stockDatasOfIndex:index] isShowFiveRecord:[self.dataSource isShowfiveRecordModelOfIndex:0] fiveRecordModel:[self.dataSource fiveRecordModelOfIndex:index]];
        } else {
            [stockView reDrawWithTimeLineModels:[self.dataSource RMStock:self stockDatasOfIndex:index] isShowFiveRecord:NO fiveRecordModel:nil];
        }
    }
}

/**
 绘制
 */
- (void)draw {
    //更新数据
    NSInteger index = self.currentIndex;
    if ([self.stockViewArray[index] isKindOfClass:[RMCandleStockViewKKline class]]) {
        RMCandleStockViewKKline *stockView = (RMCandleStockViewKKline *)(self.stockViewArray[index]);
        
        [stockView reDrawWithLineModels:[self.dataSource RMStock:self stockDatasOfIndex:index]];
    }
    if ([self.stockViewArray[index] isKindOfClass:[RMCandleStockViewTTimeLine class]]) {
        RMCandleStockViewTTimeLine *stockView = (RMCandleStockViewTTimeLine *)(self.stockViewArray[index]);
        if ([self.dataSource respondsToSelector:@selector(isShowfiveRecordModelOfIndex:)]) {
            [stockView reDrawWithTimeLineModels:[self.dataSource RMStock:self stockDatasOfIndex:index] isShowFiveRecord:[self.dataSource isShowfiveRecordModelOfIndex:0] fiveRecordModel:[self.dataSource fiveRecordModelOfIndex:index]];
        } else {
            [stockView reDrawWithTimeLineModels:[self.dataSource RMStock:self stockDatasOfIndex:index] isShowFiveRecord:NO fiveRecordModel:nil];
        }
    }
}

/**
 topBarView代理
 
 @param topBarView topBarView
 @param index      选中index
 */
- (void)RMCandleTopBarView:(RMCandleTopBarView *)topBarView didSelectedIndex:(NSInteger)index {
    self.stockViewArray[self.currentIndex].hidden = YES;
    self.stockViewArray[index].hidden = NO;
    self.currentIndex = index;
    [self draw];
}


/**
 StockView_Kline代理
 此处Kline和TimeLine都走这一个代理
 @param stockView RMCandleStockViewKKline
 @param model     选中的数据源 若为nil表示取消绘制
 */
- (void)YYStockView:(RMCandleStockViewKKline *)stockView selectedModel:(id<RMCandleLineDataModelProtocol>)model {
    if (model == nil) {
        self.maskView.hidden = YES;
        //
        [self.delegate hideTouchView];
    } else {
        [self.delegate showTouchView];
        if (!self.maskView) {
            _maskView = [RMCandleStockViewMaskView new];
            _maskView.backgroundColor = [UIColor clearColor];
            [self.mainView addSubview:_maskView];
            [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.topBarView);
            }];
        } else {
            self.maskView.hidden = NO;
        }
        if ([stockView isKindOfClass:[RMCandleStockViewKKline class]]) {
            self.maskView.stockType = YYStockTypeLine;
        } else {
            self.maskView.stockType = YYStockTypeTimeLine;
        }
        self.maskView.selectedModel = model;
        [self.maskView setNeedsDisplay];
    }
}

@end
