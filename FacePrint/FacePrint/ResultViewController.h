//
//  ResultViewController.h
//  FacePrint
//
//  Created by 阿凡树 on 2017/7/13.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FaceResultType) {
    FaceResultTypeFail = 0,
    FaceResultTypeSuccess = 1
};

@interface ResultViewController : UIViewController
@property (nonatomic, readwrite, assign) FaceResultType resultType;
@property (nonatomic, readwrite, retain) NSString *tip;
@property (nonatomic, readwrite, retain) NSString *score;
@property (nonatomic, readwrite, retain) NSString *showStr;
@end
