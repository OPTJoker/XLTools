//
//  XLTabBar.h
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NotificationNames.h"

@protocol SegMentCtrlDelegate <NSObject>
- (void)selectSegAtIndex:(NSInteger)index;
@end

@interface XLTabBar : UIView

@property (nonatomic,copy) NSArray *controllers;
@property (nonatomic,copy) NSArray *titles;
@property (nonatomic,copy) NSArray *icons;  //按钮图标
@property (nonatomic,copy) NSArray *selected_icons; //选中图标

@property (nonatomic,copy) UIColor *normalColor;
@property (nonatomic,copy) UIColor *selectedColor;

@property (nonatomic,copy) UIColor *norTitleColor;
@property (nonatomic,copy) UIColor *selTitleColor;

// 选中的index
@property (nonatomic,assign) NSInteger selectedIndex;

// 主动一点！选择某个index
- (void)selectIndex:(NSInteger)selectedIndex;

@property (nonatomic,assign) NSInteger lastSelectedIndex;

@property (nonatomic,assign) UITabBarController *delegate;

@property (nonatomic,assign) id<SegMentCtrlDelegate>segmentDelegate;

@end

#define KRGBCOLOR(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#define KSCRWIDTH [UIScreen mainScreen].bounds.size.width
#define KSCRHEIGHT [UIScreen mainScreen].bounds.size.height
