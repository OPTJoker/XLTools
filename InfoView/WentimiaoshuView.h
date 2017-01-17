//
//  WentimiaoshuView.h
//  iFactory
//
//  Created by 张雷 on 16/12/23.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WentimiaoshuView : UIView
@property (nonatomic,copy) NSString *productID;
@property (nonatomic,copy) NSString *title;

- (void)show;

+ (instancetype)ShareWentimiaoshuView;
@end
