//
//  ViewController.m
//  XJHPaging
//
//  Created by xujunhao on 2017/6/2.
//  Copyright © 2017年 cocoadogs. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "UIScrollView+XJHPaging.h"
#import "XJHTableViewCell.h"
#import <MJRefresh.h>

#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#ifdef DEBUG
#define DLog(FORMAT, ...) fprintf(stderr,"%s\n\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#endif

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DetailViewController *detailVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XJHTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XJHTableViewCell class])];
    self.tableView.rowHeight = 60.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJHTableViewCell class]) forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = @"First Page";
    return cell;
}


#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_detailVC) {
        
        _detailVC = [[DetailViewController alloc] initWithNibName:NSStringFromClass([DetailViewController class]) bundle:nil];
        [self addChildViewController:_detailVC];
        if (_detailVC.tableView) {
            self.tableView.secondScrollView = _detailVC.tableView;
            
        }
        
    }
}


#pragma mark - Lazy Load Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = (id)self;
        _tableView.dataSource = (id)self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
//        _tableView.sectionFooterHeight = CGFLOAT_MIN;
    }
    return _tableView;
}


@end
