//
//  JAspectHandler.h
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JAspectInfo;
@class JAspectLink;

@protocol JAspectHandler <NSObject>

/**
 处理hook回调事件的协议

 @param info 映射信息
 @param link 回调信息
 */
- (void)handleAspect:(JAspectInfo *)info link:(JAspectLink *)link;

@end
