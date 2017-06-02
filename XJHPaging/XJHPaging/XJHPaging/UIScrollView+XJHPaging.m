//
//  UIScrollView+XJHPaging.m
//  XJHPaging
//
//  Created by xujunhao on 2017/6/2.
//  Copyright © 2017年 cocoadogs. All rights reserved.
//

#import "UIScrollView+XJHPaging.h"
#import <objc/runtime.h>
#import <MJRefresh.h>

static const NSTimeInterval kAnimationDuration = 0.25;

static const CGFloat kFooterHeight = 88.0f;

static const char xjh_secondScrollView;
static const char xjh_originContentHeight;
static const char xjh_hasLoaded;

@interface UIScrollView ()

@property (nonatomic, assign) CGFloat originContentHeight;
@property (nonatomic, assign) BOOL hasLoaded;

@end

@implementation UIScrollView (XJHPaging)

#pragma mark - Setter/Getter Methods

- (void)setSecondScrollView:(UIScrollView *)secondScrollView {
    objc_setAssociatedObject(self, &xjh_secondScrollView, secondScrollView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.hasLoaded = NO;
    [self configFirstScrollViewFooter];
//    CGRect frame = self.frame;
//    frame.origin.y = self.contentSize.height + self.mj_footer.frame.size.height;
//    secondScrollView.frame = frame;
//    [self addSubview:secondScrollView];
//    [self configSecondScrollViewHeader];
}

- (UIScrollView *)secondScrollView {
    return objc_getAssociatedObject(self, &xjh_secondScrollView);
}

- (void)setOriginContentHeight:(CGFloat)originContentHeight {
    objc_setAssociatedObject(self, &xjh_originContentHeight, @(originContentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)originContentHeight {
    return [objc_getAssociatedObject(self, &xjh_originContentHeight) floatValue];
}

- (void)setHasLoaded:(BOOL)hasLoaded {
    objc_setAssociatedObject(self, &xjh_hasLoaded, @(hasLoaded), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasLoaded {
    return [objc_getAssociatedObject(self, &xjh_hasLoaded) boolValue];
}

#pragma mark - Additional Methods

- (void)configFirstScrollViewFooter {
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.hasLoaded) {
            [weakSelf endFooterRefreshing];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf endFooterRefreshing];
            });
        }
    }];
    CGRect frame = footer.frame;
    frame.size.height = kFooterHeight;
    footer.frame = frame;
    footer.triggerAutomaticallyRefreshPercent = 1.0f;
    [footer setTitle:@"^上拉查看图文详情" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    self.mj_footer = footer;
}

- (void)configSecondScrollViewHeader {
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf endHeaderRefreshing];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉回到\"商品详情\"" forState:MJRefreshStateIdle];
    [header setTitle:@"释放回到\"商品详情\"" forState:MJRefreshStatePulling];
    [header setTitle:@"正在返回" forState:MJRefreshStateRefreshing];
    self.secondScrollView.mj_header = header;
}

- (void)endFooterRefreshing {
    self.hasLoaded = YES;
    CGRect frame = self.frame;
    frame.origin.y = self.contentSize.height + self.mj_footer.frame.size.height;
    self.secondScrollView.frame = frame;
    [self addSubview:self.secondScrollView];
    [self configSecondScrollViewHeader];
    
    [self.mj_footer endRefreshing];
    self.mj_footer.hidden = YES;
    self.scrollEnabled = NO;
    
    self.secondScrollView.mj_header.hidden = NO;
    self.secondScrollView.scrollEnabled = YES;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(-self.contentSize.height-self.mj_footer.frame.size.height, 0, 0, 0);
    }];
    self.originContentHeight = self.contentSize.height;
    self.contentSize = self.secondScrollView.contentSize;
}

- (void)endHeaderRefreshing {
    [self.secondScrollView.mj_header endRefreshing];
    self.secondScrollView.mj_header.hidden = YES;
    self.secondScrollView.scrollEnabled = NO;
    
    self.scrollEnabled = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.contentInset = UIEdgeInsetsMake(0, 0, self.mj_footer.frame.size.height, 0);
    }];
    self.contentSize = CGSizeMake(0, self.originContentHeight);
    [self setContentOffset:CGPointZero animated:YES];
    [self configFirstScrollViewFooter];
}

@end
