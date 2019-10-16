//
//  ResultViewController.m
//  FacePrint
//
//  Created by 阿凡树 on 2017/7/13.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()
@property (strong, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tipLabel.text = self.tip;
    self.scoreLabel.text = self.score;
    if (self.resultType == FaceResultTypeFail) {
        self.showLabel.text = @"核真不通过";
        self.showLabel.highlighted = YES;
    } else {
        self.showLabel.text = @"核真通过";
        self.showLabel.highlighted = NO;
    }
    if (self.showStr != nil) {
        self.showLabel.text = self.showStr;
        self.tipLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)returnback:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
