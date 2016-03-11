//
//  SegmentPagesView.m
//  SegmentPagesDemo
//
//  Created by 王春平 on 16/1/11.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "SegmentPagesView.h"

//topScrollView的高度
#define topScrollViewHeight 44
//用来切换视图的按钮的宽度
#define buttonWidth 80
//按钮标题字号
#define buttonFontSize 15
//当前展示视图对应按钮颜色
#define selectButtonColor [UIColor colorWithRed:1.000 green:0.314 blue:0.353 alpha:1.000]
//其他按钮颜色
#define buttonColor [UIColor colorWithRed:0.548 green:0.540 blue:0.497 alpha:1.000]

@interface SegmentPagesView ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger selectIndex;//选中按钮下标
@property (nonatomic, strong) UIView *lineView;//按钮下方的横线视图
@property (nonatomic, strong) NSArray *buttonArray;//存储topScrollView上的按钮

@end

@implementation SegmentPagesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectIndex = 0;
    }
    return self;
}

//从外界传入block，并赋值给self.block
- (void)getBlockFromOutSpace:(SelectIndexBlock)block {
    self.block = block;
}

#pragma mark - setter method

- (void)setButtonTitleArray:(NSArray *)buttonTitleArray {
    _buttonTitleArray = buttonTitleArray;
    [self setupTopScrollView];
}

- (void)setPageViewArray:(NSArray *)pageViewArray {
    _pageViewArray = pageViewArray;
    [self setupRootScrollView];
}

- (void)setSelectIndex:(NSUInteger)selectIndex {
    NSMutableArray *buttons = [self.buttonArray mutableCopy];
    UIButton *btn = buttons[selectIndex];
    [btn setTitleColor:selectButtonColor forState:UIControlStateNormal];
    [buttons removeObject:btn];
    for (UIButton *tempBtn in buttons) {
        [tempBtn setTitleColor:buttonColor forState:UIControlStateNormal];
    }
    //设置_rootScrollView偏移量，切换视图
    [_rootScrollView setContentOffset:CGPointMake(selectIndex * ScreenWidth, 0) animated:YES];
    self.block(selectIndex);
}

#pragma mark - setupSubViews

- (void)setupTopScrollView {
    //whiteView：给topScrollView加一个白色背景
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topScrollViewHeight)];
    whiteView.backgroundColor = [UIColor whiteColor];
    CGFloat topScrollViewWidth = _buttonTitleArray.count * buttonWidth;
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(whiteView.center.x - topScrollViewWidth / 2, 0, topScrollViewWidth, topScrollViewHeight)];
    _topScrollView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:1];
    for (NSUInteger i = 0; i < _buttonTitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, topScrollViewHeight);
        button.tag = i + 1;
        [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchDown];
        button.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];
        if (0 == i) {
            [button setTitleColor:selectButtonColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
        }
        [_topScrollView addSubview:button];
        [buttons addObject:button];
    }
    self.buttonArray = [buttons copy];
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topScrollViewHeight - 2, buttonWidth, 2)];
    self.lineView.backgroundColor = selectButtonColor;
    [_topScrollView addSubview:self.lineView];
    [whiteView addSubview:_topScrollView];
    [self addSubview:whiteView];
}

- (void)setupRootScrollView {
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topScrollViewHeight, ScreenWidth, ScreenHeight - topScrollViewHeight)];
    _rootScrollView.contentSize = CGSizeMake(ScreenWidth * _pageViewArray.count, CGRectGetHeight(_rootScrollView.frame));
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.backgroundColor = [UIColor colorWithRed:0.929 green:0.918 blue:0.914 alpha:1.000];
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.delegate = self;
    for (NSUInteger i = 0; i < _pageViewArray.count; i++) {
        UIView *view = _pageViewArray[i];
        view.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight - topScrollViewHeight);
        [_rootScrollView addSubview:view];
    }
    [self insertSubview:_rootScrollView belowSubview:_topScrollView];
}

//点击按钮
- (void)handlePress:(UIButton *)btn {
    self.selectIndex = btn.tag - 1;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _rootScrollView) {
        CGFloat newLineViewX = buttonWidth * scrollView.contentOffset.x / ScreenWidth;
        //修改横线视图的位置
        [self.lineView setOrigin:CGPointMake(newLineViewX, topScrollViewHeight - 2)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _rootScrollView) {
        self.selectIndex = scrollView.contentOffset.x / ScreenWidth;
    }
}

@end

