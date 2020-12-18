//
//  RMCandleBaseKLineView.m
//  RMCandleKit
//
//  Created by RMCandleKit on 2017/9/7.
//  Copyright © 2017年 RMCandleKit. All rights reserved.
//

#import "RMCandleBaseKLineView.h"
#import <Masonry/Masonry.h>

#import "RMCandleViewConstant.h"
#import "RMCandleStockViewKKline.h"
#import "UIColor+RMCandleStockTheme.h"
#import "RMCandleStockViewMaskView.h"
#import "RMCandleStockVariable.h"
#import "RMLineDataModel.h"


@interface RMCandleBaseKLineView ()<RMStockViewLongPressProtocol>

@property (nonatomic, strong) RMCandleStockViewKKline *stockView;

/**
 长按时出现的遮罩View
 */
@property (nonatomic, strong) RMCandleStockViewMaskView *maskView;

@end

@implementation RMCandleBaseKLineView

- (void)dealloc {
    NSLog(@"RMCandleBaseKLineViewDealloc");
}

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
    self.backgroundColor = UIColor.whiteColor;
    _stockView =  [[RMCandleStockViewKKline alloc]initWithLineModels:nil];
    _stockView.delegate = self;
    _stockView.backgroundColor = [UIColor YYStock_bgColor];
    [self addSubview:_stockView];
    [_stockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    _indicatorBgView = [UIView new];
    _indicatorBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_indicatorBgView];
    [_indicatorBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorBgView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [indicator startAnimating];
}


// 处理kline转model
- (void)kLineModelWithDictionary:(NSArray<NSDictionary*> *)response{
    
    [_indicatorBgView removeFromSuperview];
    _indicatorBgView = nil;
    
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
            [self drawWithModels:array];
        });
    });
}

- (void)drawWithModels:(NSArray <id<RMCandleLineDataModelProtocol>>*) lineModels {
    //更新数据
    [_stockView reDrawWithLineModels:lineModels];
    
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
