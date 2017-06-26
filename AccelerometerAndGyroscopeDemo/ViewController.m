//
//  ViewController.m
//  AccelerometerAndGyroscopeDemo
//
//  Created by zpf on 2017/6/22.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

#import "ViewController.h"
#import "AccelerometerViewController.h"
#import "GyroViewController.h"
#import "GravityViewController.h"
#import "MagnetometerViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataMutableArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CoreMotion框架实质上是为用户提供手机中各种传感器的工作数据(包含了加速度计,陀螺仪,磁力针,重力等传感器)
    //该框架中的核心类为:CMMotionManager类
    
    self.title = @"CoreMotion";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _dataMutableArray = [[NSMutableArray alloc] initWithObjects:@"重力计", @"加速度计", @"陀螺仪", @"磁力针", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *string = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.textLabel.text = _dataMutableArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_dataMutableArray[indexPath.row] isEqualToString:@"重力计"]) {
        GravityViewController *gravityVC = [[GravityViewController alloc] init];
        [self.navigationController pushViewController:gravityVC animated:YES];
    }else if ([_dataMutableArray[indexPath.row] isEqualToString:@"加速度计"]) {
        AccelerometerViewController *accelerometerVC = [[AccelerometerViewController alloc] init];
        [self.navigationController pushViewController:accelerometerVC animated:YES];
    }else if ([_dataMutableArray[indexPath.row] isEqualToString:@"陀螺仪"]) {
        GyroViewController *gyroVC = [[GyroViewController alloc] init];
        [self.navigationController pushViewController:gyroVC animated:YES];
    }else if ([_dataMutableArray[indexPath.row] isEqualToString:@"磁力针"]) {
        MagnetometerViewController *magnetometerVC = [[MagnetometerViewController alloc] init];
        [self.navigationController pushViewController:magnetometerVC animated:YES];
    }
}

#pragma mark - 警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
