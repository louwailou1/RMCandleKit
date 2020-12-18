//
//  RMCandleStockViewTTimeLine.m
//  RMStock  ( https://github.com/RMCandleKit )
//
//  Created by RMCandleKit on 16/10/10.
//  Copyright © 2016年 RMCandleKit. All rights reserved.
//

#import "RMCandleStockViewTTimeLine.h"
#import "YYTimeLineView.h"
#import "YYTimeLineVolumeView.h"
#import <Masonry/Masonry.h>
#import "RMCandleViewConstant.h"
#import "RMCandleStockVariable.h"
#import "UIColor+RMCandleStockTheme.h"
#import "RMCandleStockScrollView.h"
#import "YYTimeLineMaskView.h"
#import "YYFiveRecordView.h"
@interface RMCandleStockViewTTimeLine()<UITableViewDelegate>

@property (nonatomic, strong) RMCandleStockScrollView *stockScrollView;

/**
 分时线部分
 */
@property (nonatomic, strong) YYTimeLineView *timeLineView;

/**
 成交量部分
 */
@property (nonatomic, strong) YYTimeLineVolumeView *volumeView;

/**
 是否显示五档图
 */
@property (nonatomic, assign) BOOL isShowFiveRecord;

/**
 五档图
 */
@property (nonatomic, strong) YYFiveRecordView *fiveRecordView;

/**
 五档数据
 */
@property (nonatomic, strong) id<RMCandleStockFiveRecordProtocol> fiveRecordModel;

/**
 当前绘制在屏幕上的数据源数组
 */
@property (nonatomic, strong) NSArray <id<RMCandleStockTimeLineProtocol>>*drawLineModels;

/**
 当前绘制在屏幕上的数据源位置数组
 */
@property (nonatomic, copy) NSArray <NSValue *>*drawLinePositionModels;

/**
 长按时出现的遮罩View
 */
@property (nonatomic, strong) YYTimeLineMaskView *maskView;

@end

@implementation RMCandleStockViewTTimeLine
{
#pragma mark - 页面上显示的数据
    //图表最大的价格
    CGFloat maxValue;
    //图表最小的价格
    CGFloat minValue;
    //图表最大的成交量
    CGFloat volumeValue;
    //当前长按选中的model
    id<RMCandleStockTimeLineProtocol> selectedModel;
}

/**
 构造器
 
 @param timeLineModels 数据源
 @param isShowFiveRecord 是否显示五档数据
 @param fiveRecordModel 五档数据源
 
 @return RMCandleStockViewTTimeLine对象
 */
- (instancetype)initWithTimeLineModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*) timeLineModels isShowFiveRecord:(BOOL)isShowFiveRecord fiveRecordModel:(id<RMCandleStockFiveRecordProtocol>)fiveRecordModel {
    self = [super init];
    if (self) {
        _drawLineModels = timeLineModels;
        if (isShowFiveRecord) {
            _isShowFiveRecord = isShowFiveRecord;
            _fiveRecordModel = fiveRecordModel;
        }
        [self initUI];
        self.stockScrollView.userInteractionEnabled = NO;
    }
    return self;
}

/**
 重绘视图
 
 @param timeLineModels  分时线数据源
 @param fiveRecordModel 五档数据源
 */
- (void)reDrawWithTimeLineModels:(NSArray <id<RMCandleStockTimeLineProtocol>>*) timeLineModels isShowFiveRecord:(BOOL)isShowFiveRecord fiveRecordModel:(id<RMCandleStockFiveRecordProtocol>)fiveRecordModel {
    _drawLineModels = timeLineModels;
    _fiveRecordModel = fiveRecordModel;
    _isShowFiveRecord = isShowFiveRecord;
    [self layoutIfNeeded];
    [self updateScrollViewContentWidth];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.drawLineModels.count > 0) {
        if (!self.maskView || self.maskView.isHidden) {
            //更新绘制的数据源
            [self updateDrawModels];
            //绘制分时线上部分
            self.drawLinePositionModels = [self.timeLineView drawViewWithXPosition:0 drawModels:self.drawLineModels maxValue:maxValue minValue:minValue];
            //绘制成交量
            [self.volumeView drawViewWithXPosition:0 drawModels:self.drawLineModels];
            //更新背景线
            self.stockScrollView.isShowBgLine = YES;
            [self.stockScrollView setNeedsDisplay];
            //更新五档图
            if (self.isShowFiveRecord) {
                [self.fiveRecordView reDrawWithFiveRecordModel:self.fiveRecordModel];
            }
        }
        //绘制左侧文字部分
        [self drawLeftRightDesc];
    }
}

