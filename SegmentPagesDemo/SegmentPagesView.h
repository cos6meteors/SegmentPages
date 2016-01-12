//
//  SegmentPagesView.h
//  SegmentPagesDemo
//
//  Created by 王春平 on 16/1/11.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectIndexBlock)(NSUInteger selectIndex);

@interface SegmentPagesView : UIView
{
    UIScrollView *_topScrollView;
    UIScrollView *_rootScrollView;
}
/**
 *  !!!注意：若不使用buttonWidth、topScrollViewHeight、buttonFontSize、selectButtonColor、buttonColor的默认值，要把这些赋值语句写在属性buttonTitleArray和pageViewArray的赋值语句之前
 */

@property (nonatomic, strong) NSArray *buttonTitleArray; //存储按钮标题
@property (nonatomic, strong) NSArray *pageViewArray; //存储切换的视图
@property (nonatomic, assign) CGFloat buttonWidth;//用来切换视图的按钮的宽度
@property (nonatomic, assign) CGFloat topScrollViewHeight;//topScrollView的高度
@property (nonatomic, assign) CGFloat buttonFontSize;//按钮标题字号
@property (nonatomic, strong) UIColor *selectButtonColor;//当前展示视图对应按钮颜色
@property (nonatomic, strong) UIColor *buttonColor;//其他按钮颜色
@property (nonatomic, copy) SelectIndexBlock block;

//从外界传入block
- (void)getBlockFromOutSpace:(SelectIndexBlock)block;

@end
