//
//  UIColor+Hex.m
//  Pop
//
//  Created by 张宝山 on 2019/11/27.
//  Copyright © 2019 张宝山. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

/*
 16进制颜色 支持 @"#123456" @"0x123456" @"123456" 三种格式
 */
+ (UIColor *)colorWithHexString:(NSString *)HexColor {
    //删除字符串中的空格
    NSString *cString = [[HexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rstring = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gstring = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bstring = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rstring] scanHexInt:&r];
    [[NSScanner scannerWithString:gstring] scanHexInt:&g];
    [[NSScanner scannerWithString:bstring] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f ) blue:((float)b / 255.0f) alpha:1.0f];
}

@end
