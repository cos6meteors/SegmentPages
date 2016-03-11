//
//  SegmentPagesView.m
//  SegmentPagesDemo
//
//  Created by 王春平 on 16/1/11.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "SegmentPagesView.h"

@interface SegmentPagesView ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger selectIndex;//选中按钮下标
@property (nonatomic, strong) UIView *lineView;//按钮下方的横线视图
@property (nonatomic, strong) NSArray *buttonArray;//存储topScrollView上的按钮

@end

@implementation SegmentPagesView

@synthesize buttonFontSize = _buttonFontSize, buttonColor = _buttonColor, selectButtonColor = _selectButtonColor, buttonTitleArray = _buttonTitleArray, topScrollViewHeight = _topScrollViewHeight, buttonWidth = _buttonWidth;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _buttonFontSize = 15;
        _selectButtonColor = RedColor;
        _buttonColor = GrayColor;
        _topScrollViewHeight = 44;
        _buttonWidth = 80;
        _selectIndex = 0;
    }
    return self;
}

//从外界传入block，并赋值给self.block
- (void)getBlockFromOutSpace:(SelectIndexBlock)block {
    self.block = block;
}

#pragma mark - setter method

- (void)setButtonWidth:(CGFloat)buttonWidth {
    _buttonWidth = buttonWidth;
}

- (void)setButtonFontSize:(CGFloat)buttonFontSize {
    _buttonFontSize = buttonFontSize;
}

- (void)setSelectButtonColor:(UIColor *)selectButtonColor {
    _selectButtonColor = selectButtonColor;
}

- (void)setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
}

- (void)setTopScrollViewHeight:(CGFloat)topScrollViewHeight {
    _topScrollViewHeight = topScrollViewHeight;
}

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
    [btn setTitleColor:_selectButtonColor forState:UIControlStateNormal];
    [buttons removeObject:btn];
    for (UIButton *tempBtn in buttons) {
        [tempBtn setTitleColor:_buttonColor forState:UIControlStateNormal];
    }
    //设置_rootScrollView偏移量，切换视图
    [_rootScrollView setContentOffset:CGPointMake(selectIndex * ScreenWidth, 0) animated:YES];
    self.block(selectIndex);
}

#pragma mark - setupSubViews

- (void)setupTopScrollView {
    //whiteView：给topScrollView加一个白色背景
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _topScrollViewHeight)];
    whiteView.backgroundColor = [UIColor whiteColor];
    CGFloat topScrollViewWidth = _buttonTitleArray.count * _buttonWidth;
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(whiteView.center.x - topScrollViewWidth / 2, 0, topScrollViewWidth, _topScrollViewHeight)];
    _topScrollView.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:_topScrollView];
    [self addSubview:whiteView];
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:1];
    for (NSUInteger i = 0; i < _buttonTitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * _buttonWidth, 0, _buttonWidth, _topScrollViewHeight);
        button.tag = i + 1;
        [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handlePress:) forControlEvents:UIControlEventTouchDown];
        button.titleLabel.font = [UIFont systemFontOfSize:_buttonFontSize];
        if (0 == i) {
            [button setTitleColor:_selectButtonColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:_buttonColor forState:UIControlStateNormal];
        }
        [_topScrollView addSubview:button];
        [buttons addObject:button];
    }
    self.buttonArray = [buttons copy];
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _topScrollViewHeight - 2, self.buttonWidth, 2)];
    self.lineView.backgroundColor = _selectButtonColor;
    [_topScrollView addSubview:self.lineView];
}

- (void)setupRootScrollView {
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topScrollViewHeight, ScreenWidth, ScreenHeight - _topScrollViewHeight)];
    _rootScrollView.contentSize = CGSizeMake(ScreenWidth * _pageViewArray.count, CGRectGetHeight(_rootScrollView.frame));
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.backgroundColor = [UIColor colorWithRed:0.929 green:0.918 blue:0.914 alpha:1.000];
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.delegate = self;
    for (NSUInteger i = 0; i < _pageViewArray.count; i++) {
        UIView *view = _pageViewArray[i];
        view.frame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight - _topScrollViewHeight);
        [_rootScrollView addSubview:view];
    }
    [self addSubview:_rootScrollView];
}

//点击按钮
- (void)handlePress:(UIButton *)btn {
    self.selectIndex = btn.tag - 1;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _rootScrollView) {
        CGFloat newLineViewX = self.buttonWidth * scrollView.contentOffset.x / ScreenWidth;
        //修改横线视图的位置
        [self.lineView setOrigin:CGPointMake(newLineViewX, _topScrollViewHeight - 2)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _rootScrollView) {
        self.selectIndex = scrollView.contentOffset.x / ScreenWidth;
    }
}

@end

