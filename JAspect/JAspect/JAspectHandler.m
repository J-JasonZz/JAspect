//
//  JAspectHandler.m
//  JAspect
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import "JAspectHandler.h"

@implementation JAspectHandler

- (void)handleAspect:(JAspectInfo *)info link:(JAspectLink *)link
{
    NSLog(@"name : %@, arguments : %@", info.name, link.arguments);
}

@end
