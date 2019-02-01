//
//  ViewController1.m
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/23.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import "ViewController1.h"
#import "VCScrollTabBar.h"
#import "UIView+LayoutConstraints.h"
#import "UIColor+Helper.h"

@interface ViewController1()<VCScrollTabBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) VCScrollTabBar *scrollTabBar;
@property (nonatomic, copy) NSArray<NSString *> *titleInfos;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarScrollView];
    [self createSubView];
}

- (void)setupTabBarScrollView {
    VCScrollTabBarConfig *config = [VCScrollTabBarConfig defaultConfig];
    config.showCenterIndicatorView = YES;
    config.showBottomIndicatorView = NO;
    
    self.scrollTabBar = [[VCScrollTabBar alloc] init];
    self.scrollTabBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollTabBar configureTitleInfos:self.titleInfos config:config scrollView:self.scrollView tarBarDelegate:self];
    [self.containerView addSubview:self.scrollTabBar];
    
    NSArray *constaints = @[[self.containerView.topAnchor constraintEqualToAnchor:self.scrollTabBar.topAnchor],
                            [self.containerView.bottomAnchor constraintEqualToAnchor:self.scrollTabBar.bottomAnchor],
                            [self.containerView.leadingAnchor constraintEqualToAnchor:self.scrollTabBar.leadingAnchor],
                            [self.containerView.trailingAnchor constraintEqualToAnchor:self.scrollTabBar.trailingAnchor],
                            ];
    [NSLayoutConstraint activateConstraints:constaints];
}

- (void)createSubView {
    NSMutableArray *subView = [NSMutableArray new];
    [self.titleInfos enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor ramdomColor];
        [self.scrollView addSubview:view];
        [subView addObject:view];
    }];
    
    [self.scrollView addScrollViewLayoutConstraintWithSubViews:[subView copy]];
}

- (void)scrollTabBar:(VCScrollTabBar *)scrollTabBar selectedIndex:(NSInteger)selectedIndex {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:CGPointMake(pageWidth *selectedIndex, 0) animated:NO];
}


#pragma mark - accessor

- (NSArray<NSString *> *)titleInfos {
    return @[@"練習生", @"熱門", @"遊戲", @"音樂才藝", @"新星彩", @"星之冠", @"男神", @"附近"];
}

@end
