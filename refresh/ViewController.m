//
//  ViewController.m
//  refresh
//
//  Created by peter on 15/10/29.
//  Copyright © 2015年 oyfj. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+Loading.h"

static  NSString * const cellid = @"cellid";

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView didLoadAll];
    
    
//    [self performSelector:@selector(refreshData) withObject:nil afterDelay:1.5];
}

- (void)refreshData{
    
    self.tableView.refreshing = YES;
    [self.array removeAllObjects];

    for (int i=0 ; i<15 ; i++) {
        
        [self.array addObject:@(i)];
    }
    
    self.tableView.refreshing = NO;
}

-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
        for (int i=0 ; i<15 ; i++) {
            
            [_array addObject:@(i)];
        }
    }
    
    return _array;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.estimatedRowHeight = 40;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellid];
        
        __weak typeof(self) ws = self;
        [_tableView addLoadMoreFooterWithAction:^{
            NSLog(@"-----------------------load more----------------------");
            
            [ws performSelector:@selector(fetchNextPage) withObject:nil afterDelay:1.5];
        }];
        
    }
    
    return _tableView;
}

- (void)fetchNextPage{
    
//    if (self.array.count < 30) {
        for (int i=0; i<10; i++) {
            [self.array addObject:@(i)];
        }
        [self.tableView reloadData];
        
        [self.tableView finishLoading];
//    }else{
//        
//        [self.tableView loadFailed:@"网络好像有些慢"];
//    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self refreshData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return arc4random() % 100 + 30;
}
@end
