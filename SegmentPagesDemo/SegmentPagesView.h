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
 *  
     1. 
     2.若不使用buttonWidth、topScrollViewHeight、buttonFontSize、selectButtonColor、buttonColor的默认值，要把这些赋值语句写在属性buttonTitleArray和pageViewArray的赋值语句之前。
     3.pageViewArray和buttonTitleArray的元素个数要一致。
 */

@property (nonatomic, strong) NSArray *buttonTitleArray; //存储按钮标题
@property (nonatomic, strong) NSArray *pageViewArray; //存储切换的视图
@property (nonatomic, copy) SelectIndexBlock block;

//从外界传入block
- (void)getBlockFromOutSpace:(SelectIndexBlock)block;

@end
