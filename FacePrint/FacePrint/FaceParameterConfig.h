//
//  FaceParameterConfig.h
//  FacePrint
//
//  Created by 阿凡树 on 2017/9/20.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#ifndef FaceParameterConfig_h
#define FaceParameterConfig_h

// 如果在后台选择自动配置授权信息，下面的三个LICENSE相关的参数已经配置好了
// 只需配置FACE_API_KEY和FACE_SECRET_KEY两个参数即可

// 人脸license文件名
#define FACE_LICENSE_NAME    @"idl-license"

// 人脸license后缀
#define FACE_LICENSE_SUFFIX  @"face-ios"

// （您申请的应用名称(appname)+「-face-ios」后缀，如申请的应用名称(appname)为test123，则此处填写test123-face-ios）
// 在后台 -> 产品服务 -> 人脸识别 -> 客户端SDK管理查看，如果没有的话就新建一个
#define FACE_LICENSE_ID        @"sphere-face-ios"

// OCR license文件名
#define OCR_LICENSE_NAME @"OCR LICENSE的名字"

// OCR license后缀
#define OCR_LICENSE_SUFFIX @"OCR LICENSE的后缀"

// 以下两个在后台 -> 产品服务 -> 人脸识别 -> 应用列表下面查看，如果没有的话就新建一个
// 您的API Key
#define FACE_API_KEY @"请求API接口使用的API Key，在后台获取"

// 您的Secret Key
#define FACE_SECRET_KEY @"请求API接口使用的Secret Key，在后台获取"

#endif /* FaceParameterConfig_h */
