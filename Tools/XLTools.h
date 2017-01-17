//
//  XLTools.h
//  iFactory
//
//  Created by 张雷 on 16/11/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTools : NSObject

/**
 给View设置角标

 @param badge 数字
 @param aView 父视图
 @param circleColor 圆圈颜色
 @param labelColor 字体颜色
 @param frame 角标位置
 */
+ (void)setBadge:(int)badge View:(UIView *)aView circleColor:(UIColor *)circleColor labelColor:(UIColor *)labelColor frame:(CGRect)frame;

+ (void)resetBtnFrame:(UIButton *)btn Withtitle:(NSString *)title;

/**
 获取周几
 @param inputDate NSDate类型的日期
 @return 星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;


/**
 传入 秒  得到 xx:xx:xx
 
 @param totalTime 传入的秒数
 @return xx:xx:xx
 */
+(NSString *)getMMSSFromSS:(NSString *)totalTime;


/**
 计算字符串占用的size
 
 @param string 目标字符串
 @param font 字符字体
 @param width 指定宽度
 @param height 指定高度
 @return 占用size
 */
+ (CGSize)getSizeOfString:(NSString *)string withFont:(UIFont *)font limitWidth:(CGFloat)width limitHeight:(CGFloat)height;
@end
