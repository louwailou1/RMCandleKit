//
//  RMTimeLineView.m
//  RMCandleKit
//
//  Created RMCandleKit blue on 2017/10/11.
//  Copyright © 2017年 RMCandleKit. All rights reserved.
//

#import "RMTimeLineView.h"
#import "ColorMacro.h"
#import "RMCandleYAxis.h"
#import "RMCandleAnimateView.h"
#import "NSTimer+RMCandleBlocksSupport.h"
#import "RMCandleTimeOffsetView.h"
#import "UtilsMacro.h"
#import "NSDate+Category.h"

@interface RMTimeLineView (){
    double priceFloat;//价格浮动值
    double maxTimePrice;
    double minPrice;
    double currPrice;
    NSTimer *_timer ;
    CGFloat selfWidth;
    CATextLayer *horizontalRaise;// 基准点
    CATextLayer *horizontalPrice;// 水平价
    NSInteger startTimeOffset;
    NSInteger endTimeOffset;
    RMCandleTimeOffsetView *timeOffsetView;
    BOOL isDrawing; //是否正画线 如果正在画线 不再接受点
    
    // 2018-2-27
    double _swing;
    double _closePrice;
    NSUInteger _accuracy;
    NSInteger _xAxisMaxValue;
}

@property (nonatomic, strong)NSMutableArray *textLayers;

@property (nonatomic, strong)RMCandleYAxis *tm_YAxis; // y 轴


@property (nonatomic, strong)CAShapeLayer *timeLineLayer;


@property (nonatomic, strong)UIBezierPath *timeLinePath;

@property (nonatomic, strong)RMCandleAnimateView *ltAniView;

@property (nonatomic, assign) BOOL didLayoutViews;

@property (nonatomic, strong) CATextLayer *raise0;
@property (nonatomic, strong) CATextLayer *raise1;

@property (nonatomic, strong)CAShapeLayer *fillBackLayer;

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, strong) CAShapeLayer *horizontalLayer; // 水平基准线




/**
 *  分时的数据
 */
@property (nonatomic, strong) NSMutableArray *timeLineData;


@end

@implementation RMTimeLineView

-(void)dealloc {
    //NSLog(@"TimeViewDealloc");
    [_timer invalidate];
    _timer = nil;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _swing = 0;
        _closePrice = 0;
        _accuracy = 2;
        _dottedLineColor =  RGBS(235);//RGB(205, 219, 225);
        _dottedLineLength = 5.0;
        _textLayers = [NSMutableArray arrayWithCapacity:7];
        _timeLineData = [NSMutableArray arrayWithCapacity:400];
        for (int i=0 ; i<7; ++i) {
            CATextLayer *layer = [self makeTextLayer];
            [self.layer addSublayer:layer];
            [_textLayers addObject:layer];
        }
        _fillBackLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_fillBackLayer];
        _maskLayer = [CAShapeLayer layer];
        _tm_YAxis = [[RMCandleYAxis alloc] init];
        _timeLineLayer = [CAShapeLayer layer];
        _timeLineLayer.zPosition  = 55;
        _timeLineLayer.strokeColor = RGB(50, 159, 210).CGColor;
        _timeLineLayer.lineWidth = 1;
        _timeLineLayer.fillColor = [UIColor clearColor].CGColor;
        _ltAniView = [[RMCandleAnimateView alloc] initWithFrame:CGRectMake(2.5, 0, 5, 5)];
        _ltAniView.layer.zPosition = 57;
        [self addSubview:_ltAniView];
        _raise0 = [self makeTextLayer];
        _raise0.zPosition = 56;
        _raise1 = [self makeTextLayer];
        _raise1.zPosition = 56;
        _horizontalLayer = [CAShapeLayer layer];
        _horizontalLayer.strokeColor = BackColor.CGColor;
        _horizontalLayer.lineWidth = 1.0;
        _horizontalLayer.fillColor = [UIColor clearColor].CGColor;
        _horizontalLayer.zPosition = 56;
        _horizontalLayer.strokeColor = RedColor.CGColor;
        _horizontalLayer.lineDashPhase  = 1;
        _horizontalLayer.lineDashPattern = @[@(2),@(2)];
        horizontalRaise = [self makeTextLayer];
        [self.layer addSublayer:horizontalRaise];
        horizontalRaise.string = @"0.00%";
        horizontalRaise.zPosition = 56;
        horizontalRaise.hidden = YES;
        horizontalPrice = [self makeTextLayer];
        [self.layer addSublayer:horizontalPrice];
        horizontalPrice.hidden = YES;
        [self.layer addSublayer:_timeLineLayer];
        timeOffsetView = [[RMCandleTimeOffsetView alloc] init];
        [self.layer addSublayer:_raise0];
        [self.layer addSublayer:_raise1];
        [self addSubview:timeOffsetView];
    }
    return self;
}


