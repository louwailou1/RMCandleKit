//
//  RMCandleBaseMinuteView.m
//  RMCandleKit
//
//  Created byRMCandleKit on 2019/3/25.
//  Copyright © 2019RMCandleKit. All rights reserved.
//

#import "RMCandleBaseMinuteView.h"
#import <Masonry/Masonry.h>

#import "RMCandleViewConstant.h"
#import "RMCandleStockViewTTimeLine.h"
#import "UIColor+RMCandleStockTheme.h"
#import "RMCandleStockViewMaskView.h"
#import "RMCandleStockVariable.h"
#import "RMTimeLineModel.h"
#import "RMCandleStockViewKKline.h"

@interface RMCandleBaseMinuteView ()<RMStockViewTimeLinePressProtocol>

@property (nonatomic, strong) RMCandleStockViewTTimeLine *stockView;

/**
 长按时出现的遮罩View
 */
@property (nonatomic, strong) RMCandleStockViewMaskView *maskView;

@end

@implementation RMCandleBaseMinuteView

- (void)setStockBackGroundColor:(UIColor *)stockBackGroundColor {
    _stockBackGroundColor = stockBackGroundColor;
    _stockView.backgroundColor = stockBackGroundColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _stockView =  [[RMCandleStockViewTTimeLine alloc]initWithTimeLineModels:nil isShowFiveRecord: NO fiveRecordModel:nil];
    _stockView.delegate = self;
    _stockView.backgroundColor = [UIColor YYStock_bgColor];
    [self addSubview:_stockView];
    [_stockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    _indicatorBgView = [UIView new];
    _indicatorBgView.backgroundColor = [UIColor YYStock_bgColor];
    [self addSubview:_indicatorBgView];
    [_indicatorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_indicatorBgView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [indicator startAnimating];
}

- (void)minuteModelWithDictionary:(NSArray<NSDictionary*> *)response {
    [_indicatorBgView removeFromSuperview];
    _indicatorBgView = nil;
    
    dispatch_queue_t queue = dispatch_queue_create("dayhqs", 0);
    dispatch_async(queue, ^{
        
        NSMutableArray *array = [NSMutableArray array];
        [response enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                RMTimeLineModel *model = [[RMTimeLineModel alloc]initWithDict:obj];
                [array addObject: model];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawWithModels:array];
        });
    });
}

- (void)drawWithModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*) lineModels {
    //更新数据
    [_stockView reDrawWithTimeLineModels:lineModels isShowFiveRecord:NO fiveRecordModel:nil];
    
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
    } else {
        if (!self.maskView) {
            _maskView = [RMCandleStockViewMaskView new];
            _maskView.backgroundColor = [UIColor clearColor];
            [self addSubview:_maskView];
            [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.equalTo(@20);
            }];
        } else {
            self.maskView.hidden = NO;
        }
        if ([stockView isKindOfClass:[RMCandleStockViewTTimeLine class]]) {
            self.maskView.stockType = YYStockTypeTimeLine;
        } else {
            self.maskView.stockType = YYStockTypeLine;
        }
        self.maskView.selectedModel = model;
        [self.maskView setNeedsDisplay];
    }
}


@end
