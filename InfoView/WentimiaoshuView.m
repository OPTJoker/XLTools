//
//  WentimiaoshuView.m
//  iFactory
//
//  Created by 张雷 on 16/12/23.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import "WentimiaoshuView.h"
#import "XLRequest.h"
#import "Control.h"
#import "ProblemCell.h"
#import "ProblemModel.h"
#import "NotificationNames.h"

@interface WentimiaoshuView()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    
}
@property (nonatomic, assign) CGAffineTransform scaleTransform;

@property (nonatomic,strong) UILabel *titleView;

@property (nonatomic,strong) UIView *cardView;
@property (nonatomic,strong) UIButton *closeBtn;

// 数据
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *wrongArr;

@property (nonatomic,copy) NSString *urlStr;

@end

@implementation WentimiaoshuView{
    CGFloat probleLabWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

static float cardW = 580/2.f;
static float cardH = 640/2.f;

#pragma mark # ##### 懒死你行了
- (NSMutableArray *)wrongArr{
    if (nil == _wrongArr) {
        _wrongArr = [NSMutableArray new];
    }
    return _wrongArr;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleView.text = _title;
}
- (UIView *)cardView{
    if (nil == _cardView) {
        _cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardW, cardH)];
        _cardView.backgroundColor = KWHITECOLOR;
        _cardView.layer.cornerRadius = 3;
        _cardView.layer.masksToBounds = YES;
        [wentimiaoshuView addSubview:_cardView];
        _cardView.center = wentimiaoshuView.center;
    }
    return _cardView;
}
- (UILabel *)titleView{
    if (nil == _titleView) {
        _titleView = [UILabel new];
        _titleView.frame = CGRectMake(0, 0, cardW, 50);
        [self.cardView addSubview:_titleView];
        _titleView.backgroundColor = UIColorFromRGB(0xc33c3c);
        _titleView.text = self.title;
        _titleView.textColor = KWHITECOLOR;
        _titleView.font = [UIFont boldSystemFontOfSize:17];
        _titleView.textAlignment = NSTextAlignmentCenter;
        self.closeBtn.hidden = NO;
    }
    return _titleView;
}

- (UIButton *)closeBtn{
    if (nil == _closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(cardW-50, 0, 50, 50);
        [_closeBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_closeBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.cardView addSubview:_closeBtn];
    }
    return _closeBtn;
}

- (UITableView *)tableView{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, cardW, cardH-50) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = wentimiaoshuView;
        _tableView.dataSource = wentimiaoshuView;
        [wentimiaoshuView.cardView addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark - tableview 代理 数据源
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.wrongArr.count) {
        ProblemModel *model = self.wrongArr[indexPath.row];
        CGSize size = [XLTools getSizeOfString:model.Detail withFont:[UIFont systemFontOfSize:16] limitWidth:wentimiaoshuView->probleLabWidth limitHeight:CGFLOAT_MAX];
        return size.height+32>45.f?size.height+32:45.f;
    }else{
        return 45.f;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wrongArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *problemCellIDE = @"problemCellIDE";
    ProblemCell *cell = [tableView dequeueReusableCellWithIdentifier:problemCellIDE];
    if (nil == cell) {
        cell = [[ProblemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:problemCellIDE];
    }
    ProblemModel *model = self.wrongArr[indexPath.row];
    cell.status = model.Status;
    cell.problem = model.Detail;
    cell.duration = model.duration;
    
    return cell;
}
#pragma mark # 显示 隐藏
- (void)show{
    
    wentimiaoshuView.hidden = NO;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:wentimiaoshuView];

    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        wentimiaoshuView.cardView.layer.affineTransform = wentimiaoshuView.scaleTransform;
    } completion:^(BOOL finished) {
        [self requestData];
    }];
    
}
- (void)hide{
    wentimiaoshuView.cardView.layer.affineTransform = CGAffineTransformScale(wentimiaoshuView.cardView.layer.affineTransform, 0.8, 0.8);
    wentimiaoshuView.hidden = YES;
    [wentimiaoshuView removeFromSuperview];
    [XLRequest cancleRequest:_urlStr];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOT_STOPPROBLEMTIMER object:nil];
}

#pragma mark #网络请求
- (void)fmtError:(id)data{
    [MBProgressHUD showError:@"数据出错啦" toView:wentimiaoshuView.cardView];
    DLog(@">>>data fmt error:%@",data);
}
- (void)requestData{
    [MBProgressHUD showMessage:@"Loading.." toView:wentimiaoshuView.cardView];
    _urlStr = [NSString stringWithFormat:@"%@%@%@",KSERVER,KURL_GETPROBLEMLOGBYPROID,_productID];
    [XLRequest GET:_urlStr para:nil success:^(id sucData) {
        NSDictionary *dic = [XLRequest analyze:sucData];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:wentimiaoshuView.cardView animated:NO];
                [wentimiaoshuView fmtError:dic];
            });
        }else{
            // 解析数据
            
            NSArray *data = [dic objectForKey:@"data"];
            DLog(@"data:%@",data);
            if (![data isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:wentimiaoshuView.cardView animated:NO];
                    [wentimiaoshuView fmtError:data];
                });
            }else{
                [self.wrongArr removeAllObjects];
                for (NSDictionary *dic in data) {
                    ProblemModel *model = [ProblemModel new];
                    [model setModelDic:dic];
                    [self.wrongArr addObject:model];
                }
                // reload data
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:wentimiaoshuView.cardView animated:YES];
                    [wentimiaoshuView.tableView reloadData];
                });
            }
            
        }
    } failure:^(NSError *errData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:wentimiaoshuView.cardView animated:NO];
            [XLRequest dataRequestFailure:errData inView:wentimiaoshuView];
        });
        DLog(@">>>>网络请求失败:%@",errData);
    }];
}


#pragma mark # 单利
static WentimiaoshuView *wentimiaoshuView = nil;
+ (instancetype)ShareWentimiaoshuView{
    @synchronized(self){
        if (nil == wentimiaoshuView) {
            wentimiaoshuView = [[super allocWithZone:nil] initWithFrame:[UIScreen mainScreen].bounds]; //
            wentimiaoshuView.backgroundColor = [KBLACKCOLOR colorWithAlphaComponent:0.7];
            // 初始化缩小并隐藏
            {
                wentimiaoshuView.scaleTransform = wentimiaoshuView.cardView.layer.affineTransform;
                wentimiaoshuView.cardView.layer.affineTransform = CGAffineTransformScale(wentimiaoshuView.cardView.layer.affineTransform, 0.8, 0.8);
                wentimiaoshuView.hidden = YES;
            }
            if (nil == wentimiaoshuView.title) {
                wentimiaoshuView.title = @"问题描述";
            }
            wentimiaoshuView->probleLabWidth = cardW-(16+18+10+66);
        }
    }
    return wentimiaoshuView;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [WentimiaoshuView ShareWentimiaoshuView];
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
- (void)drawRect:(CGRect)rect {
    // Drawing code
    /*
     
     */
}
@end