- (CATextLayer *)makeTextLayer {
    CATextLayer *textLayer = [CATextLayer layer];
    //textLayer.backgroundColor = APPCORLOR.CGColor;
    textLayer.foregroundColor = RGBS(120).CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    UIFont *font = [UIFont systemFontOfSize:10];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    return textLayer;
}


- (void)setAccuracy:(NSUInteger)accuracy {
    _accuracy = accuracy;
    if (_accuracy == 0) {
        priceFloat = 6;
    }else if (accuracy == 2) {
        priceFloat = 0.06;
    }else if (accuracy == 3) {
        priceFloat = 0.15;
    }else if (accuracy == 5) {
        priceFloat = 0.00015;
    }
}
/**
 *  用于分时模式
 *
 *  @return
 */
- (UIBezierPath *)timeLinePath {
    if (_timeLinePath) {
        return _timeLinePath;
    }
    
    _timeLinePath = [UIBezierPath bezierPath];
    return _timeLinePath;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_didLayoutViews) {
        return;
    }
    selfWidth = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat delaY = 0;
    CGFloat topMargin = 5;
    height = floorf(height-35);
    NSInteger f = (NSInteger)height %6;
    
    if (f== 0) {
        delaY = height/6;
    }else{
        delaY = (height -f)/6;
    }
    
    if (f%2 == 0) {
        topMargin += f/2;
    }else{
        topMargin += (f-1)/2;
    }
    _tm_YAxis.YOffset = self.bounds.size.height-30;
    _tm_YAxis.scaleValue = delaY;
    for(int i =0; i<_textLayers.count;++i){
        @autoreleasepool {
            CATextLayer *textLayer = _textLayers[i];
            textLayer.string = @"--";
            CGRect frame = CGRectMake(selfWidth-40, topMargin+delaY*i-6, 40, 12);
            textLayer.frame = frame;
        }
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, topMargin)];
    [path addLineToPoint:CGPointMake(selfWidth -40, topMargin)];
    layer.frame = CGRectMake(0, 0, selfWidth, 1);
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.strokeColor = _dottedLineColor.CGColor;
    layer.lineDashPhase  = 1;
    layer.lineDashPattern = @[@(2),@(2)];
    
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = self.bounds;
    replicatorLayer.instanceCount = 7;
    CATransform3D transform = CATransform3DIdentity;
    transform =  CATransform3DTranslate(transform,0,delaY,0);
    replicatorLayer.instanceTransform = transform;
    [replicatorLayer addSublayer:layer];
    replicatorLayer.zPosition = 1;
    [self.layer addSublayer:replicatorLayer];
    
    //    CGRect frame = CGRectMake(selfWidth-40, height/2.0-6,40, 12);
    //    self.realtimeLayer.frame = frame;
    
    _timeLineLayer.frame = self.bounds;
    [self.layer addSublayer:_timeLineLayer];
    _raise0.frame = CGRectMake(2, topMargin+1, 40, 12);
    _raise1.frame = CGRectMake(2, _tm_YAxis.YOffset-13, 40, 12);
    _fillBackLayer.zPosition = 10;
    _maskLayer.frame = self.bounds; //RGBA(17, 139, 222,0.25)
    _fillBackLayer.backgroundColor = RGBA(126, 206, 253,0.25).CGColor;
    _fillBackLayer.frame = self.bounds;
    _fillBackLayer.mask = _maskLayer;
    _horizontalLayer.frame = self.bounds;
    timeOffsetView.frame = CGRectMake(0, _tm_YAxis.YOffset+5, selfWidth, 30);
    _didLayoutViews = YES;
}

    
// 处理分时数据-first
- (void)dealTimeDataWithHigh:(NSString *)highStr Low:(NSString *)lowStr Times:(NSArray *)times Swing:(NSString *)swing ClosePrice:(NSString *)closePrice Accuracy:(NSString *)accuracy TimeOffset:(NSMutableArray *)timeOffset xAxisMaxValue:(NSInteger)xAxisMaxValue {
    
    if (times.count == 0) {return;}
    
    [_timeLineData removeAllObjects];
    [_timeLinePath removeAllPoints];
    
    double high = [highStr doubleValue];// 最高价
    double low  = [lowStr doubleValue]; // 最低价
    
    
//    NSString *start = [self interceptTimeStampFromNum:startTime];
//    NSString *end = [self interceptTimeStampFromNum:endTime];
//    startTimeOffset = [[start substringWithRange:NSMakeRange(start.length-6, 4)] integerValue];
//    endTimeOffset  = [[end substringWithRange:NSMakeRange(start.length-6, 4)] integerValue];
//    if(endTimeOffset<startTimeOffset){
//        endTimeOffset  += 2400;
//    }
//    NSInteger min = endTimeOffset%100-startTimeOffset%100; // 分钟数
//    min = min==0?:min-1;
//    _xAxisMaxValue = (endTimeOffset/100-startTimeOffset/100)*60 +min;
//    [timeOffsetView drawWithHeaderTime:startTimeOffset FooterTime:endTimeOffset];
    [timeOffsetView drawWithShowTimeArr:timeOffset.firstObject TimeScaleArr:timeOffset.lastObject];
    _xAxisMaxValue = xAxisMaxValue;
    
    
    NSArray *firstValue = (NSArray *)[times firstObject];
    double maxAndMin = [(NSNumber *)firstValue[1] doubleValue];
    maxTimePrice = minPrice = maxAndMin;
    for (NSArray *tempArr in times ) {
        if (tempArr.count < 1) {break;}
        double current = [(NSNumber *)tempArr[1] doubleValue];
        
        if (current> maxTimePrice) {
            maxTimePrice = current;
        }else{
            minPrice = minPrice<current?minPrice:current;
        }
        [_timeLineData addObject:@(current)];
    }
    double floatPrice = MAX((high-maxTimePrice), (minPrice-low));
    double distance = [swing doubleValue];
    /*
     if (_accuracy == 0) {
     distance = _commodity.s;
     }else if(_accuracy == 2){
     distance = 0.02;
     }else if (_accuracy == 3){
     distance = 0.05;
     }else if(_accuracy == 5){
     distance = 0.00015;
     }*/
    floatPrice = floatPrice> distance? distance:floatPrice;
    if (floatPrice == 0) {
        floatPrice = distance;
    }
    
    maxTimePrice = (maxTimePrice> high)?high:maxTimePrice;
    //    maxTimePrice = maxTimePrice+floatPrice;
    
    //minPrice = minPrice-floatPrice;
    [self tm_resetYAxis];
    _swing = swing.doubleValue;
    _closePrice = closePrice.doubleValue;
    _accuracy = [accuracy integerValue];
}

