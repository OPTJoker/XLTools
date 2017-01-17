//
//  TrangleView.h
//  iUnis
//
//  Created by 张雷 on 16/9/12.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 商检包装状态
 */
typedef NS_ENUM(NSUInteger, StatusType) {
    StatusReday =           0,  // 待生产
    StatusProducing =       1,  // 生产中
    StatusNeedInspect =     2,  // 待商检
    StatusInspecting =      3,  // 商检中
    StatusNeedPackge =      4,  // 带包装
    StatusPackging =        5,  // 包装中
    StatusPackged =         6,  // 包装完毕
    StatusOutGoing =        7,  // 出库中
    StatusTransporting =    8   // 运输中
};

@interface TrangleView : UIView
//@property (nonatomic, assign) StatusType type;
@property (nonatomic, retain) UIColor *typeColor;
@end
