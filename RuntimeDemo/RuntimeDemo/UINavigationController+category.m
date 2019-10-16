//
//  UINavigationController+category.m
//  RuntimeDemo
//
//  Created by sphere on 2017/9/8.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "UINavigationController+category.h"

@implementation UINavigationController (category)
+ (void)load
{
    [super load];
    
    // 导航栏背景色
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:42/255.0 green:92/255.0 blue:170/255.0 alpha:1.0];
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    // 标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
