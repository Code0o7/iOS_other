//
//  HYTableView.m
//  sphere_sj
//
//  Created by sphere on 16/9/23.
//  Copyright © 2016年 sphere. All rights reserved.
//

#import "HYTableView.h"

@interface HYTableView ()

@end

@implementation HYTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // 去掉多余的线条
        self.tableFooterView = [[UIView alloc]init];
        
        // 添加头部，设置头部高度才有效
        self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.000001)];
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    id view = [super hitTest:point withEvent:event];
    
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UITextField class]]) {
        return view;
    }else{
        [self endEditing:YES];
        return self;
    }
}

@end
