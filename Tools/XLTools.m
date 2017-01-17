//
//  XLTools.m
//  iFactory
//
//  Created by 张雷 on 16/11/16.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLTools.h"
#import <RKNotificationHub.h>

@implementation XLTools

+ (void)setBadge:(int)badge View:(UIView *)aView circleColor:(UIColor *)circleColor labelColor:(UIColor *)labelColor frame:(CGRect)frame{
    RKNotificationHub *notHub = [XLTools getRKNotificationHub:aView];
    if (nil == notHub) {
        notHub = [[RKNotificationHub alloc] initWithView:aView];
    }
    if (circleColor && labelColor) {
        [notHub setCircleColor:circleColor labelColor:labelColor];
    }else if (circleColor){
        [notHub setCircleColor:circleColor labelColor:KWHITECOLOR];
    }else if (labelColor){
        [notHub setCircleColor:KRGBCOLOR(205, 81, 82, 1) labelColor:labelColor];
    }
    
    [notHub setCircleAtFrame:frame];
    [notHub increment];
    notHub.count = badge;
    [notHub bump];
    [aView bringSubviewToFront:notHub];
}
+ (RKNotificationHub *)getRKNotificationHub:(UIView *)supV{
    for (UIView *subV in supV.subviews) {
        if ([subV isKindOfClass:[RKNotificationHub class]]) {
            return (RKNotificationHub *)subV;
        }else{
            return nil;
        }
    }
    return nil;
}

+ (void)resetBtnFrame:(UIButton *)btn Withtitle:(NSString *)title{
    CGPoint center = btn.center;
    CGSize btnSize = btn.frame.size;
    NSString *content = title;
    UIFont *font = btn.titleLabel.font;
    CGSize size = CGSizeMake(MAXFLOAT, btnSize.height);
    CGSize buttonSize = [content boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName:font}
                                              context:nil].size;
    btn.frame = CGRectMake(0, 0, buttonSize.width+10, btnSize.height);
    btn.center = center;
}


/**
 根据日期 得到星期几

 @param inputDate 要求星期几的日期
 @return 星期几
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


/**
 传入 秒  得到 xx:xx:xx

 @param totalTime 传入的秒数
 @return xx:xx:xx
 */
+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}

/**
 计算字符串占用的size

 @param string 目标字符串
 @param font 字符字体
 @param width 指定宽度
 @param height 指定高度
 @return 占用size
 */
+ (CGSize)getSizeOfString:(NSString *)string withFont:(UIFont *)font limitWidth:(CGFloat)width limitHeight:(CGFloat)height{
    NSDictionary * dict = @{NSFontAttributeName : font};
    
    //计算label的文字宽高
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