- (void)showTouchView:(NSSet<UITouch *> *)touches {
    self.tableView.scrollEnabled = NO;
    static CGFloat oldPositionX = 0;
    CGPoint location = [touches.anyObject locationInView:self.stockScrollView];
    if (location.x < 0 || location.x > self.stockScrollView.contentSize.width) return;
    if(ABS(oldPositionX - location.x) < ([RMCandleStockVariable timeLineVolumeWidth]+ YYStockTimeLineViewVolumeGap)/2) return;
    
    oldPositionX = location.x;
    NSInteger startIndex = (NSInteger)(oldPositionX / (YYStockTimeLineViewVolumeGap + [RMCandleStockVariable timeLineVolumeWidth]));
    
    if (startIndex < 0) startIndex = 0;
    if (startIndex >= self.drawLineModels.count) startIndex = self.drawLineModels.count - 1;
    
    if (!self.maskView) {
        _maskView = [YYTimeLineMaskView new];
        _maskView.backgroundColor = [UIColor clearColor];
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        self.maskView.hidden = NO;
    }
    //NSLog(@"是不是这里数组越界了？");
    if (startIndex >= self.drawLineModels.count || startIndex >= self.drawLinePositionModels.count) { return ;}
    selectedModel = self.drawLineModels[startIndex];
    self.maskView.selectedModel = self.drawLineModels[startIndex];
    self.maskView.selectedPoint = [self.drawLinePositionModels[startIndex] CGPointValue];
    self.maskView.stockScrollView = self.stockScrollView;
    [self setNeedsDisplay];
    [self.maskView setNeedsDisplay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(YYStockView: selectedModel:)]) {
        [self.delegate YYStockView:self selectedModel:selectedModel];
    }
    //NSLog(@"还真是？");
}

- (void)hideTouchView {
    self.tableView.scrollEnabled = YES;
    //恢复scrollView的滑动
    selectedModel = self.drawLineModels.lastObject;
    [self setNeedsDisplay];
    self.maskView.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(YYStockView: selectedModel:)]) {
        [self.delegate YYStockView:self selectedModel:nil];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showTouchView:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showTouchView:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTouchView];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideTouchView];
}



/**
 初始化子View
 */
- (void)initUI {
    
    //加载五档图
    if (self.isShowFiveRecord) {
        _fiveRecordView = [YYFiveRecordView new];
        _fiveRecordView.fiveRecordModel = self.fiveRecordModel;
        _fiveRecordView.delegate = self;
        [self addSubview:_fiveRecordView];
        [_fiveRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-6);
            make.width.equalTo(@YYStockFiveRecordViewWidth);
            make.height.equalTo(@YYStockFiveRecordViewHeight);
            make.centerY.equalTo(self);
        }];
    }
    
    //加载StockScrollView
    [self initUI_stockScrollView];
    

    
    //加载TimeLineView 
    _timeLineView = [YYTimeLineView new];
    _timeLineView.backgroundColor = [UIColor clearColor];
    [_stockScrollView.contentView addSubview:_timeLineView];
    [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_stockScrollView.contentView);
        make.height.equalTo(_stockScrollView.contentView).multipliedBy([RMCandleStockVariable lineMainViewRadio]);
        make.width.equalTo(_stockScrollView);

    }];
    
    //加载VolumeView
    _volumeView = [YYTimeLineVolumeView new];
    _volumeView.backgroundColor = [UIColor clearColor];
    [_stockScrollView.contentView addSubview:_volumeView];
    
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_stockScrollView.contentView);
        make.top.equalTo(_timeLineView.mas_bottom);
        make.height.equalTo(_stockScrollView.contentView).multipliedBy(1-[RMCandleStockVariable lineMainViewRadio]);
    }];
}


- (void)initUI_stockScrollView {
    _stockScrollView = [RMCandleStockScrollView new];
    _stockScrollView.stockType = YYStockTypeTimeLine;
    _stockScrollView.backgroundColor = [UIColor clearColor];
    _stockScrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_stockScrollView];
    [_stockScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(YYStockTimeLineViewLeftGap);
        make.top.equalTo(self).offset(YYStockScrollViewTopGap);
        if (self.isShowFiveRecord) {
            make.right.equalTo(self.fiveRecordView.mas_left).offset(-12);
        } else {
            make.right.equalTo(self).offset(-12);
        }
    }];
    
    
}
/**
 绘制左边的价格部分
 */
