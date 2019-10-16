//
//  IvarController.m
//  RuntimeDemo
//
//  Created by sphere on 2017/9/8.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "IvarController.h"
#import "Person.h"
#import "HYTableView.h"

@interface IvarController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) Person *p;

// 属性列表数据
@property (nonatomic, strong) NSMutableArray *dataList;

// 列表
@property (nonatomic, strong) HYTableView *tableView;

@end

@implementation IvarController

#pragma mark - 原始function
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"获取类的属性和方法";
    
    self.p = [[Person alloc]init];
    self.p.name = @"张三";
    self.p.age = 18;
    self.p.birthday = @"1990-12-12";
    self.p.identify = @"41232524";
    self.p.professional = @"iOS开发工程师";
    
    self.tableView = [[HYTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.dataList = [NSMutableArray array];
    
    // 获取属性名和值
    [self ivarList];
    
    // 获取方法列表
    [self methodList];
}

#pragma mark - 自定义
// 获取属性名和值
- (void)ivarList
{
    // 属性数目
    unsigned int count = 0;
    
    // 获取属性列表
//    Ivar *ivar = class_copyIvarList([self.p class], &count);
    objc_property_t *propety = class_copyPropertyList([self.p class], &count);
    
    // 遍历获取属性
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
//        Ivar iv = ivar[i];
//        const char *k = ivar_getName(iv);
//        NSString *key = [NSString stringWithUTF8String:k];
//        id value = [self.p valueForKeyPath:key];
//        [arrM addObject:[NSString stringWithFormat:@"%@:%@",key,value]];
        
        objc_property_t pro = propety[i];
        const char *k = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:k];
        id value = [self.p valueForKeyPath:key];
        [arrM addObject:[NSString stringWithFormat:@"%@:%@",key,value]];
    }
    
    free(propety);
    
    NSDictionary *dic = @{@"属性列表" : arrM};
    [self.dataList addObject:dic];
}

// 获取方法列表
- (void)methodList
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList([self.p class], &count);
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int j = 0; j < count; j++) {
        Method method = methods[j];
        SEL k = method_getName(method);
        NSString *key = NSStringFromSelector(k);
        [arr addObject:key];
    }
    
    free(methods);
    
    [self.dataList addObject:@{@"方法列表":arr}];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataList[section];
    return [dic[dic.allKeys.firstObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"identify%ld",(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identify];
    }
    NSDictionary *dic = self.dataList[indexPath.section];
    cell.textLabel.text = dic[dic.allKeys.firstObject][indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataList[section];
    return dic.allKeys.firstObject;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
