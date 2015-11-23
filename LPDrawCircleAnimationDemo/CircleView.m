//
//  CircleView.m
//  LPDrawCircleAnimationDemo
//
//  Created by QFWangLP on 15/11/20.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

+ (Class)layerClass
{
    return [CircleLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleLayer = [CircleLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.circleLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

@end
