//
//  UIScrollView+XJHPaging.h
//  XJHPaging
//
//  Created by xujunhao on 2017/6/2.
//  Copyright © 2017年 cocoadogs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShouldLoadBlock)(void);

@interface UIScrollView (XJHPaging)

@property (nonatomic, strong) UIScrollView *secondScrollView;

@end
