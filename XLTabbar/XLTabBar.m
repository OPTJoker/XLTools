//
//  XLTabBar.m
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLTabBar.h"
//#import "LoginVC.h"
//#import "XLNavigationController.h"
//#import "RegistVC.h"

@implementation XLTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:KNOT_LOGOUT object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regist) name:KNOT_REGIST object:nil];
    }
    return self;
}
/*  **** 使用方法 ****
 NSArray *titles = @[@"首页", @"消息", @"我的"];
 NSArray *icons = @[@"shouye_1.png",@"xiaoxi_1.png",@"wode_1.png"];
 NSArray *sel_icons = @[@"shouye_2.png",@"xiaoxi_2.png",@"wode_2.png"];
 
 XLTabBar *xltab = [[XLTabBar alloc] initWithFrame:CGRectMake(0, 0, KSCRWIDTH, 49)];    //nonull
 xltab.controllers = tabbar.viewControllers;    //nonull
 xltab.normalColor = KBLACKCOLOR;   // 默认黑色好像
 xltab.selectedColor = KRGBCOLOR(0, 153, 0, 1); // 默认浅灰色
 xltab.delegate = tabbar;   // tabbar 假代理
 xltab.norTitleColor = KRGBCOLOR(164, 164, 164, 1); //默认白色
 xltab.selTitleColor = KTOPICCOLOR; //默认黑色
 xltab.titles = titles; //nonull
 xltab.icons = icons;
 xltab.selected_icons = sel_icons;
*/

#pragma mark -选中
- (void)btnClicked:(UIButton *)btn{
    if (btn.tag-20 == _selectedIndex) {
        return;
    }
    self.lastSelectedIndex = self.selectedIndex;
    self.selectedIndex = btn.tag - 20;
    
    btn.backgroundColor = _selectedColor;
    [btn setTitleColor:KTOPICCOLOR forState:UIControlStateNormal];
    
    if (_selected_icons.count > _selectedIndex) {
        UIImage *sel_icon = [UIImage imageNamed:_selected_icons[btn.tag-20]];
        [btn setImage:sel_icon forState:UIControlStateNormal];
    }
    
    UIButton *lastBtn = (UIButton *)[self viewWithTag:self.lastSelectedIndex+20];
    lastBtn.backgroundColor = self.normalColor;
    [lastBtn setTitleColor:_norTitleColor forState:UIControlStateNormal];
    
    if (_icons.count>_lastSelectedIndex) {
        UIImage *nor_icon = [UIImage imageNamed:_icons[_lastSelectedIndex]];
        [lastBtn setImage:nor_icon forState:UIControlStateNormal];
    }
    
    if (_delegate) {
        [_delegate setSelectedIndex:_selectedIndex];
    }
    if (_segmentDelegate) {
        [_segmentDelegate selectSegAtIndex:_selectedIndex];
    }
}

#pragma mark -重写set方法
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self setNeedsDisplay];
}

- (void)setNormalColor:(UIColor *)normalColor{
    if (normalColor) {
        _normalColor = normalColor;
    }else{
        _normalColor = KBLACKCOLOR;
    }
    
    [self setNeedsDisplay];
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    if (selectedColor) {
        _selectedColor = selectedColor;
    }else{
        // 主题绿
        _selectedColor = UIColorFromRGB(0xffcc00);
    }
    
    [self setNeedsDisplay];
}

- (void)setNorTitleColor:(UIColor *)norTitleColor{
    if (norTitleColor) {
        _norTitleColor = norTitleColor;
    }else{
        _norTitleColor = KRGBCOLOR(164, 164, 164, 1);
    }
    
    [self setNeedsDisplay];
}

- (void)setIcons:(NSArray *)icons{
    if (icons) {
        _icons = icons;
    }
    [self setNeedsDisplay];
}

- (void)setSelected_icons:(NSArray *)selected_icons{
    if (selected_icons) {
        _selected_icons = selected_icons;
    }
    [self setNeedsDisplay];
}

