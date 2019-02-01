//
//  VCScrollTabBar.m
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/21.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import "VCScrollTabBar.h"


@interface VCScrollTabBarConfig()

@end

@implementation VCScrollTabBarConfig

+ (instancetype)defaultConfig {
    VCScrollTabBarConfig *config = [[VCScrollTabBarConfig alloc] init];
    
    config.centerIndicatorViewColor = [UIColor yellowColor];
    config.showCenterIndicatorView = NO;
    
    config.bottomIndicatorViewColor = [UIColor blackColor];
    config.showBottomIndicatorView = YES;
    config.bottomIndicatorViewLength = 10.f;
    
    config.buttonTitleSelectedFont = [UIFont boldSystemFontOfSize:20.0];
    config.buttonTitleDefaultFont = [UIFont boldSystemFontOfSize:15.0];
    config.buttonTitleSelectedColor = [UIColor blackColor];
    config.buttonTitleDefaultColor = [UIColor grayColor];
    
    return config;
}

@end

static NSInteger const kButtonHorizontalInset = 10.f;

@interface VCScrollTabBar()

@property (nonatomic, strong, readwrite) VCScrollTabBarConfig *config;

@property (nonatomic, copy) NSArray<NSString *> *titleInfos;
@property (nonatomic, copy) NSArray<UIButton *> *tabBarButtons;

@property (nonatomic, strong) UIView *centerIndicatorView;
@property (nonatomic, strong) NSLayoutConstraint *centerIndicatorViewLeadingCT;
@property (nonatomic, strong) NSLayoutConstraint *centerIndicatorViewWidthCT;

@property (nonatomic, strong) UIView *bottomIndicatorView;
@property (nonatomic, strong) NSLayoutConstraint *bottomIndicatorViewLeadingCT;

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation VCScrollTabBar

#pragma mark - life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (void)configureTitleInfos:(NSArray<NSString *> *)titleInfos config:(VCScrollTabBarConfig *)config scrollView:(UIScrollView *) scrollView tarBarDelegate:(id<VCScrollTabBarDelegate>)tarBarDelegate {
    self.titleInfos = titleInfos;
    self.config = config;
    self.externalScrollView = scrollView;
    self.tarBarDelegate = tarBarDelegate;
    [self commonInit];
    [self updateTitleInfos:titleInfos];
}

#pragma mark - public

- (void)updateTitleInfos:(NSArray<NSString *> *)titleInfos {
    self.titleInfos = titleInfos;
    [self configureTabBarButtonWithTitleInfos:titleInfos];
    [self configureCenterIndicatorView];
    [self configureBottomIndicatorView];
    [self selectTabButtonWithIndex:0];
}

- (void)updateConfig:(VCScrollTabBarConfig *)config {
    self.config = config;
    [self updateTitleInfos:self.titleInfos];
}

#pragma mark - private

- (void)commonInit {
    self.currentIndex = 0;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    if (!_config) {
        _config = [VCScrollTabBarConfig defaultConfig];
    }
}

/**
 配置TabBar button
 
 @param titleInfos : TabBar button的Title
 */
