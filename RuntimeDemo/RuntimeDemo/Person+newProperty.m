//
//  Person+newProperty.m
//  RuntimeDemo
//
//  Created by sphere on 2017/9/12.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "Person+newProperty.h"

@implementation Person (newProperty)
// getter方法
- (NSString *)hobby
{
    // 获取关联,_cmd标示这个方法自身
    return objc_getAssociatedObject(self, _cmd);
}

// setter
- (void)setHobby:(NSString *)hobby
{
    // 绑定关联
    objc_setAssociatedObject(self, @selector(hobby), hobby, OBJC_ASSOCIATION_COPY);
}

@end
