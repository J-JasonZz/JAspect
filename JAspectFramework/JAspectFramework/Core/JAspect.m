//
//  JAspect.m
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import "JAspect.h"
#import "JAspectInfo.h"
#import "JAspectMarco.h"
#import "JAspectHandler.h"
#import <objc/runtime.h>

static BOOL J_Aspect_EnableDebug = NO;
static id<JAspectHandler> stDefaultHandler = nil;

@interface JAspect ()

@property (nonatomic, strong) NSMutableDictionary *aspectMap;

@end


@implementation JAspect

+ (instancetype)shareAspect
{
    static JAspect *stAspect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stAspect = [[JAspect alloc] init];
    });
    return stAspect;
}

- (void)start
{
    NSDictionary *aspectMap = [NSDictionary dictionaryWithContentsOfFile:[[self class] aspectMapFilePath]];
    [self registerAspects:aspectMap];
    
    unsigned int methodCount;
    Method *methods = class_copyMethodList([self class], &methodCount);
    for (NSInteger index = 0; index < methodCount; index++) {
        Method method = methods[index];
        SEL sel = method_getName(method);
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName hasPrefix:@"registerAspect_"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:nil];
#pragma clang diagnostic pop
        }
    }
    free(methods);
}

- (void)enableDebug:(BOOL)debug
{
    J_Aspect_EnableDebug = debug;
}

#pragma mark -- register
- (void)registerAspects:(NSDictionary *)aspectMap
{
    [aspectMap.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *target = (NSString *)obj;
        NSArray *aspects = aspectMap[target];
        [self registerAspectsForTarget:target aspects:aspects];
    }];
}

- (void)registerAspectsForTarget:(NSString *)target aspects:(NSArray *)aspects
{
    [aspects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *aspect = (NSDictionary *)obj;
        NSString *desc = aspect[@"desc"];
        NSString *name = aspect[@"name"];
        NSInteger options = aspect[@"options"] ? [aspect[@"options"] integerValue] : AspectPositionBefore;
        NSString *selectorString = aspect[@"sel"];
        NSDictionary *extensions = aspect[@"extensions"];
        NSInteger index = aspect[@"index"] ? [aspect[@"index"] integerValue] : 100;
        NSString *handlerClass = aspect[@"handlerClass"];

        JAspectInfo *info = [JAspectInfo aspect:desc
                                           name:name
                                        options:options
                                       regexSEL:NSSelectorFromString(selectorString)
                                     extensions:extensions
                                          index:index
                                    targetClass:NSClassFromString(target)
                                   handlerClass:NSClassFromString(handlerClass)];
        [self registerAspect:info];
    }];
}

- (void)registerAspect:(JAspectInfo *)info
{
    @synchronized (self) {
        
        if (info.targetClass == nil) {
            if (J_Aspect_EnableDebug) {
                J_Aspect_Log(@"Aspect Error: target class cannot be nil");
            }
            return;
        }
        
        NSString *target = NSStringFromClass(info.targetClass);
        
        if (![self.aspectMap.allKeys containsObject:target]) {
            [self.aspectMap setObject:[NSMutableArray array] forKey:target];
        }
        
        NSMutableArray *aspects = self.aspectMap[target];
        __block NSInteger index = -1;
        [aspects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JAspectInfo *tempInfo = (JAspectInfo *)obj;
            if (info.index > tempInfo.index) {
                index = idx;
                *stop = YES;
            }
        }];
        
        if (index != -1) {
            [aspects insertObject:info atIndex:index];
        } else {
            [aspects addObject:info];
        }
        [info runAspect];
        if (J_Aspect_EnableDebug) {
            J_Aspect_Log(@"Reigstering aspect: desc = %@, name = %@", info.desc, info.name);
        }
    }
}

- (void)unRegisterAspect:(NSString *)name target:(Class)target
{
    @synchronized (self) {
        
        if (target == nil) {
            return;
        }
        
        NSString *targetString = NSStringFromClass(target);
        NSMutableArray *aspects = self.aspectMap[targetString];
        
        JAspectInfo *info = [self aspectInfoWithName:name target:target];
        
        if (info) {
            [info stopAspect];
            [aspects removeObject:info];
        }
    }
}

- (JAspectInfo *)aspectInfoWithName:(NSString *)name target:(Class)target
{
    __block JAspectInfo *info = nil;
    
    if (target == nil) {
        return nil;
    }
    
    NSString *targetString = NSStringFromClass(target);
    NSMutableArray *aspects = self.aspectMap[targetString];
    [aspects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JAspectInfo *tempInfo = (JAspectInfo *)obj;
        if ([tempInfo.name isEqualToString:name]) {
            info = tempInfo;
            *stop = YES;
        }
    }];
    return info;
}

#pragma mark -- setter
+ (void)setDefaultHandler:(id<JAspectHandler>)defaultHandler
{
    stDefaultHandler = defaultHandler;
}

#pragma mark -- getter
+ (id<JAspectHandler>)defaultHandler
{
    return stDefaultHandler;
}

+ (NSString *)aspectMapFilePath
{
    return [[NSBundle mainBundle] pathForResource:@"aspect_list" ofType:@"plist"];
}

- (NSMutableDictionary *)aspectMap
{
    if (_aspectMap == nil) {
        _aspectMap = [NSMutableDictionary dictionary];
    }
    return _aspectMap;
}

@end
