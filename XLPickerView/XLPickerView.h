//
//  SegmentView.h
//  iUnis
//
//  Created by 张雷 on 16/9/27.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  XLPickerView;

@protocol XLPickerDataSource <NSObject>
@required

// item总个数
- (NSInteger)numberOfItemsInPicker:(XLPickerView *)xlPickerView;
// item显示的文字
- (NSString *)titleForItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;

@optional
// 选中颜色字体 不同的idx 可以有不同的设置
- (UIColor *)colorForSelectItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;
- (UIFont *)fontForSelectItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;
@end


@protocol XLPickerDelegate <NSObject>
@optional

/**
 picker高度

 @param picker picker
 @return picker高度
 */
- (CGFloat)heightForXLPickerView:(XLPickerView *)picker;
- (void)xlPickerView:(XLPickerView *)picker didSelectItemAtIndex:(NSInteger)index;
- (void)xlPickerView:(XLPickerView *)picker didDeSelectItemAtIndex:(NSInteger)index;

@end

@interface XLPickerView : UIView

@property (assign) id<XLPickerDelegate> delegate;
@property (assign) id<XLPickerDataSource> dataSource;

- (void)reloadData;

/**
 选中第几个item
 @param idx index
 */
- (void)selectItem:(NSInteger)idx;

/**
 通用初始化方法 可使用masonry
 @return xlPickerView ZeroRect
 */
- (instancetype)xlPickerView;

/**
 frame初始化方法

 @param frame 初始化frame
 @return xlPickerView实例
 */
- (instancetype)initWithFrame:(CGRect)frame;


/**
 返回当前选中的item index
 */
- (NSInteger)currentSelectedIndex;

/**
 换item的标题

 @param title 标题：title
 @param index 位置：index
 */
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index;

/**
 取消当前item的选中
 */
- (void)cancleSelect;

/**
 最大显示元素个数
 */
@property (nonatomic, assign) NSInteger maxShowNum;

@end



