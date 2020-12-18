/*
 作者：  RMCandleKit
 文件：  RMCandleTopBarView.h
 版本：  1.0 <2016.10.05>
 地址：
 描述：  封装多View选择器
 */

#import <UIKit/UIKit.h>
@class RMCandleTopBarView;

typedef NS_ENUM(NSUInteger, YYTopBarDistributionStyle) {
    YYTopBarDistributionStyleInScreen = 1,
    YYTopBarDistributionStyleOutScreen
};

@protocol RMCandleTopBarViewDelegate <NSObject>

@required
- (void)RMCandleTopBarView:(RMCandleTopBarView *)topBarView didSelectedIndex:(NSInteger)index;
@end


@interface RMCandleTopBarView : UIView

/**
 按钮点击代理
 */
@property (nonatomic, weak) id <RMCandleTopBarViewDelegate> delegate;

/**
 初始化方法

 @param titleItems 传入标题数组
 @param style       是否限制所有的按钮都在一屏内

 @return RMCandleTopBarView
 */
- (instancetype)initWithItems:(NSArray <NSString *>*)titleItems distributionStyle: (YYTopBarDistributionStyle)style;

/**
 选中按钮
 
 @param index 按钮index = 0,1,...
 */
- (void)selectIndex:(NSInteger)index;
@end
