//
//  JAspectInfo.m
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import "JAspectInfo.h"
#import "JAspectLink.h"
#import "JAspect.h"
#import "JAspectManager.h"
#import "JAspectHandler.h"

@interface JAspectInfo ()

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) AspectOptions options;

@property (nonatomic, assign) SEL regexSEL;

@property (nonatomic, assign) NSDictionary *extensions;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) Class targetClass;

@property (nonatomic, strong) Class handlerClass;


@property (nonatomic, strong) id<AspectToken> aspectToken;

@end


@implementation JAspectInfo

+ (instancetype)aspect:(NSString *)desc
                  name:(NSString *)name
               options:(AspectOptions)options
              regexSEL:(SEL)regexSEL
            extensions:(NSDictionary *)extensions
                 index:(NSInteger)index
           targetClass:(Class)targetClass
          handlerClass:(Class)handlerClass
{
    return [[JAspectInfo alloc] initWithDesc:desc name:name options:options regexSEL:regexSEL extensions:extensions index:index targetClass:targetClass handlerClass:handlerClass];
}

- (instancetype)initWithDesc:(NSString *)desc
                     name:(NSString *)name
                     options:(AspectOptions)options
                    regexSEL:(SEL)regexSEL
                  extensions:(NSDictionary *)extensions
                       index:(NSInteger)index
                 targetClass:(Class)targetClass
                handlerClass:(Class)handlerClass
{
    self = [super init];
    if (self) {
        self.desc = desc;
        self.name = name;
        self.options = options;
        self.regexSEL = regexSEL;
        self.extensions = extensions;
        self.index = index;
        self.targetClass = targetClass;
        self.handlerClass = handlerClass;
    }
    return self;
}

- (void)runAspect
{
    __weak JAspectInfo *weakSelf = self;
    self.aspectToken = [self.targetClass aspect_hookSelector:self.regexSEL withOptions:self.options usingBlock:^(id<AspectInfo> info){
        
        id<JAspectHandler> handler = nil;
        
        if (weakSelf.handlerClass) {
            handler = [[JAspectManager shareManager] aspectHandlerInstance:weakSelf];
        } else {
            handler = [JAspect defaultHandler];
        }
        
        JAspectLink *link = [[JAspectLink alloc] init];
        link.arguments = info.arguments;
        [handler handleAspect:weakSelf link:link];
    } error:nil];
}

- (void)stopAspect
{
    [self.aspectToken remove];
}

@end
