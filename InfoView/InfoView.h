//
//  InfoView.h
//  iUnis
//
//  Created by 张雷 on 16/10/14.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIScrollView
@property(nonatomic, assign) CGAffineTransform scaleTransform;
@property(nonatomic, strong) UIButton *closeDelegate;

+ (instancetype)ShareInfoView;
- (void)show;
- (void)hidden;

@property (nonatomic, copy) NSArray *infoArr;

@end
