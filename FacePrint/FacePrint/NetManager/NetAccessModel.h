//
//  NetAccessModel.h
//  FaceSharp
//
//  Created by 阿凡树 on 2017/5/25.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetManager.h"

@interface NetAccessModel : NSObject

+ (instancetype)sharedInstance;

/**
 * APP 启动的时候先获取token
 */
- (void)getAccessTokenWithAK:(NSString *)ak SK:(NSString *)sk;

- (void)verifyFaceAndIDCard:(NSString *)name idNumber:(NSString *)idnumber imageStr:(NSString *)imageStr completion:(FinishBlockWithObject)completionBlock;

- (void)compareFaceImage1:(UIImage *)image1 image2:(UIImage *)image2 completion:(FinishBlockWithObject)completionBlock;

@end
