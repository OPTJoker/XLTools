//
//  XLNavigationController.m
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "XLNavigationController.h"
#import "Color.h"

@interface XLNavigationController ()

@end

@implementation XLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    return [super popViewControllerAnimated:animated];
}


#pragma mark -初始化UI
- (void)configUI{
    [self.navigationBar setTintColor:KWHITECOLOR];  // 前景色
    self.navigationBar.barTintColor = KTOPICCOLOR;
    self.navigationBar.shadowImage = [UIImage new];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:NO];         // 不半透明
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:KWHITECOLOR,
                                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica-bold" size:20.0f]
                                                 }];    // 标题属性
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
