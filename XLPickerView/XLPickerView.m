//
//  SegmentView.m
//  iUnis
//
//  Created by 张雷 on 16/9/27.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//
#define KTEXTCOLOR  KRGBCOLOR(99, 99, 99, 1)    //[UIColor colorWithWhite:0.6 alpha:1]

#import "XLPickerView.h"

static float KFontSize = 14.f;

@interface PickerItem : UIButton

@end
@implementation PickerItem
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsZero];
        
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        //self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        [self setTitleColor:KTEXTCOLOR forState:UIControlStateNormal];
        [[self titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
        [self setTitle:@"请选择日期" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"trangle_down_rich.png"] forState:UIControlStateNormal];
    }
    return self;
}


@end

@interface XLPickerView()
{
    PickerItem  *lastItem;
    
    NSInteger   lastSelection;
    
    NSInteger   currentSelection;
    
    CGFloat     itemWidth;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;

@end
static float pickerHeight = 44.f;
@implementation XLPickerView

- (void)setMaxShowNum:(NSInteger )maxShowNum{
    _maxShowNum = maxShowNum;
    if (_maxShowNum<=1) {
        _maxShowNum = 3;
        DLog(@">>>>>[XLPicker] SetMaxShowNum must > 1");
    }
    itemWidth = self.frame.size.width/maxShowNum;
    //[self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KWHITECOLOR;
        _maxShowNum = 3;
        itemWidth = frame.size.width/_maxShowNum;     //默认3个btn
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, pickerHeight)];
        _scrollView.contentSize = CGSizeMake(frame.size.width, pickerHeight);
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        lastSelection       =   -1;
        currentSelection    =   -1;
        
    }
    return self;
}

#pragma mark    ###  普通方法
- (void)reloadData{
    
    if (_dataSource) {
        
        NSInteger itemCount = [_dataSource numberOfItemsInPicker:self];
        
        
        if (itemCount<=0) {
            return;
        }else if (itemCount<_maxShowNum){
            
            _maxShowNum = itemCount;
            
            itemWidth = self.frame.size.width/(float)itemCount;
        }
        
        CGFloat itemH = self.frame.size.height;
        if ([_delegate respondsToSelector:@selector(heightForXLPickerView:)]) {
            itemH = [_delegate heightForXLPickerView:self];
        }
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, itemH)];
        _scrollView.contentSize = CGSizeMake(itemWidth*(itemCount-_maxShowNum)+self.frame.size.width, itemH);
        _scrollView.contentOffset = CGPointZero;
        
        
        NSMutableArray *titlesArr = [NSMutableArray new];
        
        // 清空scrollView
        for (UIView *subV in _scrollView.subviews) {
            [subV removeFromSuperview];
        }
        
        // 创建scrollView的item
        for (short i=0; i<itemCount; i++) {
            NSString *title = [_dataSource titleForItemAtIndex:i xlPickerView:self];
            if (IsStrEmpty(title)) {
                continue;
            }
            [titlesArr addObject:title];
            PickerItem *item = [PickerItem buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(i*itemWidth, 0, itemWidth, itemH);
            [item setTitle:title forState:UIControlStateNormal];
            item.tag = 100+i;
            [item addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:item];
            
            if (itemCount>1 && i<itemCount-1) {
                UIView *sepLine = [UIView new];
                sepLine.frame = CGRectMake(CGRectGetMaxX(item.frame), 12, 0.5, itemH-12*2);
                sepLine.backgroundColor = KColor(189, 189, 189);
                [_scrollView addSubview:sepLine];
            }
        }
        
    }
    
}


/**
 单选第几个按钮
 
 @param idx 按钮下标
 */
- (void)selectItem:(NSInteger)idx{
    PickerItem *item = [self viewWithTag:100+idx];
    [self btnClicked:item];
}

