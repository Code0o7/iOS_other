//
//  Person.m
//  RuntimeDemo
//
//  Created by sphere on 2017/9/7.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "Person.h"
#import "Other.h"

/** oc 消息处理原理(引用自http://blog.csdn.net/kesalin/article/details/6689226)：
 * 1，首先去该类的方法 cache中查找，如果找到了就返回它；
 * 2，如果没有找到，就去该类的方法列表中查找。如果在该类的方法列表中找到了，则将 IMP返回，并将它加入cache中缓存起来。根据最近使用原则，这个方法再次调用的可能性很大，缓存起来可以节省下次调用再次查找的开销。
 * 3，如果在该类的方法列表中没找到对应的 IMP，在通过该类结构中的 super_class指针在其父类结构的方法列表中去查找，直到在某个父类的方法列表中找到对应的IMP，返回它，并加入cache中；
 * 4，如果在自身以及所有父类的方法列表中都没有找到对应的 IMP，则看是不是可以进行动态方法决议（后面有专文讲述这个话题）；
 * 5，如果动态方法决议没能解决问题，进入下面要讲的消息转发流程。
 */


/** 引用自http://blog.csdn.net/kesalin/article/details/8184914
 * 如果向一个Objective C对象发送它无法处理的消息(selector),那么编译器会按照如下次序进行处理：
 * 1，首先看是否为该 selector 提供了动态方法决议机制，如果提供了则转到2;如果没有提供则转到3;
 * 2，如果动态方法决议真正为该selector提供了实现，那么就调用该实现，完成消息发送流程，消息转发就不会进行了；如果没有提供，则转到3；
 * 3，其次看是否为该 selector 提供了消息转发机制，如果提供了消息了则进行消息转发，此时，无论消息转发是怎样实现的，程序均不会 crash。（因为消息调用的控制权完全交给消息转发机制处理，即使消息转发并没有做任何事情，运行也不会有错误，编译器更不会有错误提示。)；如果没提供消息转发机制，则转到 4；
 * 4，运行报错：无法识别的 selector，程序 crash；
 */

@interface Person ()<NSCoding>

@end


@implementation Person

#pragma mark - 原始function
#pragma mark -
#pragma mark - 方法动态决议
/**
 * 接收到无法处理的实例方法调用
 * 返回值是YES表示已经实现方法，查找方法实现列表
 * 返回值是NO表示没有实现方法，调用doesNotRecognizeSelector，程序崩溃
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(fly)) {
        class_addMethod([self class], sel, (IMP)newAddMethod, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

// 接收到无法处理的类方法时调用
+ (BOOL)resolveClassMethod:(SEL)sel
{
    NSLog(@"%s>>%@",__func__,NSStringFromSelector(sel));
    return [super resolveClassMethod:sel];
}

#pragma mark - 消息转发(方法按顺序执行)
// 备用接受者(如果转发以后的消息名字改变了，就不要重写这个方法了，会崩溃)
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(resendMsgMethod)) {
//        return [Other new];
//    }else {
//        return [super forwardingTargetForSelector:aSelector];
//    }
//}

/**
 * 指定方法签名
 * 如果返回nil，表示不处理,程序会因为找不到方法而崩溃
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(resendMsgMethod)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }else {
        return [super methodSignatureForSelector:aSelector];
    }
}

// 消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
//    SEL sel = anInvocation.selector;
    
    // 消息的转发接受对象
    Other *oth = [[Other alloc]init];
    if ([oth respondsToSelector:@selector(newMethod)]) {
        // 转发消息的实现为Other类中的newMethod的实现(注意这句代码写在前)
        [anInvocation setSelector:@selector(newMethod)];
        
        // 转发消息给oth对象
        [anInvocation invokeWithTarget:oth];
    }else {
        [super forwardInvocation: anInvocation];
    }
}


#pragma mark - 其他
// 消息没发实现,而且没有进行动态决议和消息转发会调用这个方法
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"无法处理%@方法",NSStringFromSelector(aSelector));
}

#pragma mark - 归档解档
// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // 获取所有的属性名列表
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        const char *k = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:k];
        id value = [self valueForKeyPath:key];
        [aCoder encodeObject:value forKey:key];
    }
    
    free(ivars);
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        // 获取所有的属性名列表
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            const char *k = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:k];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKeyPath:key];
        }
        
        free(ivars);
    }
    
    return self;
}


#pragma mark -
#pragma mark - 自定义
// 吃
- (void)eat:(NSString *)food
{
    NSLog(@"正在吃:%@",food);
}

// 跑
- (void)run
{
    NSLog(@"跑起来了");
}

// 动态方法决议新增方法
void newAddMethod()
{
    NSLog(@"动态方法决议成功");
}

- (void)test1
{
    NSLog(@"我是%s",__func__);
}

- (void)test2
{
    NSLog(@"我是%s",__func__);
}

@end
