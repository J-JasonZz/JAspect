//
//  JAspectMarco.h
//  JAspectFramework
//
//  Created by JasonZhang on 2018/4/12.
//  Copyright © 2018年 JasonZhang. All rights reserved.
//

#ifndef JAspectMarco_h
#define JAspectMarco_h

#ifdef DEBUG
#define J_Aspect_Log(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#define J_Aspect_Log(...);
#endif


#endif /* JAspectMarco_h */
