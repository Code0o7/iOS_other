//
//  Person+newProperty.h
//  RuntimeDemo
//
//  Created by sphere on 2017/9/12.
//  Copyright © 2017年 sphere. All rights reserved.
//

#import "Person.h"

@interface Person (newProperty)
// 爱好(新增属性)
@property (nonatomic, strong) NSString *hobby;
@end
