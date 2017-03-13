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
- (NSInteger)numberOfItemsInPicker:(XLPickerView *)xlPickerView;
- (NSString *)titleForItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;

@optional
- (UIColor *)colorForSelectItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;
- (UIFont *)fontForSelectItemAtIndex:(NSInteger)index xlPickerView:(XLPickerView *)picker;
@end


@protocol XLPickerDelegate <NSObject>
@optional
- (CGFloat)heightForXLPickerView:(XLPickerView *)picker;
- (void)xlPickerView:(XLPickerView *)picker didSelectItemAtIndex:(NSInteger)index;
- (void)xlPickerView:(XLPickerView *)picker didDeSelectItemAtIndex:(NSInteger)index;

@end

@interface XLPickerView : UIView

@property (nonatomic) NSArray *titles;

@property (assign) id<XLPickerDelegate> delegate;
@property (assign) id<XLPickerDataSource> dataSource;

- (void)reloadData;
- (void)selectItem:(NSInteger)idx;

/**
 返回当前选中的item index
 */
- (NSInteger)currentSelectedIndex;
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index;
- (void)cancleSelect;

@property (nonatomic, assign) NSInteger maxShowNum;
@end


