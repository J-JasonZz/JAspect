//
//  JAspectManager.m
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import "JAspectManager.h"
#import "JAspectInfo.h"
#import "JAspectHandler.h"

@interface JAspectManager ()

@property (nonatomic, strong) NSMutableArray *handlers;

@end

@implementation JAspectManager

+ (instancetype)shareManager
{
    static JAspectManager *stManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stManager = [[JAspectManager alloc] init];
    });
    return stManager;
}

- (id<JAspectHandler>)aspectHandlerInstance:(JAspectInfo *)info
{
    __block id<JAspectHandler> handlerInstance = nil;
    [self.handlers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:info.handlerClass]) {
            handlerInstance = (id<JAspectHandler>)obj;
            *stop = YES;
        }
    }];
    
    if (handlerInstance == nil) {
        handlerInstance = [[info.handlerClass alloc] init];
        if (handlerInstance) {
            [self.handlers addObject:handlerInstance];
        }
    }
    
    return handlerInstance;
}

#pragma mark -- getter
- (NSMutableArray *)handlers
{
    if (_handlers == nil) {
        _handlers = [NSMutableArray array];
    }
    return _handlers;
}

@end
