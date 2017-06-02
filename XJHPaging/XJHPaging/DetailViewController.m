//
//  DetailViewController.m
//  XJHPaging
//
//  Created by xujunhao on 2017/6/2.
//  Copyright © 2017年 cocoadogs. All rights reserved.
//

#import "DetailViewController.h"
#import "XJHTableViewCell.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XJHTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XJHTableViewCell class])];
    self.tableView.rowHeight = 76.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"DetailViewController === viewDidAppear ===");
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
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XJHTableViewCell class]) forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = @"Detail Page";
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


@end