- (void)configureTabBarButtonWithTitleInfos:(NSArray<NSString *> *)titleInfos {
    [self.tabBarButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.tabBarButtons = [self tabBarButtonsWithTitleInfos:titleInfos];
    for (UIButton *button in self.tabBarButtons) {
        [self addSubview:button];
    }
    [self configureTabBarButtonsConstraints:self.tabBarButtons];
}

/**
 配置TabBar button constraints
 */
- (void)configureTabBarButtonsConstraints:(NSArray<UIButton *> *)tabBarButtons {
    
    CGFloat widthOfAllButtons = [self widthOfAllButtons];
    CGFloat extendWidth = CGRectGetWidth(self.frame) - widthOfAllButtons;
    BOOL needExtendWidth = extendWidth > 0;
    
    [tabBarButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeConstraints:obj.constraints];
        obj.translatesAutoresizingMaskIntoConstraints = NO;
        
        BOOL isFirstBtn = idx == 0;
        BOOL isLastBtn = idx == self.tabBarButtons.count - 1;
        
        CGFloat defaultWidth = [self titleSizeWithButton:obj].width + 2 * kButtonHorizontalInset;
        CGFloat realWidth = needExtendWidth ? defaultWidth + (defaultWidth / widthOfAllButtons) * extendWidth : defaultWidth;
        
        NSLayoutConstraint *topCT = [self.topAnchor constraintEqualToAnchor:obj.topAnchor];
        NSLayoutConstraint *leftCT = isFirstBtn ? [self.leadingAnchor constraintEqualToAnchor:obj.leadingAnchor] : [self.tabBarButtons[idx-1].trailingAnchor constraintEqualToAnchor:obj.leadingAnchor];
        NSLayoutConstraint *bottomCT = [self.bottomAnchor constraintEqualToAnchor:obj.bottomAnchor];
        NSLayoutConstraint *rightCT = isLastBtn ? [self.trailingAnchor constraintEqualToAnchor:obj.trailingAnchor] : nil;
        
        NSLayoutConstraint *widthCT = [obj.widthAnchor constraintEqualToConstant:realWidth];
        NSLayoutConstraint *heightCT = [obj.heightAnchor constraintEqualToAnchor:self.heightAnchor];
        
        [NSLayoutConstraint activateConstraints:@[topCT, leftCT, bottomCT, widthCT, heightCT]];
        
        if (rightCT) {
            rightCT.active = YES;
        }
    }];
    
    [self layoutIfNeeded];
}

/**
 配置Center Indicator, 此Indicator為一個色塊區域，顯示在TabBar Button Title後面的一個View
 */
- (void)configureCenterIndicatorView {
    if (self.centerIndicatorView ) {
        [self.centerIndicatorView removeFromSuperview];
        self.centerIndicatorView = nil;
    }
    
    if (!self.config.showCenterIndicatorView) {
        return;
    }
    
    self.centerIndicatorView = [[UIView alloc] init];
    self.centerIndicatorView.backgroundColor = [UIColor yellowColor];
    self.centerIndicatorView.layer.cornerRadius = 3.f;
    self.centerIndicatorView.hidden = !self.config.showCenterIndicatorView;
    
    [self insertSubview:self.centerIndicatorView atIndex:0];
    [self configureCenterIndicatorViewConstraints];
}

/**
 配置Center Indicator constraints
 */
- (void)configureCenterIndicatorViewConstraints {
    if (!self.config.showCenterIndicatorView) {
        return;
    }
    
    UIButton *firstButton = self.tabBarButtons.firstObject;
    CGFloat buttonHeight = CGRectGetHeight(firstButton.frame);
    CGFloat titleWidth = [self titleSizeWithButton:firstButton].width;
    CGFloat titleHeight = [self titleSizeWithButton:firstButton].height;
    CGFloat bottomConstant = (buttonHeight + titleHeight)/2;
    
    self.centerIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.centerIndicatorView removeConstraints:self.centerIndicatorView.constraints];
    
    self.centerIndicatorViewLeadingCT = [self.centerIndicatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    self.centerIndicatorViewWidthCT = [self.centerIndicatorView.widthAnchor constraintEqualToConstant:titleWidth];
    NSLayoutConstraint *bottomCT = [self.centerIndicatorView.bottomAnchor constraintEqualToAnchor:self.topAnchor constant:bottomConstant];
    NSLayoutConstraint *heightCT = [self.centerIndicatorView.heightAnchor constraintEqualToConstant:titleHeight / 2];
    
    [NSLayoutConstraint activateConstraints:@[self.centerIndicatorViewLeadingCT, bottomCT, self.centerIndicatorViewWidthCT, heightCT]];
    
    [self layoutIfNeeded];
}

/**
 配置Bottom Indicator, 此Indicator為一個底線，顯示在TabBar Button Title的正下方
 */
