//
//  BaseViewController.m
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/17.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 20);
    [backButton setTitle:@"< 返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [backButton addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backbarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backbarButton;
}

- (IBAction)returnBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
