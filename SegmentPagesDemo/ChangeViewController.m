//
//  SegmentPagesView.h
//  SegmentPagesDemo
//
//  Created by 王春平 on 16/1/11.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "ChangeViewController.h"

@interface ChangeViewController ()<UIScrollViewDelegate>

@end

@implementation ChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat y = 0.0;
    if (self.navigationController.navigationBar.translucent) {
        
        //对scrollView加载子视图偏移问题进行处理
        self.automaticallyAdjustsScrollViewInsets = NO;
        y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    SegmentPagesView *segView = [[SegmentPagesView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight)];
    segView.buttonTitleArray = @[@"已领取", @"已消费", @"已过期"];
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor colorWithRed:0.894 green:0.217 blue:0.825 alpha:1.000];
    UIView *yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = [UIColor greenColor];
    segView.pageViewArray = @[grayView, yellowView, greenView];
    [segView getBlockFromOutSpace:^(NSUInteger selectIndex) {
        //do some operations after select
    }];
    [self.view addSubview:segView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && self.view.window) {
        self.view = nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
