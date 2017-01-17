//
//  Control.h
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#ifndef Control_h
#define Control_h


#endif /* Control_h */

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#define DDLogWarn(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#else
#define DLog( s, ... )
#endif

#define KSCRWIDTH [UIScreen mainScreen].bounds.size.width
#define KSCRHEIGHT [UIScreen mainScreen].bounds.size.height
#define KSCALE_W (([UIScreen mainScreen].bounds.size.width)/375.)
#define KSCALE_H (([UIScreen mainScreen].bounds.size.height)/667.)

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


#define OC(str) [NSString stringWithCString:(str) encoding:NSUTF8StringEncoding]

// NSUserdefaults
#define KUSERINFOARRKEY @"userInfoDataArr"
#define ORGIDKEY @"orgID"
#define CHANNELKEY @"channel"

#define KISADMINKEY @"isAdmin"

#define KUSERNAMEKEY @"username"
// 密码
#define KPSWKEY @"password"

// 极光IM密码 安卓根iOS通用一套注册密码
#define KJMSGPSWKEY @"q1q1q1"
