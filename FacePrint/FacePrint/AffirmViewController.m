//
//  AffirmViewController.m
//  FacePrint
//
//  Created by 阿凡树 on 2017/7/13.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "AffirmViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import <IDLFaceSDK/IDLFaceSDK.h>
#import "NetAccessModel.h"
#import "LivenessViewController.h"
#import "ResultViewController.h"

@interface AffirmViewController ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *identityCardTextField;
@property (strong, nonatomic) IBOutlet UIButton *commitButton;
@property (strong, nonatomic) IBOutlet UIButton *ocrButton;
@end

@implementation AffirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ResultViewController* rvc = [segue destinationViewController];
    NSDictionary* dict = (NSDictionary *)sender;
    rvc.resultType = [dict[@"type"] integerValue];
    rvc.tip = dict[@"tip"];
    rvc.score = dict[@"score"];
    if (dict[@"showStr"] != nil) {
        rvc.showStr = dict[@"showStr"];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameTextField resignFirstResponder];
    [self.identityCardTextField resignFirstResponder];
}

- (void)identifyUserLiveness {
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    [lvc livenesswithList:@[@(FaceLivenessActionTypeLiveEye)] order:YES numberOfLiveness:1];
    __weak typeof(self) weakSelf = self;
    lvc.completion = ^(NSDictionary* images, UIImage* originImage){
        if (images[@"bestImage"] != nil && [images[@"bestImage"] count] != 0) {
            NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage* bestImage = [UIImage imageWithData:data];
            NSLog(@"bestImage = %@",bestImage);
            //[LoadingView showStatusMessage:@"活体认证中..."];
            NSString* imageStr = [[images[@"bestImage"] lastObject] copy];
            if (imageStr == nil) {
                NSData* data = UIImageJPEGRepresentation(originImage, 0.6);
                if (data == nil) {
                    data = UIImagePNGRepresentation(originImage);
                }
                imageStr = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            }
            [[NetAccessModel sharedInstance] verifyFaceAndIDCard:self.nameTextField.text idNumber:self.identityCardTextField.text imageStr:imageStr completion:^(NSError *error, id resultObject) {
                if (error == nil) {
                    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"dict = %@",dict);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        FaceResultType type = FaceResultTypeFail;
                        NSString* tip = @"验证分数";
                        NSString* scoreStr = @"";
                        NSString* showStr = nil;
                        if ([dict[@"error_code"] intValue] == 0) {
                            CGFloat score = [dict[@"result"][@"score"] floatValue];
                            scoreStr = [NSString stringWithFormat:@"%.4f",score];
                            if (score > 80) {
                                type = FaceResultTypeSuccess;
                            }
                        } else {
                            tip = [NSString stringWithFormat:@"错误码：%@\n错误信息：%@",dict[@"error_code"],dict[@"error_msg"]];
                        }
                        NSMutableDictionary* resultDict = [@{} mutableCopy];
                        resultDict[@"type"] = @(type);
                        resultDict[@"tip"] = tip;
                        resultDict[@"score"] = scoreStr;
                        resultDict[@"showStr"] = showStr;
                        [weakSelf performSegueWithIdentifier:@"Affirm2Result" sender:resultDict];
                    });
                } else {
                    NSLog(@"网络请求失败");
                }
            }];
        }
    };
    [self presentViewController:lvc animated:YES completion:nil];
}

#pragma mark - Notification Action

- (void)textDidChange:(NSNotification *)note {
    if (self.nameTextField.text.length > 0 && self.identityCardTextField.text.length > 0) {
        self.commitButton.enabled = YES;
    } else {
        self.commitButton.enabled = NO;
    }
    if (note != nil) {
        UITextField *textField = [note object];
        if (self.nameTextField == textField) {
            if (textField.markedTextRange != nil) {
                return;
            }
            if (textField.text.length > 10) {
                textField.text = [textField.text substringToIndex:10];
                NSLog(@"姓名最多10个字");
                //[Toast showToast:@"姓名最多10个字"];
            }
        } else if (self.identityCardTextField == textField) {
            if (textField.markedTextRange != nil) {
                return;
            }
            if (textField.text.length > 18) {
                textField.text = [textField.text substringToIndex:18];
                NSLog(@"身份证最多18个字");
                //[Toast showToast:@"身份证最多18个字"];
            }
        }
    }
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Button Action
- (IBAction)useOcr:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIViewController * vc = [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont andImageHandler:^(UIImage *image) {
        [weakSelf dismissViewController];
        [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:^(id result) {
            NSLog(@"OCR Result = %@", result);
            if(result[@"words_result"] != nil){
                if (result[@"words_result"][@"公民身份号码"] != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.identityCardTextField.text = result[@"words_result"][@"公民身份号码"][@"words"] ?: @"";
                    });
                }
                if (result[@"words_result"][@"姓名"] != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.nameTextField.text = result[@"words_result"][@"姓名"][@"words"] ?: @"";
                    });
                }
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSMutableString *message = [NSMutableString string];
                NSDictionary *dic = result[@"words_result"];
                if(dic&&dic.count >0){
                    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }];
                }
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"身份证信息" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf identifyUserLiveness];
                }];
                [alert addAction:action];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }];
        } failHandler:^(NSError *err) {
            NSLog(@"%@", err);
        }];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)commit:(id)sender {
    NSRegularExpression* nameReg = [NSRegularExpression regularExpressionWithPattern:@"^[\\w\\u4e00-\\u9fa5]{1,10}$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    NSRegularExpression* idcardReg = [NSRegularExpression regularExpressionWithPattern:@"^\\d{17}[\\dXx]{1}$" options:NSRegularExpressionAnchorsMatchLines error:nil];
    
    NSString* name = self.nameTextField.text;
    NSInteger num = [nameReg numberOfMatchesInString:name options:NSMatchingWithTransparentBounds range:NSMakeRange(0, name.length)];
    if (num != 1) {
        //[Toast showToast:@"姓名不允许有特殊字符"];
        NSLog(@"姓名不允许有特殊字符");
        return;
    }
    
    NSString* IDCard = self.identityCardTextField.text;
    if ([idcardReg numberOfMatchesInString:IDCard options:NSMatchingWithTransparentBounds range:NSMakeRange(0, IDCard.length)] != 1) {
        //[Toast showToast:@"身份证信息输入有误，请重新输入"];
        NSLog(@"身份证信息输入有误，请重新输入");
        return;
    }
    
    [self identifyUserLiveness];
}

@end
