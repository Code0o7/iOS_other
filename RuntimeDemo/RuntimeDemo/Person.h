//
//  Person.h
//  RuntimeDemo
//
//  Created by sphere on 2017/9/7.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

@interface Person : NSObject
// 姓名
@property (nonatomic, copy) NSString *name;
// 年龄
@property (nonatomic, assign) NSInteger age;
// 出生年月
@property (nonatomic, copy) NSString *birthday;
// 身份证号
@property (nonatomic, copy) NSString *identify;
// 职业
@property (nonatomic, copy) NSString *professional;

// 吃
- (void)eat: (NSString *)food;

// 跑
- (void)run;

// 飞
- (void)fly;

// 睡
- (void)sleep;

// 消息转发用到方法
- (void)resendMsgMethod;

// 用于调换方法实现的方法1
- (void)test1;

// 用于调换方法实现的方法2
- (void)test2;

@end