- (void)configureBottomIndicatorView {
    if (self.bottomIndicatorView ) {
        [self.bottomIndicatorView removeFromSuperview];
        self.bottomIndicatorView = nil;
    }
    
    if (!self.config.showBottomIndicatorView) {
        return;
    }
    
    self.bottomIndicatorView = [[UIView alloc] init];
    self.bottomIndicatorView.backgroundColor = [UIColor blackColor];
    self.bottomIndicatorView.hidden = !self.config.showBottomIndicatorView;
    
    [self addSubview:self.bottomIndicatorView];
    [self configureBottomIndicatorViewConstraints];
}

/**
 配置Bottom Indicator Constraints
 */
- (void)configureBottomIndicatorViewConstraints {
    if (!self.config.showBottomIndicatorView) {
        return;
    }
    
    UIButton *firstButton = self.tabBarButtons.firstObject;
    CGFloat buttonHeight = CGRectGetHeight(firstButton.frame);
    CGFloat titleHeight = [self titleSizeWithButton:firstButton].height;
    CGFloat bottomConstant = (buttonHeight + titleHeight)/2;
    
    self.bottomIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomIndicatorView removeConstraints:self.bottomIndicatorView.constraints];
    
    self.bottomIndicatorViewLeadingCT = [self.bottomIndicatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *widthCT = [self.bottomIndicatorView.widthAnchor constraintEqualToConstant:self.config.bottomIndicatorViewLength];
    NSLayoutConstraint *bottomCT = [self.bottomIndicatorView.bottomAnchor constraintEqualToAnchor:self.topAnchor constant:bottomConstant + 5];
    NSLayoutConstraint *heightCT = [self.bottomIndicatorView.heightAnchor constraintEqualToConstant:1];
    
    [NSLayoutConstraint activateConstraints:@[self.bottomIndicatorViewLeadingCT, bottomCT, widthCT, heightCT]];
    
    [self layoutIfNeeded];
}

/**
 透過Titles取得多個TabBar Buttons
 @param titleInfos : TabBar Buttons的Title
 */
- (NSArray<UIButton *> *)tabBarButtonsWithTitleInfos:(NSArray<NSString *> *)titleInfos {
    NSMutableArray *buttons = [NSMutableArray new];
    for (NSString *title in titleInfos) {
        [buttons addObject:[self tabBarButtonWithTitleInfo:title]];
    }
    
    return [buttons copy];
}

/**
 透過Title取得TabBar Button
 @param titleInfo : TabBar Button的Title
 */
