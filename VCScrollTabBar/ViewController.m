//
//  ViewController.m
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/21.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import "ViewController.h"
#import "VCScrollTabBar.h"
#import "UIView+LayoutConstraints.h"
#import "UIColor+Helper.h"

@interface ViewController()<VCScrollTabBarDelegate>
@property (weak, nonatomic) IBOutlet VCScrollTabBar *scrollTabBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, copy) NSArray<NSString *> *titleInfos;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarScrollView];
    
    [self createSubView];
    
}

#pragma mark - private

- (void)setupTabBarScrollView {
    [self.scrollTabBar updateTitleInfos:self.titleInfos];
    self.scrollTabBar.externalScrollView = self.scrollView;
    self.scrollTabBar.tarBarDelegate = self;
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

#pragma mark - Action

- (IBAction)changeConfigOnClick:(id)sender {
    VCScrollTabBarConfig *config = [VCScrollTabBarConfig defaultConfig];
    config.showBottomIndicatorView = NO;
    config.showCenterIndicatorView = YES;
    
    [self.scrollTabBar updateConfig:config];
}



#pragma mark - VCScrollTabBarDelegate

- (void)scrollTabBar:(VCScrollTabBar *)scrollTabBar selectedIndex:(NSInteger)selectedIndex {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:CGPointMake(pageWidth *selectedIndex, 0) animated:NO];
}

#pragma mark - accessor

- (NSArray<NSString *> *)titleInfos {
    return @[@"練習生", @"熱門", @"遊戲", @"音樂才藝", @"新星彩", @"星之冠", @"男神", @"附近"];
}

@end
