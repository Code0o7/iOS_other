//
//  ViewController.m
//  RuntimeDemo
//
//  Created by sphere on 2017/9/7.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "ViewController.h"
#import "IvarController.h"
#import "ArchiveViewController.h"
#import "Person.h"
#import "Person+newProperty.h"
#import "CreateSubViewHandler.h"

#define BTNBASETAG 1000

@interface ViewController ()
@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

#pragma mark - 原始方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [[Person alloc]init];
    NSArray *btnTitles = @[@"用runtime调用方法",@"动态方法决议(防止找不到方法崩溃)",@"消息转发(防止找不到方法崩溃)",@"调换两个方法的实现",@"class_addMethod的使用",@"runtime获取对象的属性和方法",@"归档/解档",@"通过关联在分类中添加属性"];
    [CreateSubViewHandler createBtn:btnTitles fontSize:18 target:self sel:@selector(btnClick:) superView:self.view baseTag:BTNBASETAG];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.title = @"runtime用法汇总";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    self.title = @"";
}

#pragma mark - 按钮点击
// 按钮点击
- (void)btnClick: (UIButton *)sender
{
    NSInteger tag = sender.tag - BTNBASETAG;
    
    switch (tag) {
        case 0:
            // runtime调用方法
            [self executMethod];
            break;
        case 1:
            // 动态方法决议
            [self dynomicMethod];
            break;
        case 2:
            // 消息转发
            [self resendMsg];
            break;
        case 3:
            // 调换两个方法的实现
            [self exchangeMethod];
            break;
        case 4:
            // class_addMethod的使用
            [self addMethodTest];
            break;
        case 5:
            // 获取类的属性和方法
            [self ivarInfo];
            break;
        case 6:
            // 归档/解档
            [self archive];
            break;
        case 7:
            // 分类中添加属性
            [self addProperty];
            break;
        default:
            break;
    }
}

#pragma mark - 自定义
// runtime调用方法
- (void)executMethod
{
    // 执行没有参数的方法(要首先把buildsetting里面的checkingmsg设置为no)
    objc_msgSend(self.person, @selector(run)); // 相当于 [self.person run];
    
    // 执行带参数的方法
    objc_msgSend(self.person, @selector(eat:),@"苹果"); // 相当于 [self.person eat: @"苹果"];
}

// 动态方法决议
- (void)dynomicMethod
{
    [self.person fly];
}

// 消息转发
- (void)resendMsg
{
    [self.person resendMsgMethod];
}

// 调换两个方法的实现(方法欺骗method swizzing)
- (void)exchangeMethod
{
    // 调换两个方法的实现
    method_exchangeImplementations(class_getInstanceMethod([Person class], @selector(test1)), class_getInstanceMethod([Person class], @selector(test2)));
    
    // 调用方法1
    [self.person test1];
}

/**
 * class_addMethod的使用
 * cls  要添加方法的类
 * name 添加的方法名
 * imp  新增方法的实现
 * types 新增方法的参数情况,”v@:”意思就是这是一个void类型的方法，没有参数传入;“i@:”就是说这是一个int类型的方法，没有参数传入;”i@:@”就是说这是一个int类型的方法，有一个参数传入。
 */
- (void)addMethodTest
{
    // 给Person类添加一个newMethod方法，这个方法的实现和当前控制器里的addMethod方法的实现一样
    class_addMethod([Person class], @selector(newMethod), class_getMethodImplementation([self class], @selector(addMethod)), "v@:");
    
    // 调用Person里面的newMethod方法，必须用performSelector调用，否则会报错
    [self.person performSelector:@selector(newMethod)];
}

// 添加方法专用
- (void)addMethod
{
    NSLog(@"我是Person类新增的方法");
}

// 获取类的属性和方法
- (void)ivarInfo
{
    IvarController *ivarCtr = [[IvarController alloc]init];
    [self.navigationController pushViewController:ivarCtr animated:YES];
}

// 归档/解档
- (void)archive
{
    ArchiveViewController *archiveCtr = [[ArchiveViewController alloc]init];
    [self.navigationController pushViewController:archiveCtr animated:YES];
}

// 在分类中添加属性
- (void)addProperty
{
    self.person.hobby = @"篮球";
    NSLog(@"%@",self.person.hobby);
}

@end