- (void)setSelTitleColor:(UIColor *)selTitleColor{
    if (selTitleColor) {
        _selTitleColor = selTitleColor;
    }else{
        _selTitleColor = KTOPICCOLOR;
    }
    
    [self setNeedsDisplay];
}


/*  setcontrollers 的 时候，
 *  初始化tabBarItems
 */
//#import "Control.h"
- (void)setControllers:(NSArray *)controllers{
    _controllers = controllers;
    self.selectedIndex = -1;
    self.lastSelectedIndex = -1;
    CGFloat w = KSCRWIDTH/(float)controllers.count;
    
    for (short i = 0; i<_controllers.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*w, 0, w, 49);
        btn.backgroundColor = _normalColor;
        btn.tag = i + 20;
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:_norTitleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(28, 0, 0, 0)];
        
        if (_icons.count>i) {
            UIImage *icon = [UIImage imageNamed:_icons[i]];
            [btn setImage:icon forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake((28-icon.size.height)/2., (btn.frame.size.width-icon.size.width)/2., (28-icon.size.height)/2., (btn.frame.size.width-icon.size.width)/2.)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(28, -icon.size.width, 0, 0)];
        }
        
        if (i == _selectedIndex) {
            btn.backgroundColor = self.selectedColor;
            [btn setTitleColor:_selectedColor forState:UIControlStateNormal];
            if (_selected_icons.count>i) {
                UIImage *sel_icon = [UIImage imageNamed:_selected_icons[i]];
                [btn setImage:sel_icon forState:UIControlStateNormal];
            }
        }
        [self addSubview:btn];
    }
}


/** 用来让set方法调用
 *  防止有一些属性赋值比controller晚，导致set controller 的时候有些tabBar元素get不到属性
 */
#pragma mark - draw Rect
- (void)drawRect:(CGRect)rect{
    UIButton *b = [self viewWithTag:20];
    if (b!=nil) {
        for (short i = 0; i<_controllers.count; i++) {
            UIButton *btn = [self viewWithTag:20+i];
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:_norTitleColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            
            if (_icons.count>i) {
                UIImage *icon = [UIImage imageNamed:_icons[i]];
                [btn setImage:icon forState:UIControlStateNormal];
                
                [btn setImageEdgeInsets:UIEdgeInsetsMake(2+(49-22-icon.size.height)/2., (btn.frame.size.width-icon.size.width)/2., (49-22-icon.size.height)/2., (btn.frame.size.width-icon.size.width)/2.)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(33, -icon.size.width, 5, 0)];
            }
            if (i == self.selectedIndex) {
                btn.backgroundColor = self.selectedColor;
                [btn setTitleColor:_selTitleColor forState:UIControlStateNormal];
                if (_selected_icons.count>i) {
                    UIImage *sel_icon = [UIImage imageNamed:_selected_icons[i]];
                    [btn setImage:sel_icon forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark  ***** 登录注册
//- (void)logout{
//    LoginVC *login = [[LoginVC alloc] init];
//    XLNavigationController *nav = [[XLNavigationController alloc] initWithRootViewController:login];
//    login.navigationItem.title = @"登录";
//    [_delegate presentViewController:nav animated:YES completion:^{
//        DLog(@"show Login VC");
//    }];
//}
//
//- (void)regist{
//    RegistVC *regist = [[RegistVC alloc] init];
//    XLNavigationController *nav = [[XLNavigationController alloc] initWithRootViewController:regist];
//    regist.navigationItem.title = @"注 册";
//    [_delegate presentViewController:nav animated:YES completion:^{
//        DLog(@"show regist VC");
//    }];
//}
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOT_LOGOUT object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOT_REGIST object:nil];
//}

- (void)selectIndex:(NSInteger)selectedIndex{
    NSInteger tag = selectedIndex+20;
    [self btnClicked:[self viewWithTag:tag]];
}

@end
