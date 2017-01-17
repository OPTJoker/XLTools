//
//  UIButton+ScaleAnimation.h
//  iFactory
//
//  Created by 张雷 on 16/11/23.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ScaleAnimation)

@property (nonatomic, assign) id userTarget;
@property (nonatomic, copy) NSString *userAction;
@property(nonatomic, assign) CGAffineTransform btnLayerTransform;

@property (nonatomic, assign) BOOL showScaleAnimation;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
