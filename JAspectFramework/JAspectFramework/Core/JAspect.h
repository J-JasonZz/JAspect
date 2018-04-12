//
//  JAspect.h
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JAspectInfo;
@protocol JAspectHandler;

@interface JAspect : NSObject

@property (nonatomic, strong, class) id<JAspectHandler> defaultHandler;

/**
 初始化aspect

 @return aspect实例
 */
+ (instancetype)shareAspect;

/**
 开始注册aspect_list.plist表下所有映射关系，同时注册JAspect类中所有registerAspect_开头的方法，业务方可编写不同模块的JAspect_Category进行注册
 */
- (void)start;

/**
 是否开启调试模式，打印方法调用，参数信息等

 @param debug 是否调试
 */
- (void)enableDebug:(BOOL)debug;

/**
 注册aspect_list下所有映射

 @param aspectMap 映射表
 */
- (void)registerAspects:(NSDictionary *)aspectMap;

/**
 注册单个映射

 @param info 映射信息
 */
- (void)registerAspect:(JAspectInfo *)info;

/**
 取消注册某个映射

 @param name 事件名
 @param target 绑定的类
 */
- (void)unRegisterAspect:(NSString *)name target:(Class)target;

/**
 查找某个已注册的映射

 @param name 事件名
 @param target 绑定的类
 @return 映射信息
 */
- (JAspectInfo *)aspectInfoWithName:(NSString *)name target:(Class)target;

@end
