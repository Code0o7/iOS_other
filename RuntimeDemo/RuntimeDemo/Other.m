//
//  Other.m
//  RuntimeDemo
//
//  Created by sphere on 2017/9/8.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "Other.h"

@implementation Other

- (void)newMethod
{
    NSLog(@"消息被转发给%@的%s方法",NSStringFromClass([self class]),__func__);
}

@end
