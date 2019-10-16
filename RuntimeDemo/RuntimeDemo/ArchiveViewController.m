//
//  ArchiveViewController.m
//  RuntimeDemo
//
//  Created by sphere on 2017/9/12.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "ArchiveViewController.h"
#import "Person.h"

@interface ArchiveViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) Person *p;

@property (nonatomic, strong) Person *archiveP;

@property (nonatomic, copy) NSArray *propertyList;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ArchiveViewController

#pragma mark - 原始function
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"归档/解档";
    
    self.p = [[Person alloc]init];
    self.p.name = @"李四";
    self.p.age = 22;
    self.p.identify = @"11111111";
    self.p.birthday = @"2000-08-08";
    
    // 创建子控件
    [self createSubviews];
}

#pragma mark - 自定义
// 创建子控件
- (void)createSubviews
{
    // 创建归档/解档按钮
    NSArray *titles = @[@"归档",@"解档"];
    CGFloat btnX = 20;
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width - btnX * 2;
    CGFloat btnH = 40;
    for (int i = 0; i < titles.count; i++) {
        CGFloat btnY = 64 + 20 + (btnH + 20) * i;
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:0/255.0 green:150/255.0 blue:255/255.0 alpha:1];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addTarget:self action:@selector(archive:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    // 创建列表
    CGFloat tableY = 64 + 10 + (20 + btnH) * 2;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableY, self.view.bounds.size.width, self.view.bounds.size.height - tableY) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

// 归档路径
- (NSString *)archivePath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fulPath = [path stringByAppendingPathComponent:@"person"];
    return fulPath;
}

#pragma mark - 点击事件
// 归档
- (void)archive: (UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"归档"]) {
        // 归档
        [NSKeyedArchiver archiveRootObject:self.p toFile:[self archivePath]];
    }else {
        // 解档
        self.archiveP = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
        
        // 获取属性列表
        NSMutableArray *arrM = [NSMutableArray array];
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self.archiveP class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            const char *k = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:k];
            id value = [self.archiveP valueForKeyPath:key];
            [arrM addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
        free(ivars);
        
        self.propertyList = arrM;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.propertyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"identify";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.textLabel.text = self.propertyList[indexPath.row];
    return cell;
}


@end
