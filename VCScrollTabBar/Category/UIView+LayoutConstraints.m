//
//  UIView+LayoutConstraints.m
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/23.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import "UIView+LayoutConstraints.h"

@implementation UIView (LayoutConstraints)

- (void)addScrollViewLayoutConstraintWithSubViews:(NSArray<UIView *> *)subViews {
    
    [subViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
        
        BOOL isFirstBtn = idx == 0;
        BOOL isLastBtn = idx == subViews.count - 1;
        
        NSLayoutConstraint *topCT = [self.topAnchor constraintEqualToAnchor:obj.topAnchor];
        NSLayoutConstraint *leftCT = isFirstBtn ? [self.leadingAnchor constraintEqualToAnchor:obj.leadingAnchor] : [subViews[idx-1].trailingAnchor constraintEqualToAnchor:obj.leadingAnchor];
        NSLayoutConstraint *bottomCT = [self.bottomAnchor constraintEqualToAnchor:obj.bottomAnchor];
        NSLayoutConstraint *rightCT = isLastBtn ? [self.trailingAnchor constraintEqualToAnchor:obj.trailingAnchor] : nil;
        
        NSLayoutConstraint *widthCT = [obj.widthAnchor constraintEqualToAnchor:self.widthAnchor];
        NSLayoutConstraint *heightCT = [obj.heightAnchor constraintEqualToAnchor:self.heightAnchor];
        
        [NSLayoutConstraint activateConstraints:@[topCT, leftCT, bottomCT, widthCT, heightCT]];
        
        if (rightCT) {
            rightCT.active = YES;
        }
    }];
}

@end
