//
//  UIView+LayoutConstraints.h
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/23.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LayoutConstraints)

- (void)addScrollViewLayoutConstraintWithSubViews:(NSArray<UIView *> *)subViews;

@end

NS_ASSUME_NONNULL_END
