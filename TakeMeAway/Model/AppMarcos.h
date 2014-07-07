//
//  AppMarcos.h
//  TakeMeAway
//
//  Created by Jymn_Chen on 14-4-27.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#ifndef TakeMeAway_AppMarcos_h
#define TakeMeAway_AppMarcos_h

#define kAppInitialize @"kAppInitialize"

#if 1
#define LOCAL_TEST
#endif

#if 1
#define IMAGE_LOCAL_TEST
#endif

#if 0
#define SIDE_VIEW_LOCAL_TEST
#endif

//A better version of NSLog
#define JCNSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
        __LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

#endif