- (void)drawTimeLine {
    isDrawing = YES;
    if (!_ltAniView.superview) {
        [self addSubview:_ltAniView];
    }
    [self.timeLinePath removeAllPoints];
    [self.timeLinePath moveToPoint:CGPointMake(0, _tm_YAxis.YOffset)];
    CGFloat xAxis = 0.0,yAxis = 0.0;
    for (int i=1;i<_timeLineData.count;i++) {
        CGFloat y = [_timeLineData[i] floatValue];
        xAxis = _xAxisMaxValue == 0 ? 0 : i*((selfWidth-40)/_xAxisMaxValue);
        yAxis = [_tm_YAxis calculateYCoordinate:y];
        if (isnan(yAxis)) {yAxis = 0;}
        [_timeLinePath addLineToPoint:CGPointMake(xAxis,yAxis)];
    }
    _ltAniView.center = CGPointMake(xAxis,yAxis);
    _timeLineLayer.path = _timeLinePath.CGPath;
    [_timeLineLayer setNeedsDisplay];
    UIBezierPath *maskPath = [_timeLinePath copy];
    
    [maskPath addLineToPoint:CGPointMake(xAxis,_tm_YAxis.YOffset)];
    [maskPath addLineToPoint:CGPointMake(0, _tm_YAxis.YOffset)];
    //[maskPath addLineToPoint:CGPointMake(0, )];
    //    [maskPath closePath];
    _maskLayer.path = maskPath.CGPath;
    isDrawing = NO;
    
}

/**
 *  重新绘制价格
 */
- (void)tm_resetPrice {
    NSString* format = [NSString stringWithFormat:@"%%.%ldf",_accuracy];
    // NSInteger intMaxTimePrice = (NSInteger) round(maxTimePrice*pow(10, _accuracy));
    // NSInteger intMinPrice = (NSInteger) round(minPrice*pow(10, _accuracy));
    // NSInteger intScale = (intMaxTimePrice-intMinPrice)/6;
    double scale = (maxTimePrice -minPrice)/6.0;
    scale = ((NSInteger) round((scale*pow(10, _accuracy))))/(pow(10, _accuracy));
    scale = pow(10, _accuracy) != 0 ? scale : 0;
    double swing = _swing;
    scale = (maxTimePrice - scale*6>minPrice)?scale+swing:scale;
    
    minPrice = maxTimePrice-scale*6;
    _tm_YAxis.datumValue = maxTimePrice - scale*6;
    _tm_YAxis.scale = scale;
    [self tm_setRaiseRate];
    for(int i =0; i<_textLayers.count;++i){
        CATextLayer  *layer = _textLayers[i];
        
        layer.string = [NSString stringWithFormat:format,maxTimePrice - scale*i];
    }
}