- (UIButton *)tabBarButtonWithTitleInfo:(NSString *)titleInfo {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = self.config.buttonTitleDefaultFont;
    [button setTitle:titleInfo forState:UIControlStateNormal];
    [button setTitleColor:self.config.buttonTitleDefaultColor forState:UIControlStateNormal];
    [button setTitleColor:self.config.buttonTitleSelectedColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tabBarButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/**
 取消所有TabBar Button的選取狀態
 */
- (void)deselectButtons {
    for (UIButton *btn in self.tabBarButtons) {
        btn.selected = NO;
    }
}

/**
 所有TabBar Button所需要的長度
 */
- (CGFloat)widthOfAllButtons {
    __block CGFloat width = 0.0f;
    [self.tabBarButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        width += [self titleSizeWithButton:obj].width + 2 * kButtonHorizontalInset;
    }];
    
    return width;
}

/**
 TabBar Button Title所需要的長度用Config的buttonTitleMaxFontSize去計算
 */
- (CGSize)titleSizeWithButton:(UIButton *)button {
    CGSize constrainSize = CGSizeMake(300, 100);
    UIFont *font = self.config.buttonTitleSelectedFont;
    NSString *text = button.titleLabel.text;
    
    CGRect titleRect = [text boundingRectWithSize:(constrainSize)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    return titleRect.size;
}

/**
 相對於Superview Center Indicator在第index TabBar Button的起始位置X
 @param index : TabBar Button的index
 */
- (CGFloat)centerIndicatorViewStartPositionXWithIndex:(NSInteger)index {
    UIButton *button = [self.tabBarButtons objectAtIndex:index];
    CGSize titleSize = [self titleSizeWithButton:button];
    CGFloat positionX = CGRectGetMidX(button.frame);
    
    return positionX - (titleSize.width/2);
}


/**
 相對於Superview Botton Indicator在第index TabBar Button的起始位置X
 @param index : TabBar Button的index
 */
- (CGFloat)bottomIndicatorViewStartPositionXWithIndex:(NSInteger)index {
    UIButton *button = [self.tabBarButtons objectAtIndex:index];
    CGFloat positionX = CGRectGetMidX(button.frame);
    
    return positionX - self.config.bottomIndicatorViewLength/2;
}

/**
 TabBar Button 點擊後事件
 */
- (void)tabBarButtonOnClick:(UIButton *)button {
    NSInteger index = [self.tabBarButtons indexOfObject:button];
    [self selectTabButtonWithIndex:index];
}

/**
 選取第X個Button
 @param index : TabBar Button 的 index
 */
- (void)selectTabButtonWithIndex:(NSInteger)index {
    
    UIButton *previousButton = [self.tabBarButtons objectAtIndex:self.currentIndex];
    UIButton *currentButton = [self.tabBarButtons objectAtIndex:index];
    
    CGSize titleSize = [self titleSizeWithButton:currentButton];
    
    self.centerIndicatorViewWidthCT.constant = titleSize.width;
    self.centerIndicatorViewLeadingCT.constant = [self centerIndicatorViewStartPositionXWithIndex:index];
    
    self.bottomIndicatorViewLeadingCT.constant = [self bottomIndicatorViewStartPositionXWithIndex:index];
    
    previousButton.titleLabel.font = self.config.buttonTitleDefaultFont;
    currentButton.titleLabel.font = self.config.buttonTitleSelectedFont;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.currentIndex = index;
    
    if ([self.tarBarDelegate respondsToSelector:@selector(scrollTabBar:selectedIndex:)]) {
        [self.tarBarDelegate scrollTabBar:self selectedIndex:index];
    }
}

/**
 更新UI(Bottom Indicator, Center Indicator, Button Select Status, SCrollTabBar的Content Offset)
 時機為外層的Scroll View滑動時
 */
- (void)updateUIWhenExternalScrollViewContentOffsetChanged:(UIScrollView *)scrollView {    
    CGFloat pageWidth = scrollView.contentSize.width/self.titleInfos.count;
    
    NSInteger leftPageIndex = scrollView.contentOffset.x / pageWidth;
    NSInteger leftPageStartContentOffsetX = pageWidth * leftPageIndex;
    
    //當定位到某一頁時, VCScrollTabBar調整到適當的content offset
    if ((NSInteger)scrollView.contentOffset.x % (NSInteger)pageWidth == 0) {
        [self deselectButtons];
        self.tabBarButtons[leftPageIndex].selected = YES;
        self.currentIndex = leftPageIndex;
        [self adjustContentOffsetWithIndex:leftPageIndex];
        return;
    }
    
    //現在contentOffsetX與左邊那頁contentOffsetX起始值的差值
    //EX 從第一面滑到第二面的過程中假如contentOffsetX為50 offsetFromLeftPageStartContentOffset = 50 - 0(第一頁面contentOffsetX的起始直)
    NSInteger distanceFromLeftPageStartContentOffset = scrollView.contentOffset.x - leftPageStartContentOffsetX;
    
    //從左邊那頁面到右邊那頁面移動的percentage
    CGFloat percentage =  distanceFromLeftPageStartContentOffset/pageWidth;
    
    //左方的button的title Size
    CGSize leftButtonTitleSize = [self titleSizeWithButton:self.tabBarButtons[leftPageIndex]];
    //右方的button的title Size
    CGSize rightButtonTitleSize = [self titleSizeWithButton:self.tabBarButtons[leftPageIndex+1]];
    
    //計算對應的centerIndicatorView的Width
    CGFloat titleDiffWidth = (leftButtonTitleSize.width - rightButtonTitleSize.width) * percentage;
    self.centerIndicatorViewWidthCT.constant = leftButtonTitleSize.width - titleDiffWidth;
    
    //左邊Title起始位置到右邊Title的起始位置距離
    CGFloat buttonTitleHeahToHeadDistance = [self centerIndicatorViewStartPositionXWithIndex:leftPageIndex+1] - [self centerIndicatorViewStartPositionXWithIndex:leftPageIndex];
    
    CGFloat offsetToHeadTitle = buttonTitleHeahToHeadDistance * percentage;
    self.centerIndicatorViewLeadingCT.constant = [self centerIndicatorViewStartPositionXWithIndex:leftPageIndex] + offsetToHeadTitle;
    
    //左邊Indicator起始位置到next Indicator起始位置的距離
    CGFloat bottomIndicatorHeahToHeadDistance = [self bottomIndicatorViewStartPositionXWithIndex:leftPageIndex+1] - [self bottomIndicatorViewStartPositionXWithIndex:leftPageIndex];
    CGFloat offsetToHeadIndicator = bottomIndicatorHeahToHeadDistance * percentage;
    self.bottomIndicatorViewLeadingCT.constant = [self bottomIndicatorViewStartPositionXWithIndex:leftPageIndex] + offsetToHeadIndicator;
    
    CGFloat fontSize = (self.config.buttonTitleSelectedFont.pointSize - self.config.buttonTitleDefaultFont.pointSize) * percentage;
    
    UIFont *leftFont = [self.config.buttonTitleDefaultFont fontWithSize:self.config.buttonTitleSelectedFont.pointSize - fontSize];
    UIFont *rightFont = [self.config.buttonTitleDefaultFont fontWithSize:self.config.buttonTitleDefaultFont.pointSize + fontSize];
    
    self.tabBarButtons[leftPageIndex].titleLabel.font = leftFont;
    self.tabBarButtons[leftPageIndex+1].titleLabel.font = rightFont;
    
    [self deselectButtons];
    if (percentage >= 0.5) {
        self.tabBarButtons[leftPageIndex+1].selected = YES;
        self.currentIndex = leftPageIndex+1;
    } else {
        self.tabBarButtons[leftPageIndex].selected = YES;
        self.currentIndex = leftPageIndex;
    }
    
    [self layoutIfNeeded];
}

/**
 調整到對應的contentoffset當選取了某一個TabBar Index(讓選取的TabBar Button置中)
 */
- (void)adjustContentOffsetWithIndex:(NSInteger)index {
    UIButton *targetButton = self.tabBarButtons[index];
    CGFloat targetSuperviewX = CGRectGetMinX([self convertRect:targetButton.frame toView:self.superview]);
    CGFloat targetSuperviewCenteredX = (CGRectGetWidth(self.superview.frame) - CGRectGetWidth(targetButton.frame)) / 2;
    CGFloat targetXDiff = targetSuperviewCenteredX - targetSuperviewX;
    CGFloat targetContentOffsetX = self.contentOffset.x - targetXDiff;
    CGFloat maxContentOffsetX = self.contentSize.width - CGRectGetWidth(self.frame);
    if (targetContentOffsetX < 0) {
        targetContentOffsetX = 0;
    } else if (targetContentOffsetX > maxContentOffsetX) {
        targetContentOffsetX = maxContentOffsetX;
    }
    if (self.contentOffset.x != targetContentOffsetX) {
        [self setContentOffset:CGPointMake(targetContentOffsetX, self.contentOffset.y) animated:YES];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if (object == self.externalScrollView && [keyPath isEqualToString:@"contentOffset"]) {
        if (self.externalScrollView .contentSize.width == 0) {
            return;
        }
        [self updateUIWhenExternalScrollViewContentOffsetChanged:object];
    }
}

#pragma mark - accessor

- (void)setExternalScrollView:(UIScrollView *)externalScrollView {
    if (_externalScrollView) {
        [_externalScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _externalScrollView = externalScrollView;
    [_externalScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}

@end
