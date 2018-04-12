//
//  JAspectFramework.h
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for JAspectFramework.
FOUNDATION_EXPORT double JAspectFrameworkVersionNumber;

//! Project version string for JAspectFramework.
FOUNDATION_EXPORT const unsigned char JAspectFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JAspectFramework/PublicHeader.h>


#if __has_include(<JAspectFramework/JAspectFramework.h>)

#import <JAspectFramework/Aspects.h>
#import <JAspectFramework/JAspect.h>
#import <JAspectFramework/JAspectInfo.h>
#import <JAspectFramework/JAspectLink.h>
#import <JAspectFramework/JAspectHandler.h>
#import <JAspectFramework/JAspectManager.h>
#import <JAspectFramework/JAspectMarco.h>

#else

#import "Aspects.h"
#import "JAspect.h"
#import "JAspectInfo.h"
#import "JAspectLink.h"
#import "JAspectHandler.h"
#import "JAspectManager.h"
#import "JAspectMarco.h"

#endif /* __has_include */
