//
//  InfoView.m
//  iUnis
//
//  Created by 张雷 on 16/10/14.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "InfoView.h"
#import "AppDelegate.h"
#import "Control.h"
#import "Color.h"
#import <Masonry.h>
#import <SVProgressHUD.h>

@interface InfoView()
{
    UILabel *title;
    UIView *bgView;
}

@end
const float infoW = 290;
const float infoH = 340;
@implementation InfoView

static InfoView *infoView = nil;
+ (instancetype)ShareInfoView{
    @synchronized(self){
        if (nil == infoView) {
            infoView = [[super allocWithZone:nil] init]; // 避免死循环
            infoView.backgroundColor = KBGGRAYCOLOR;
            infoView.userInteractionEnabled = YES;
            
            infoView->bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            infoView->bgView.backgroundColor = [KBLACKCOLOR colorWithAlphaComponent:0.7];
            [infoView->bgView addSubview:infoView];
            
            AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appd.window addSubview:infoView->bgView];
            
            infoView.layer.cornerRadius = 6;
            infoView.frame = CGRectMake((KSCRWIDTH-infoW)/2., (KSCRHEIGHT-infoH)/2., infoW*(KSCRWIDTH/375.), infoH*KSCRHEIGHT/667.);
            infoView.scaleTransform = infoView.layer.affineTransform;
            
            
            float btnS = 36.;
            UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
            [close setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            [close addTarget:infoView action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
            [infoView addSubview:close];
            close.frame = CGRectMake(infoW-btnS, 0, btnS, btnS);
            
            infoView->title = [UILabel new];
            infoView->title.translatesAutoresizingMaskIntoConstraints = NO;
            infoView->title.textColor = KLIGHTGRAYCOLOR;
            infoView->title.text = @"技术参数";
            infoView->title.font = [UIFont boldSystemFontOfSize:13];
            [infoView addSubview:infoView->title];
            
            [infoView->title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(infoView.mas_left).mas_offset(20);
                make.top.equalTo(infoView.mas_top).mas_offset(12);
            }];
            
            
            {   // 初始化缩小并隐藏
                infoView.layer.affineTransform = CGAffineTransformScale(infoView.layer.affineTransform, 0.8, 0.8);
                infoView->bgView.hidden = YES;
            }
        }
    }
    return infoView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [InfoView ShareInfoView];
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

- (void)show{
    infoView->bgView.hidden = NO;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        infoView.layer.affineTransform = infoView.scaleTransform;
        //DLog(@"pos:%@\nanP:%@",NSStringFromCGPoint(infoView.layer.position),NSStringFromCGPoint(infoView.layer.anchorPoint));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidden{
    infoView.layer.affineTransform = CGAffineTransformScale(infoView.layer.affineTransform, 0.8, 0.8);
    infoView->bgView.hidden = YES;
    if (_closeDelegate) {
        _closeDelegate.hidden = YES;
    }
}


#pragma mark -根据数据 重载UI
- (void)setInfoArr:(NSArray *)infoArr{
    if (_infoArr == infoArr) {
        return;
    }
    CGSize size = [@"para" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    DLog(@"?????sizeH:%f",size.height);
    infoView.contentSize = CGSizeMake(infoW*(KSCRWIDTH/375.), 20+14+12+(size.height+5)*infoArr.count+16);
    
    if (![infoArr isKindOfClass:[NSArray class]]||infoArr.count<=0) {
        infoArr = @[@{@"parameter":@"没有参数",@"value":@"没有数据"}];
    }
    _infoArr = infoArr;
    for (UIView *subV in infoView.subviews) {
        if ([subV isKindOfClass:[UILabel class]]) {
            if (subV == infoView->title) {
                continue;
            }
            [subV removeFromSuperview];
        }
    }
    if (infoArr!=nil) {
        // titles
        UILabel *MAXparaLab = nil;
        UILabel *lastVLab = infoView->title;
        
        NSMutableArray *valLabArr = [NSMutableArray new];
        
        for (NSDictionary *dic in infoArr) {
            UILabel *paraLab = [UILabel new];
            paraLab.translatesAutoresizingMaskIntoConstraints = NO;
            paraLab.font = [UIFont systemFontOfSize:10];
            paraLab.numberOfLines = 1;
            paraLab.textColor = KTOPICCOLOR;
            paraLab.text = dic[@"parameter"];
            [infoView addSubview:paraLab];
            if (paraLab.text.length>=MAXparaLab.text.length || (MAXparaLab == nil)) {
                // 最宽的lab
                MAXparaLab = paraLab;
            }
            
            [paraLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastVLab.mas_bottom).mas_offset(5);
                make.left.equalTo(infoView->title);
            }];
            
            UILabel *valLab = [UILabel new];
            valLab.translatesAutoresizingMaskIntoConstraints = NO;
            valLab.font = [UIFont systemFontOfSize:11];
            valLab.textColor = KTOPICCOLOR;
            valLab.text = dic[@"value"];
            valLab.numberOfLines = 0;
            [infoView addSubview:valLab];
            [valLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(paraLab);
                make.left.equalTo(MAXparaLab.mas_right).offset(8);
                //make.right.equalTo(infoView.mas_rightMargin);
            }];
            [valLabArr addObject:valLab];
            lastVLab = valLab;
        }
        
        // values
        for (UILabel *lab in valLabArr){
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(MAXparaLab.mas_right).mas_offset(8);
            }];
        }
        
        // 之前动态计算高度的
//        [infoView mas_updateConstraints:^(MASConstraintMaker *make) {
//            UILabel *lab = [valLabArr lastObject];
//            make.bottom.equalTo(lab.mas_bottom).mas_offset(8);
//            make.center.equalTo(infoView->bgView);
//        }];
        
    }else{
        [SVProgressHUD showImage:nil status:@"没有参数"];
        [self hidden];
    }
}

@end
