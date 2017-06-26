//
//  GravityViewController.m
//  AccelerometerAndGyroscopeDemo
//
//  Created by zpf on 2017/6/26.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

#import "GravityViewController.h"

@interface GravityViewController ()

//设备运动管理类对象
@property (nonatomic, strong) CMMotionManager *motionManager;

//子线程处理
@property (nonatomic, strong) NSOperationQueue *queue;

//重力计展示数据容器
@property (nonatomic, strong) UILabel *gravityLab;

//展示的图片
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重力计";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _motionManager = [[CMMotionManager alloc] init];
    
    _queue = [[NSOperationQueue alloc] init];
    
    //先判断设备硬件是否支持监控手机运动状态
    if (self.motionManager.deviceMotionAvailable) {
        
        //设备运动数据push频率
        self.motionManager.deviceMotionUpdateInterval = 0.01;
        
        //开始在子线程上执行接收push操作
        [self.motionManager startDeviceMotionUpdatesToQueue:self.queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            
            /*
             Block中返回CMDeviceMotion类,CMDeviceMotion类中包含了5个属性
             
             attitude属性:代表设备的姿态
             rotationRate属性:代表设备的旋转速度分别在空间坐标系中各个坐标轴上的的分布
             gravity属性:代表重力加速度在空间坐标系中各个坐标轴上的的分布
             userAcceleration属性:代表用户加速度在空间坐标系中各个坐标轴上的分布
             magneticField属性:代表设备周围的磁场分布(暂时不知道怎么用)
             */
            
            //获取主线程,对UI上的数据展示进行操作(有关对UI的操作都要在主线程上去执行,否则会引起崩溃或者诡异的bug)
            dispatch_async(dispatch_get_main_queue(), ^{
                //重力相关
                if (!_gravityLab) {
                    _gravityLab = [[UILabel alloc] init];
                    _gravityLab.backgroundColor = [UIColor whiteColor];
                    _gravityLab.numberOfLines = 0;
                    _gravityLab.frame = CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width - 20, 100);
                    [self.view addSubview:_gravityLab];
                }
                _gravityLab.text = [NSString stringWithFormat:@"重力计在空间坐标系中的各个轴上的值\ngravity.x = %f\ngravity.y = %f\ngravity.z = %f", motion.gravity.x, motion.gravity.y, motion.gravity.z];
                
                if (!_imageView) {
                    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, [UIScreen mainScreen].bounds.size.width - 20, ([UIScreen mainScreen].bounds.size.width - 20) * 0.8)];
                    _imageView.image = [UIImage imageNamed:@"飞机"];
                    [self.view addSubview:_imageView];
                }
                
                //反正切函数计算偏移弧度
                if (fabs(motion.gravity.z) < 0.995) {
                    _imageView.transform = CGAffineTransformMakeRotation(atan2(motion.gravity.x, motion.gravity.y) - M_PI);
                }
            });
        }];
    }else{
        NSLog(@"您的设备暂不支持此功能");
    }
}

#pragma mark - 警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
