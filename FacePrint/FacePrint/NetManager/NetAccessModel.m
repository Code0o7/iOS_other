//
//  NetAccessModel.m
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/25.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "NetAccessModel.h"
#import "UIImage+Additions.h"
#import "NSString+Additions.h"

#define BASE_URL @"https://aip.baidubce.com"

#define ACCESS_TOEKN_URL [NSString stringWithFormat:@"%@/oauth/2.0/token",BASE_URL]

#define LIVENESS_VS_IDCARD_URL [NSString stringWithFormat:@"%@/rest/2.0/face/v3/person/verify",BASE_URL]
#define FACE_COMPARE [NSString stringWithFormat:@"%@/rest/2.0/face/v3/match",BASE_URL]

@interface NetAccessModel ()
@property (nonatomic, readwrite, retain) NSString *accessToken;
@property (nonatomic, readwrite, retain) NSString *groupID;
@end
@implementation NetAccessModel

+ (instancetype)sharedInstance {
    static NetAccessModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetAccessModel alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _groupID = [@"这里根据自己的业务选择合适的groupID" md5String];
    }
    return self;
}

- (void)getAccessTokenWithAK:(NSString *)ak SK:(NSString *)sk {
    __weak typeof(self) weakSelf = self;
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSLog(@"start = %f",start);
    [[NetManager sharedInstance] postDataWithPath:ACCESS_TOEKN_URL parameters:@{@"grant_type":@"client_credentials",@"client_id":ak,@"client_secret":sk} completion:^(NSError *error, id resultObject) {
        if (error == nil) {
            NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
            NSLog(@"end = %f",end);
            NSLog(@"Token = %f",end - start);
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:resultObject options:NSJSONReadingAllowFragments error:nil];
            weakSelf.accessToken = dict[@"access_token"];
            NSLog(@"%@",dict[@"access_token"]);
        }
    }];
}

- (void)verifyFaceAndIDCard:(NSString *)name idNumber:(NSString *)idnumber imageStr:(NSString *)imageStr completion:(FinishBlockWithObject)completionBlock {
    NSDictionary* parm = @{@"name":name ?: @"",
                           @"image":imageStr,
                           @"image_type": @"BASE64",
                           @"id_card_number":idnumber ?: @"",
                           @"quality_control":@"NORMAL",
                           @"liveness_control":@"NORMAL"};
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    NSLog(@"start = %f",start);
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",LIVENESS_VS_IDCARD_URL,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
        NSLog(@"end = %f",end);
        NSLog(@"公安 = %f",end - start);
        completionBlock(error,resultObject);
    }];
}

- (void)compareFaceImage1:(UIImage *)image1 image2:(UIImage *)image2 completion:(FinishBlockWithObject)completionBlock {
    NSArray* parm = @[@{@"image":[image1 base64EncodedString],
                             @"image_type": @"BASE64"},
                           @{@"image":[image2 base64EncodedString],
                             @"image_type": @"BASE64"}];
    [[NetManager sharedInstance] postDataWithPath:[NSString stringWithFormat:@"%@?access_token=%@",FACE_COMPARE,self.accessToken] parameters:parm completion:^(NSError *error, id resultObject) {
        completionBlock(error,resultObject);
    }];
}

@end
