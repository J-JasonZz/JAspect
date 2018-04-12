//
//  JAspectManager.h
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JAspectHandler;
@class JAspectInfo;

@interface JAspectManager : NSObject

+ (instancetype)shareManager;

- (id<JAspectHandler>)aspectHandlerInstance:(JAspectInfo *)info;

@end
