//
//  RxTureController.m
//  Pop
//
//  Created by 张宝山 on 2019/11/26.
//  Copyright © 2019 张宝山. All rights reserved.
//

#import "RxTureController.h"
#import "UITableView+NoData.h"
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface RxTureController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , copy) NSMutableArray *dataSource;

@end

@implementation RxTureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试tableView";
    self.view.backgroundColor = [UIColor whiteColor];
    
   /*
    测试tableView在无数据时默认显示页面
    */
    [self layoutViews];
    [self.tableView reloadData];
}


- (void)layoutViews{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
}


#pragma mark - TableView delegate & dataSource

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}

#pragma mark - 调节占位图

- (NSString *)tb_noDataViewTitle {
    return @"测试数据";
}

- (UIImage *)tb_noDataViewImage {
    
    return [UIImage imageNamed:@"none"];
}

@end