- (void)tm_addNextPointByValue:(double)value {
    if (isDrawing) { // 正在画线
        return;
    }
    CGFloat  yAxis = [_tm_YAxis calculateYCoordinate:value];
    if (isnan(yAxis)) {yAxis = 0;}
    if (yAxis == _ltAniView.center.y) {
        return;
    }
    CGPoint currentPoint = CGPointMake(_ltAniView.center.x, yAxis);
    _ltAniView.center = currentPoint;

    if (value>maxTimePrice) {
        maxTimePrice= value+_swing;
        [self tm_resetYAxis];
    }
    if (value< minPrice) {
        minPrice = value-_swing;
        [self tm_resetYAxis];
    }
    UIBezierPath *timePath = [_timeLinePath copy];
    [timePath addLineToPoint:_ltAniView.center];
    _timeLineLayer.path = timePath.CGPath;
}

- (void)tm_resetYAxis {
    MAIN_THREAD(^{
        [self tm_resetPrice];
        [self drawTimeLine];
        
    });
}

- (void)tm_setRaiseRate {
    if (_closePrice == 0) {
        return;
    }
    CGFloat raise0 = (maxTimePrice -_closePrice)/_closePrice;
    CGFloat raise1 = (minPrice-_closePrice)/_closePrice;
    
    NSInteger num0 = round(raise0 *10000);
    NSInteger num1 = round(raise1 *10000);
    
    if (num0 < 0) {
        _raise0.foregroundColor = GreenColor.CGColor;
        _raise0.string = [NSString stringWithFormat:@"%.2f%%",raise0*100];
    }else{
        if(num0 == 0){
            _raise0.foregroundColor = RGBS(120).CGColor;
            _raise0.string = @"0.00%";
        }else {
            _raise0.foregroundColor = RedColor.CGColor;
            _raise0.string = [NSString stringWithFormat:@"+%.2f%%",raise0*100];
        }
    }
    if (num1 < 0) {
        _raise1.foregroundColor = GreenColor.CGColor;
        _raise1.string = [NSString stringWithFormat:@"%.2f%%",raise1*100];
        
    }else{
        if(num1 == 0){
            _raise1.foregroundColor = RGBS(120).CGColor;
            _raise1.string = @"0.00%";
        }else{
            _raise1.foregroundColor = RedColor.CGColor;
            _raise1.string = [NSString stringWithFormat:@"+%.2f%%",raise1*100];
        }
    }
    _raise0.hidden = NO;
    _raise1.hidden = NO;
    _raise1.zPosition = 60;
    _raise0.zPosition = 60;
    
    
    if (num1*num0 < 0) {
        [self showHorizontalLine];
    }
    
}


- (void)showHorizontalLine{
    if (!_horizontalLayer.superlayer) {
        [self.layer addSublayer:_horizontalLayer];
    }
    CGFloat y = [_tm_YAxis calculateYCoordinate:_closePrice];
    if (isnan(y)) {y = 0;}
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, y)];
    [path addLineToPoint:CGPointMake(selfWidth-40, y)];
    
    [CATransaction setDisableActions:YES];
    _horizontalLayer.path = path.CGPath;
    NSString* format = [NSString stringWithFormat:@"%%.%ldf",_accuracy];
    horizontalPrice.string = [NSString stringWithFormat:format,_closePrice];
    horizontalPrice.hidden = NO;
    horizontalRaise.hidden = NO;
    horizontalPrice.backgroundColor = BackColor.CGColor;
    horizontalRaise.backgroundColor = BackColor.CGColor;
    CGRect frame = CGRectMake(selfWidth-40, y-6, 40, 12);
    horizontalPrice.frame = frame;
    frame.origin.x = 2;
    frame.origin.y = y+2;
    horizontalRaise.frame = frame;
    [CATransaction setDisableActions:NO];
}



- (void)reset {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timeLinePath removeAllPoints];
        _timeLineLayer.path = _timeLinePath.CGPath;
        _fillBackLayer.path = _timeLinePath.CGPath;
        _maskLayer.path = _timeLinePath.CGPath;
        _ltAniView.center = CGPointMake(0,self.bounds.size.height/2.0);
        [_timeLineData removeAllObjects];
        maxTimePrice = 0;
        minPrice = 0;
        currPrice = 0;
        [_horizontalLayer removeFromSuperlayer];
        horizontalPrice.hidden = YES;
        horizontalRaise.hidden = YES;
    });
}

- (NSString *)interceptTimeStampFromNum:(NSNumber *)time {
    if (!time) {  // 字符串为空判断
        return @"";
    }
    
    NSString * format = @"yyyyMMddHHmmss";
    // 把时间戳转化成时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:format];
    NSString * timeStr = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
    
    return timeStr;
}

@end
