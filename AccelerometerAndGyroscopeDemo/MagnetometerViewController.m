//
//  MagnetometerViewController.m
//  AccelerometerAndGyroscopeDemo
//
//  Created by zpf on 2017/6/26.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

#import "MagnetometerViewController.h"

@interface MagnetometerViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) UILabel *magnetometerLab;

@end

@implementation MagnetometerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"磁力针";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _motionManager = [[CMMotionManager alloc] init];
    
    _queue = [[NSOperationQueue alloc] init];
    
    if (_motionManager.magnetometerAvailable) {
        
        _motionManager.magnetometerUpdateInterval = 0.01;
        
        [_motionManager startMagnetometerUpdatesToQueue:_queue withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!_magnetometerLab) {
                    _magnetometerLab = [[UILabel alloc] init];
                    _magnetometerLab.backgroundColor = [UIColor whiteColor];
                    _magnetometerLab.numberOfLines = 0;
                    _magnetometerLab.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, 100);
                    [self.view addSubview:_magnetometerLab];
                }
                
                _magnetometerLab.text = [NSString stringWithFormat:@"磁力针  magnetometerData.magneticField\nx = %f\ny = %f\nz = %f", magnetometerData.magneticField.x, magnetometerData.magneticField.y, magnetometerData.magneticField.z];
                
            });
        }];
        
    }else{
        NSLog(@"此设备暂不支持此功能");
    }
}

#pragma mark - 警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
