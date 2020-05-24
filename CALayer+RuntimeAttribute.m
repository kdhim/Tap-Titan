//
//  CALayer+RuntimeAttribute.m
//  Tap King
//
//  Created by kevin dhimitri on 7/11/14.
//  Copyright (c) 2014 kevin dhimitri. All rights reserved.
//


#import "CALayer+RuntimeAttribute.h"

@implementation CALayer (IBConfiguration)

-(void)setBorderIBColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderIBColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setShadowIBColor:(UIColor*)color
{
    self.shadowColor = color.CGColor;
}

-(UIColor*)shadowIBColor
{
    return [UIColor colorWithCGColor:self.shadowColor];
}

@end