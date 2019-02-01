//
//  VCScrollTabBar.h
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/21.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCScrollTabBarConfig : NSObject

+ (instancetype)defaultConfig;

//CenterIndicatorView為一個色塊區域，顯示在TabBar Button Title後面,
//CenterIndicatorViewColor配置此View的色塊
@property (nonatomic, strong) UIColor *centerIndicatorViewColor;

//是否顯示CenterIndicatorView
@property (nonatomic, assign) BOOL showCenterIndicatorView;

//BottomIndicatorView的顏色
@property (nonatomic, strong) UIColor *bottomIndicatorViewColor;
//BottomIndicatorView 底底線長度
@property (nonatomic, assign) CGFloat bottomIndicatorViewLength;
//是否顯示BottomIndicatorView
@property (nonatomic, assign) BOOL showBottomIndicatorView;


@property (nonatomic, strong) UIFont *buttonTitleSelectedFont;
@property (nonatomic, strong) UIFont *buttonTitleDefaultFont;

//TabBar Button 被選取時的顏色
@property (nonatomic, strong) UIColor *buttonTitleSelectedColor;
//TabBar Button default時的顏色
@property (nonatomic, strong) UIColor *buttonTitleDefaultColor;

@end


@class VCScrollTabBar;

@protocol VCScrollTabBarDelegate <NSObject>

- (void)scrollTabBar:(VCScrollTabBar *)scrollTabBar selectedIndex:(NSInteger)selectedIndex;

@end


@interface VCScrollTabBar : UIScrollView

@property (nonatomic, weak) UIScrollView *externalScrollView;
@property (nonatomic, weak) id<VCScrollTabBarDelegate> tarBarDelegate;
@property (nonatomic, strong, readonly) VCScrollTabBarConfig *config;

- (void)configureTitleInfos:(NSArray<NSString *> *)titleInfos config:(VCScrollTabBarConfig *)config scrollView:(UIScrollView *) scrollView tarBarDelegate:(id<VCScrollTabBarDelegate>)tarBarDelegate;

/**
 更新titleInfos
 @param titleInfos : TabBar Button 上的 titles
 */
- (void)updateTitleInfos:(NSArray<NSString *> *)titleInfos;

/**
 更新config
 @param config : VCScrollTabBarConfig
 */
- (void)updateConfig:(VCScrollTabBarConfig *)config;

@end

NS_ASSUME_NONNULL_END
