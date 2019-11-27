//
//  UIColor+Hex.h
//  Pop
//
//  Created by 张宝山 on 2019/11/27.
//  Copyright © 2019 张宝山. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Hex(A)  [UIColor colorWithHexString:A];

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)HexColor;

@end

NS_ASSUME_NONNULL_END
