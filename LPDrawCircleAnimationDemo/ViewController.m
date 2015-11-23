//
//  ViewController.m
//  LPDrawCircleAnimationDemo
//
//  Created by QFWangLP on 15/11/20.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UISlider *silderValue;
@property (nonatomic, strong) CircleView *circleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"LeeFengHY";
    _silderValue.value = 0.5;
    _progressLabel.text = [NSString stringWithFormat:@"%0.4f",_silderValue.value];
    _circleView = [[CircleView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_progressLabel.frame) - 320, 320, 320)];
    _circleView.backgroundColor = [UIColor yellowColor];
    //首次进入
    self.circleView.circleLayer.progress = _silderValue.value;
    [self.view addSubview:_circleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)silderValue:(UISlider *)sender {
    _progressLabel.text = [NSString stringWithFormat:@"%0.4f",_silderValue.value];
    self.circleView.circleLayer.progress =_silderValue.value;
}

@end
