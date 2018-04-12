//
//  JAspectInfo.h
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Aspects.h"

@interface JAspectInfo : NSObject

/**
 描述
 */
@property (nonatomic, copy, readonly) NSString *desc;

/**
 事件标识
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 aspect时机
 */
@property (nonatomic, assign, readonly) AspectOptions options;

/**
 被hook的方法
 */
@property (nonatomic, assign, readonly) SEL regexSEL;

/**
 注册时携带的参数
 */
@property (nonatomic, assign, readonly) NSDictionary *extensions;

/**
 匹配优先级
 */
@property (nonatomic, assign, readonly) NSInteger index;

/**
 被hook的类
 */
@property (nonatomic, strong, readonly) Class targetClass;

/**
 处理hook逻辑的类(若为nil，则使用默认处理模式，业务方需指定一个默认处理的类)
 */
@property (nonatomic, strong, readonly) Class handlerClass;


+ (instancetype)aspect:(NSString *)desc
               name:(NSString *)name
               options:(AspectOptions)options
              regexSEL:(SEL)regexSEL
            extensions:(NSDictionary *)extensions
                 index:(NSInteger)index
           targetClass:(Class)targetClass
          handlerClass:(Class)handlerClass;

/**
 开启绑定
 */
- (void)runAspect;

/**
 移除绑定
 */
- (void)stopAspect;

@end
