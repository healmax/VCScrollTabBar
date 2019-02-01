//
//  UIColor+Helper.m
//  VCScrollTabBar
//
//  Created by healmax healmax on 2019/1/23.
//  Copyright © 2019 com.healmax. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)ramdomColor {
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    return [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
}

@end
