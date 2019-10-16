//
//  FaceCompareViewController.m
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/17.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "FaceCompareViewController.h"
#import "DetectionViewController.h"
#import "UIImage+Additions.h"
#import "NetAccessModel.h"

@interface FaceCompareViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *photoButton0;
@property (strong, nonatomic) IBOutlet UIButton *photoButton1;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView0;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView1;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic, readwrite, weak) UIImageView *selectImageView;
@end

@implementation FaceCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor] withSize:self.commitButton.bounds.size] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commit:(UIButton *)sender {
    if (self.photoImageView0.hidden || self.photoImageView1.hidden) {
        self.tipsLabel.text = @"请上传2张人脸照片";
        return;
    }
    
   self.tipsLabel.text = @"对比中...";
    [[NetAccessModel sharedInstance] compareFaceImage1:self.photoImageView0.image image2:self.photoImageView1.image completion:^(NSError *error, id resultObject) {
        if (error == nil) {
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
            if ([dict[@"error_code"] intValue] == 0) {
                self.tipsLabel.text = [NSString stringWithFormat:@"相似度分值：%0.2f",[dict[@"result"][@"score"] floatValue]];
            } else {
                self.tipsLabel.text = dict[@"error_msg"]?[NSString stringWithFormat:@"错误信息：%@",dict[@"error_msg"]]:@"网络请求错误";
            }
            NSLog(@"dict = %@",dict);
        } else {
            self.tipsLabel.text = @"网络请求失败";
        }
    }];
}
- (IBAction)selectAPhoto:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (sender.tag == 0) {
        self.selectImageView = self.photoImageView0;
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.videoQuality=UIImagePickerControllerQualityTypeLow;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        self.selectImageView = self.photoImageView1;
        DetectionViewController* dvc = [[DetectionViewController alloc] init];
        dvc.completion = ^(NSDictionary* images, UIImage* originImage){
            weakSelf.selectImageView.hidden = NO;
            weakSelf.selectImageView.image = originImage;
        };
        [weakSelf presentViewController:dvc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        self.selectImageView.hidden = NO;
        self.selectImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //取消选择的设置类型
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