- (NSInteger)currentSelectedIndex{
    return currentSelection;
}
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index{
    PickerItem *item = [self viewWithTag:100+index];
    if (item) {
        [item setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark <<<< 内部私有方法

- (void)cancleSelect{
    if ([_delegate respondsToSelector:@selector(xlPickerView:didDeSelectItemAtIndex:)]) {
        [_delegate xlPickerView:self didDeSelectItemAtIndex:lastSelection];
    }
    
    [[lastItem titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
    [UIView animateWithDuration:0.2 animations:^{
        lastItem.imageView.layer.affineTransform = CGAffineTransformMakeRotation(0);
    }];
    
    lastItem = nil;
    currentSelection = -1;
    lastSelection = -1;
}
/**
 pickerItem被点击
 @param btn pickerItem
 */
- (void)btnClicked:(PickerItem *)btn{
    if (btn == nil) {
        return;
    }
    // 移动居中
    if ([self canScrollToCenter:btn]) {
        [self scrollToCenter:btn];
    }else{
        // 如果item现在在屏幕中线左侧，那么就意味着到不了右侧，直接判断可否scrollToLeft
        if ( (btn.center.x-_scrollView.contentOffset.x) < self.frame.size.width/2.f ) {
            if ([self canScrollToLeft:btn]) {
                [self scrollToLeft:btn];
            }
        }else{
            if ([self canScrollToRight:btn]) {
                [self scrollToRight:btn];
            }
        }
    }
    
    if (lastSelection == btn.tag-100) {  //二次点击取消选中
        
        if ([_delegate respondsToSelector:@selector(xlPickerView:didDeSelectItemAtIndex:)]) {
            [_delegate xlPickerView:self didDeSelectItemAtIndex:btn.tag-100];
        }
        [lastItem setTitleColor:KTEXTCOLOR forState:UIControlStateNormal];
        [[lastItem titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
        [UIView animateWithDuration:0.2 animations:^{
            lastItem.imageView.layer.affineTransform = CGAffineTransformMakeRotation(0);
        }];
        //lastItem = nil;
        currentSelection = -1;
        lastSelection = -1;
        return;
    }
    
    //DLog(@"btn:%ld",btn.tag);
    [btn setTitleColor:KColor(47, 47, 47) forState:UIControlStateNormal];
    [[btn titleLabel] setFont:[UIFont boldSystemFontOfSize:KFontSize]];
    currentSelection = btn.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    if (lastItem && lastItem!=btn) {
        [lastItem setTitleColor:KTEXTCOLOR forState:UIControlStateNormal];
        [[lastItem titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
        lastItem.imageView.layer.affineTransform = CGAffineTransformMakeRotation(0);
    }
    lastItem = btn;
    lastSelection = btn.tag - 100;
    if ([_delegate respondsToSelector:@selector(xlPickerView:didSelectItemAtIndex:)]) {
        [_delegate xlPickerView:self didSelectItemAtIndex:btn.tag-100];
    }
//
//  SegmentView.m
//  iUnis
//
//  Created by 张雷 on 16/9/27.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//
#define KTEXTCOLOR  KRGBCOLOR(99, 99, 99, 1)    //[UIColor colorWithWhite:0.6 alpha:1]

#import "XLPickerView.h"

static float KFontSize = 14.f;

@interface PickerItem : UIButton

@end
@implementation PickerItem
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsZero];
        
        self.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        [self setTitleColor:KTEXTCOLOR forState:UIControlStateNormal];
        [[self titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
        [self setTitle:@"请选择" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"trangle_down_rich.png"] forState:UIControlStateNormal];
    }
    return self;
}


@end

@interface XLPickerView()
{
    PickerItem  *lastItem;
    
    NSInteger   lastSelection;
    
    NSInteger   currentSelection;
    
    CGFloat     itemWidth;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;

@end
static float pickerHeight = 44.f;
@implementation XLPickerView

- (void)setMaxShowNum:(NSInteger )maxShowNum{
    _maxShowNum = maxShowNum;
    if (_maxShowNum<=1) {
        _maxShowNum = 3;
        DLog(@">>>>>[XLPicker] SetMaxShowNum must > 1");
    }
    itemWidth = self.frame.size.width/maxShowNum;

}

- (instancetype)xlPickerView{
    return [self init];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initUI:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI:frame];
    }
    return self;
}

- (void)initUI:(CGRect)frame{
    self.backgroundColor = [UIColor whiteColor];
    _maxShowNum = 3;
    itemWidth = frame.size.width/_maxShowNum;     //默认3个btn
    
    if (nil == _scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, pickerHeight)];
        [self addSubview:_scrollView];
    }
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _scrollView.contentSize = CGSizeMake(frame.size.width, pickerHeight);
    _scrollView.contentOffset = CGPointZero;
    _scrollView.bounces = NO;

    lastSelection       =   -1;
    currentSelection    =   -1;

}

#pragma mark    ###  普通方法
- (void)reloadData{
    
    if (_dataSource) {
        
        NSInteger itemCount = [_dataSource numberOfItemsInPicker:self];
        
        CGFloat itemH = self.frame.size.height;
        if ([_delegate respondsToSelector:@selector(heightForXLPickerView:)]) {
            itemH = [_delegate heightForXLPickerView:self];
        }
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, itemH)];
        
        [self initUI:self.frame];
        
        if (itemCount<=0) {
            return;
        }else if (itemCount<_maxShowNum){
            
            _maxShowNum = itemCount;
            
            itemWidth = self.frame.size.width/(float)itemCount;
        }
        
        _scrollView.contentSize = CGSizeMake(itemWidth*(itemCount-_maxShowNum)+self.frame.size.width, itemH);
        _scrollView.contentOffset = CGPointZero;
        
        
        NSMutableArray *titlesArr = [NSMutableArray new];
        
        // 清空scrollView
        for (UIView *subV in _scrollView.subviews) {
            [subV removeFromSuperview];
        }
        
        // 创建scrollView的item
        for (short i=0; i<itemCount; i++) {
            NSString *title = [_dataSource titleForItemAtIndex:i xlPickerView:self];
            if (IsStrEmpty(title)) {
                continue;
            }
            [titlesArr addObject:title];
            PickerItem *item = [PickerItem buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(i*itemWidth, 0, itemWidth, itemH);
            [item setTitle:title forState:UIControlStateNormal];
            item.tag = 100+i;
            [item addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [_scrollView addSubview:item];
            
            if (itemCount>1 && i<itemCount-1) {
                UIView *sepLine = [UIView new];
                sepLine.frame = CGRectMake(CGRectGetMaxX(item.frame), 12, 0.5, itemH-12*2);
                sepLine.backgroundColor = KColor(189, 189, 189);
                [_scrollView addSubview:sepLine];
            }
        }
        
    }
    
}


/**
 单选第几个按钮
 
 @param idx 按钮下标
 */
- (void)selectItem:(NSInteger)idx{
    PickerItem *item = [self viewWithTag:100+idx];
    [self btnClicked:item];
}

- (NSInteger)currentSelectedIndex{
    return currentSelection;
}
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index{
    PickerItem *item = [self viewWithTag:100+index];
    if (item) {
        [item setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark <<<< 内部私有方法

- (void)cancleSelect{
    if ([_delegate respondsToSelector:@selector(xlPickerView:didDeSelectItemAtIndex:)]) {
        [_delegate xlPickerView:self didDeSelectItemAtIndex:lastSelection];
    }
    
    [[lastItem titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
    [UIView animateWithDuration:0.2 animations:^{
        lastItem.imageView.layer.affineTransform = CGAffineTransformMakeRotation(0);
    }];
    
    lastItem = nil;
    currentSelection = -1;
    lastSelection = -1;
}
/**
 pickerItem被点击
 @param btn pickerItem
 */
- (void)btnClicked:(PickerItem *)btn{
    if (btn == nil) {
        return;
    }
    // 移动居中
    if ([self canScrollToCenter:btn]) {
        [self scrollToCenter:btn];
    }else{
        // 如果item现在在屏幕中线左侧，那么就意味着到不了右侧，直接判断可否scrollToLeft
        if ( (btn.center.x-_scrollView.contentOffset.x) < self.frame.size.width/2.f ) {
            if ([self canScrollToLeft:btn]) {
                [self scrollToLeft:btn];
            }
        }else{
            if ([self canScrollToRight:btn]) {
                [self scrollToRight:btn];
            }
        }
    }
    
    if (lastSelection == btn.tag-100) {  //二次点击取消选中
        
        if ([_delegate respondsToSelector:@selector(xlPickerView:didDeSelectItemAtIndex:)]) {
            [_delegate xlPickerView:self didDeSelectItemAtIndex:btn.tag-100];
        }
        [lastItem setTitleColor:KTEXTCOLOR forState:UIControlStateNormal];
        [[lastItem titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
        [UIView animateWithDuration:0.2 animations:^{
            lastItem.imageView.layer.affineTransform = CGAffineTransformMakeRotation(0);
        }];
        //lastItem = nil;
        currentSelection = -1;
        lastSelection = -1;
        return;
    }
    
    //DLog(@"btn:%ld",btn.tag);
    [btn setTitleColor:KColor(47, 47, 47) forState:UIControlStateNormal];
    [[btn titleLabel] setFont:[UIFont boldSystemFontOfSize:KFontSize]];
    currentSelection = btn.tag-100;
    [UIView animateWithDuration:0.2 animations:^{
        btn.imageView.layer.affineTransform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    if (lastItem && lastItem!=btn) {
        [lastItem setTitleColor:KTEXTCOLOR forState:UIControlStateNormal];
        [[lastItem titleLabel] setFont:[UIFont systemFontOfSize:KFontSize]];
        lastItem.imageView.layer.affineTransform = CGAffineTransformMakeRotation(0);
    }
    lastItem = btn;
    lastSelection = btn.tag - 100;
    if ([_delegate respondsToSelector:@selector(xlPickerView:didSelectItemAtIndex:)]) {
        [_delegate xlPickerView:self didSelectItemAtIndex:btn.tag-100];
    }

}


- (void)scrollToLeft:(PickerItem *)item{
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView setContentOffset:CGPointMake(item.frame.origin.x, 0)];
    }];
}
- (void)scrollToCenter:(PickerItem *)item{
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView setContentOffset:CGPointMake(item.center.x-self.frame.size.width/2.f, 0)];
    }];
}
- (void)scrollToRight:(PickerItem *)item{
    [UIView animateWithDuration:0.2 animations:^{
        [_scrollView setContentOffset:CGPointMake((CGRectGetMaxX(item.frame)-self.frame.size.width), 0)];
    }];
}

- (BOOL)canScrollToLeft:(PickerItem *)item{
    if ( (_scrollView.contentSize.width-CGRectGetMaxX(item.frame)) >= self.frame.size.width) {
        return YES;
    }
    return NO;
}
- (BOOL)canScrollToCenter:(PickerItem *)item{
    if ( ((_scrollView.contentSize.width-item.center.x) >= self.frame.size.width/2.f) && (item.center.x>=self.frame.size.width/2.f) ) {
        return YES;
    }
    return NO;
}
- (BOOL)canScrollToRight:(PickerItem *)item{
    if (_scrollView.contentSize.width <= CGRectGetMaxX(item.frame) ) {
        return YES;
    }
    return NO;
}
@end
