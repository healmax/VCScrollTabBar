//
//  UILabel+TextColorAnimation.m
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/22.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import "UILabel+TextColorAnimation.h"

@implementation UILabel (TextColorAnimation)

- (void)changeTextColor:(UIColor *)newColor withDuration:(NSTimeInterval)interval
{
    UILabel *fakeLabel = [[UILabel alloc] initWithFrame:self.bounds];
    fakeLabel.textColor = newColor;
    fakeLabel.textAlignment = self.textAlignment;
    fakeLabel.text = self.text;
    fakeLabel.layer.opacity = 0.0f;
    fakeLabel.backgroundColor = [UIColor clearColor];
    fakeLabel.font = self.font;
    
    [self addSubview:fakeLabel];
    [UIView animateWithDuration:interval animations:^{
        fakeLabel.layer.opacity = 1.0f;
    } completion:^(BOOL finished){
        self.textColor = newColor;
        [fakeLabel removeFromSuperview];
    }];
}

@end
