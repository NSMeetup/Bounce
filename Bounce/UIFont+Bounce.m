//
//  UIFont+Bounce.m
//  Bounce
//
//  Created by Leah Culver on 3/30/13.
//  Copyright (c) 2013 Summertime. All rights reserved.
//

#import "UIFont+Bounce.h"

@implementation UIFont (Bounce)

+ (UIFont *)openSansLightWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Light" size:fontSize];
}

+ (UIFont *)openSansLightItalicWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-LightItalic" size:fontSize];
}

+ (UIFont *)openSansSemiboldWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans-Semibold" size:fontSize];
}

@end
