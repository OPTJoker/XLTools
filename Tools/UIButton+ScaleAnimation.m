//
//  UIButton+ScaleAnimation.m
//  iFactory
//
//  Created by 张雷 on 16/11/23.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "UIButton+ScaleAnimation.h"
#include <objc/runtime.h>
#include <objc/message.h>



@implementation UIButton (ScaleAnimation)

static char *ShowScaleAnimationKey = "showScaleAnimation";
static char *userActionKey = "userAction";
static char *userTargetKey = "userTarget";
static char *btnLayerTransformKey = "btnLayerTransform";

// userAction
- (NSString *)userAction{
    return objc_getAssociatedObject(self, userActionKey);
}
- (void)setUserAction:(NSString *)userAction{
    objc_setAssociatedObject(self, userActionKey, userAction, OBJC_ASSOCIATION_COPY);
}
// userTarget
- (id)userTarget{
    return objc_getAssociatedObject(self, userTargetKey);
}
- (void)setUserTarget:(id)userTarget{
    objc_setAssociatedObject(self, userTargetKey, userTarget, OBJC_ASSOCIATION_ASSIGN);
}
// btnLayerTransform
- (CGAffineTransform)btnLayerTransform{
    NSString *transformStr = objc_getAssociatedObject(self, btnLayerTransformKey);
    return CGAffineTransformFromString(transformStr);
}
- (void)setBtnLayerTransform:(CGAffineTransform)btnLayerTransform{
    NSString *transformStr = NSStringFromCGAffineTransform(btnLayerTransform);
    objc_setAssociatedObject(self, btnLayerTransformKey, transformStr, OBJC_ASSOCIATION_COPY);
}

// 动画开关
- (BOOL)showScaleAnimation{
    // 把临时转成的Number对象解析成BOOL型
    NSNumber *res = objc_getAssociatedObject(self, ShowScaleAnimationKey);
    return [res boolValue];
}
- (void)setShowScaleAnimation:(BOOL)showScaleAnimation{
    // 不能添加C类型，只能放对象 所以转一下Number来存储
    objc_setAssociatedObject(self, ShowScaleAnimationKey, [NSNumber numberWithBool:showScaleAnimation], OBJC_ASSOCIATION_COPY);
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    
    if (self.showScaleAnimation) {
        self.userTarget = target;
        self.userAction = NSStringFromSelector(action);
        self.btnLayerTransform = self.layer.affineTransform;
        
        [super addTarget:self action:@selector(reSetClickedMethod:) forControlEvents:controlEvents];
        [super addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [super addTarget:self action:@selector(btnOutSide:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    }else{
        [super addTarget:target action:action forControlEvents:controlEvents];
    }
}

static float durT = 0.075;

- (void)reSetClickedMethod:(UIButton *)sender{
    [self btnTouchDown:sender];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durT*2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self btnRecover:sender complete:^(BOOL finished) {
            if ([self.userTarget respondsToSelector:NSSelectorFromString(self.userAction)]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self.userTarget performSelector:NSSelectorFromString(self.userAction) withObject:self];
                #pragma clang diagnostic pop
            }
        }];
    });
}

#pragma mark # btn魔法UI
- (void)btnTouchDown:(UIButton *)btn{
    
    [UIView animateWithDuration:durT*2 animations:^{
        btn.layer.affineTransform = CGAffineTransformScale(self.btnLayerTransform, 0.9, 0.9);
    } completion:^(BOOL finished) { }];
}

- (void)btnOutSide:(UIButton *)btn{
    [self btnRecover:btn complete:^(BOOL finished) { }];
}

- (void)btnRecover:(UIButton *)btn complete:(void (^ __nullable)(BOOL finished))complete{
    [UIView animateWithDuration:durT*5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        btn.layer.affineTransform = self.btnLayerTransform;
    } completion:complete];
}

@end