- (void)drawLeftRightDesc {
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor YYStock_topBarNormalTextColor]};
    CGSize textSize = [self rectOfNSString:[NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,(maxValue + minValue)/2.f] attribute:attribute].size;
    CGFloat unit = self.stockScrollView.frame.size.height * [RMCandleStockVariable lineMainViewRadio] / 2.f;
    CGFloat unitValue = (maxValue - minValue)/2.f;
    CGFloat leftGap = YYStockTimeLineViewLeftGap + 3;
    CGFloat topOffset = -textSize.height/2.f - 3;
    CGFloat creasePercent = (maxValue / ((maxValue + minValue)/2.f)) * 100 - 100;
    
    if (isnan(creasePercent) || creasePercent == INFINITY) {
        creasePercent = 0.000001;
    }
    
    //顶部间距
    for (int i = 0; i < 3; i++) {
        NSMutableDictionary *new_attribute = [NSMutableDictionary dictionaryWithDictionary:attribute];
        if (i == 0) {
            new_attribute[NSForegroundColorAttributeName] = [self colorWithHex:0xE93030];
        }else if (i == 2) {
            new_attribute[NSForegroundColorAttributeName] = [self colorWithHex:0x009200];
        }
        NSString *text = [NSString stringWithFormat:RMCandleConStant.sharedInstance.accuracy,maxValue - unitValue * i];
        CGPoint leftDrawPoint = CGPointMake(leftGap , unit * i + YYStockScrollViewTopGap - textSize.height/2.f + topOffset);
        [text drawAtPoint:leftDrawPoint withAttributes:new_attribute];
        
        NSString *text2 = [NSString stringWithFormat:@"%.2f%%",creasePercent - creasePercent * i];
        CGSize textSize2 = [self rectOfNSString:text2 attribute:new_attribute].size;
        CGPoint rightDrawPoint = CGPointMake(CGRectGetMaxX(self.stockScrollView.frame) - textSize2.width - 3, unit * i + YYStockScrollViewTopGap - textSize.height/2.f + topOffset);
        [text2 drawAtPoint:rightDrawPoint withAttributes:new_attribute];
    }
    
    CGFloat volume =  [[[self.drawLineModels valueForKeyPath:@"Volume"] valueForKeyPath:@"@max.floatValue"] floatValue];
    volumeValue = volume;
    
    //尝试转为万手
    CGFloat wVolume = volume/10000.f;
    NSString *text, *descText;
    if (wVolume > 1) {
        //尝试转为亿手
        CGFloat yVolume = wVolume/10000.f;
        if (yVolume > 1) {
            text = [NSString stringWithFormat:@"%.2f",yVolume];
            descText = @"亿手";
        } else {
            text = [NSString stringWithFormat:@"%.2f",wVolume];
            descText = @"万手";
        }
    } else {
        text = [NSString stringWithFormat:@"%.0f",volume];
        descText = @"手";
    }
    CGFloat textY = 15+YYStockScrollViewTopGap + self.stockScrollView.frame.size.height * (1 - [RMCandleStockVariable volumeViewRadio]);
    CGRect textRect = [self rectOfNSString:text attribute:attribute];
    [text drawInRect:CGRectMake(leftGap, textY, textRect.size.width, 20) withAttributes:attribute];
    [descText drawInRect:CGRectMake(textRect.size.width + leftGap, textY, 60, 20) withAttributes:attribute];
}


/**
 更新需要绘制的数据源
 */
- (void)updateDrawModels {
    
    //更新最大值最小值-价格
    CGFloat average = [self.drawLineModels.firstObject AvgPrice];
    maxValue = [[[self.drawLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@max.floatValue"] floatValue];
    minValue = [[[self.drawLineModels valueForKeyPath:@"Price"] valueForKeyPath:@"@min.floatValue"] floatValue];
    
    
    if (maxValue == minValue && maxValue == average) {
        //处理特殊情况
        if (maxValue == 0) {
            
            maxValue = 0.00001;
            minValue = -0.00001;
        } else {
            maxValue = maxValue * 2;
            minValue = 0.01;
        }
    } else {
        if (ABS(maxValue - average) >= ABS(average - minValue)) {
            minValue = 2 * average - maxValue;
        }
        if (ABS(maxValue - average) < ABS(average - minValue)) {
            maxValue = 2 * average - minValue;
        }
    }
    
//    if (ABS(maxValue - average) >= ABS(average - minValue)) {
//        minValue = 2 * average - maxValue;
//    } else {
//        maxValue = 2 * average - minValue;
//    }
}

- (void)updateScrollViewContentWidth {
    //更新scrollview的contentsize
    self.stockScrollView.contentSize = self.stockScrollView.bounds.size;
    
    //9:30-11:30/12:00-15:00一共240分钟
    NSInteger minCount = 240;
    [RMCandleStockVariable setTimeLineVolumeWidth:((self.stockScrollView.bounds.size.width - (minCount - 1) * YYStockTimeLineViewVolumeGap) / minCount)];
}


/******************************UITableViewDelegate*********************************/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 1 ? 5:0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [UIView new];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor YYStock_bgLineColor];
        [view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view).insets(UIEdgeInsetsMake(2, 0, 2, 0));
        }];
        return view;
    } else {
        return nil;
    }
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}

- (UIColor *)colorWithHex:(UInt32)hex {
    return [self colorWithHex:hex alpha:1.f];
}

- (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

@end
