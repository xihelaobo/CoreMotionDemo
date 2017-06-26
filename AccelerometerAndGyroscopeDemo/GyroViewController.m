//
//  GyroViewController.m
//  AccelerometerAndGyroscopeDemo
//
//  Created by zpf on 2017/6/23.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

#import "GyroViewController.h"

@interface GyroViewController ()

//设备运动管理类对象
@property (nonatomic, strong) CMMotionManager *motionManager;

//子线程处理
@property (nonatomic, strong) NSOperationQueue *queue;

//陀螺仪数据显示
@property (nonatomic, strong) UILabel *gyroLab;

//展示的图片
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GyroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"陀螺仪";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _motionManager = [[CMMotionManager alloc] init];
    
    _queue = [[NSOperationQueue alloc] init];
    
    if (_motionManager.gyroAvailable) {
        _motionManager.gyroUpdateInterval = 0.01;
        [_motionManager startGyroUpdatesToQueue:self.queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程对UI进行操作,因为界面上的UI变化都是在主线程中去执行的
                if (!_gyroLab) {
                    _gyroLab = [[UILabel alloc] init];
                    _gyroLab.backgroundColor = [UIColor whiteColor];
                    _gyroLab.numberOfLines = 0;
                    _gyroLab.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, 100);
                    [self.view addSubview:_gyroLab];
                }
                
                _gyroLab.text = [NSString stringWithFormat:@"陀螺仪\ngyroData.rotationRate.x = %f\ngyroData.rotationRate.y = %f\ngyroData.rotationRate.z = %f", gyroData.rotationRate.x, gyroData.rotationRate.y, gyroData.rotationRate.z];
                
                if (!_imageView) {
                    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 180, [UIScreen mainScreen].bounds.size.width - 20, ([UIScreen mainScreen].bounds.size.width - 20) * 0.8)];
                    _imageView.image = [UIImage imageNamed:@"飞机"];
                    [self.view addSubview:_imageView];
                }
                
                //沿着Y轴转动手机,通过图片的转动速率和方向可以观察出来陀螺仪在Z轴上的旋转速度和旋转方向
                _imageView.transform = CGAffineTransformMakeRotation(M_PI * gyroData.rotationRate.z * 0.01 * 5);
            });
        }];
    }
}

#pragma mark - 警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
