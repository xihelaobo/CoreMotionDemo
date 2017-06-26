//
//  AccelerometerViewController.m
//  AccelerometerAndGyroscopeDemo
//
//  Created by zpf on 2017/6/23.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

#import "AccelerometerViewController.h"

@interface AccelerometerViewController ()

//设备运动管理类对象
@property (nonatomic, strong) CMMotionManager *motionManager;

//子线程处理
@property (nonatomic, strong) NSOperationQueue *queue;

//加速度的数据显示
@property (nonatomic, strong) UILabel *accelerationLab;

@end

@implementation AccelerometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加速度计";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _motionManager = [[CMMotionManager alloc] init];
    
    _queue = [[NSOperationQueue alloc] init];
    
    if (_motionManager.accelerometerAvailable) {
        
        //加速度计数据push频率
        _motionManager.accelerometerUpdateInterval = 0.01;
        
        __block BOOL flag = YES;
        
        [_motionManager startAccelerometerUpdatesToQueue:_queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程对UI进行操作,因为界面上的UI变化都是在主线程中去执行的
                if (!_accelerationLab) {
                    _accelerationLab = [[UILabel alloc] init];
                    _accelerationLab.backgroundColor = [UIColor whiteColor];
                    _accelerationLab.numberOfLines = 0;
                    _accelerationLab.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, 150);
                    [self.view addSubview:_accelerationLab];
                }
                
                _accelerationLab.text = [NSString stringWithFormat:@"加速度计\n向左晃动手机将会返回上一级页面\naccelerometerData.acceleration.x = %f\naccelerometerData.acceleration.y = %f\naccelerometerData.acceleration.z = %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z];
                
                //通过向左摇晃手机pop到上一级界面
                if (accelerometerData.acceleration.x < -1.5 && flag) {
                    [self.motionManager stopAccelerometerUpdates];
                    flag = NO;
                    //返回操作一定要放到主线程中去执行
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }];
    }else{
        NSLog(@"该设备加速度计不可用");
    }
}

#pragma mark - 警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
