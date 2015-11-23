
//
//  CircleLayer.m
//  LPDrawCircleAnimationDemo
//
//  Created by QFWangLP on 15/11/20.
//  Copyright © 2015年 QFWang. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    POINT_D,
    POINT_B,
} MovingPoint;

#define outsideRectSize 90

@interface CircleLayer ()

/**
 *  外接矩形CGRect
 */
@property (nonatomic, assign) CGRect outsideRect;

/**
 *  记录上次滑动的progress, 方便求差做出滑动方向
 */
@property (nonatomic, assign) CGFloat lastProgress;

/**
 *  实时记录滑动方向
 */
@property (nonatomic, assign) MovingPoint movePoint;

@end

@implementation CircleLayer

- (id)init
{
    self = [super init];
    if (self) {
        self.lastProgress = 0.5;
    }
    return self;
}

- (id)initWithLayer:(CircleLayer *)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        self.progress = layer.progress;
        self.outsideRect = layer.outsideRect;
        self.lastProgress = layer.lastProgress;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    //A-C1、B-C2... 的距离，当设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形
    CGFloat offset = self.outsideRect.size.width / 3.6;
    
    //A.B.C.D实际需要移动的距离.系数为滑块偏离中点0.5的绝对值再乘以2.当滑到两端的时候，movedDistance为最大值：「外接矩形宽度的1/5」.
    CGFloat movedDistance = (self.outsideRect.size.width * 1 / 6) * fabs(self.progress - 0.5)*2;
    
    //计算各点坐标, 首先求出中心点坐标
    CGPoint rectCenter = CGPointMake(self.outsideRect.origin.x + self.outsideRect.size.width/2, self.outsideRect.origin.y + self.outsideRect.size.height/2);
    
    //pointA坐标
    CGPoint pointA = CGPointMake(rectCenter.x, self.outsideRect.origin.y + movedDistance);
    //pointB坐标
    CGPoint pointB = CGPointMake(self.movePoint == POINT_D?(rectCenter.x + self.outsideRect.size.width / 2):(rectCenter.x + self.outsideRect.size.width/2 + movedDistance*2), rectCenter.y);
    //pointC坐标
    CGPoint pointC = CGPointMake(rectCenter.x, rectCenter.y + self.outsideRect.size.height/2 - movedDistance);
    //pointD坐标
    CGPoint pointD = CGPointMake(self.movePoint == POINT_D?(self.outsideRect.origin.x - movedDistance*2):(self.outsideRect.origin.x), rectCenter.y);
    
    //pointC1
    CGPoint pointC1 = CGPointMake(pointA.x + offset, pointA.y);
    //pointC2
    CGPoint pointC2 = CGPointMake(pointB.x, self.movePoint == POINT_D?pointB.y - offset:pointB.y - offset + movedDistance);
    //pointC3
    CGPoint pointC3 = CGPointMake(pointB.x, self.movePoint == POINT_D?pointB.y + offset:pointB.y + (offset - movedDistance));
    //pointC4
    CGPoint pointC4 = CGPointMake(pointC.x + offset, pointC.y);
    //pointC5
    CGPoint pointC5 = CGPointMake(pointC.x - offset, pointC.y);
    //pointC6
    CGPoint pointC6 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y + (offset - movedDistance):pointD.y+offset);
    //pointC7
    CGPoint pointC7 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y - offset + movedDistance:pointD.y - offset);
    //pointC8
    CGPoint pointC8 = CGPointMake(pointA.x - offset, pointA.y);
    
    //外层矩形-虚线
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    CGContextAddPath(ctx, rectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    /**
     *  参数说明:先绘制5.0像素点,再跳过5.0像素点-如此反复,如果CGFloat dash[] = {5,10,5}则表示:先绘制5个点,跳过10个点,绘制5个点,跳过5个点,再绘制10个点--如此反复
     */
    CGFloat dash[] = {5.0,5.0};
    /**
     *  参数说明:1.ctx(上下行文) 2.表示首先先绘制[5.0 - 改值个点],然后后跳过5.0个点(取决于dash的第二个值),以后还是绘制5.0个点,跳过5.0个点,反复绘制
     */
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    /**
     *  开始绘制
     */
    CGContextStrokePath(ctx);
    
    //内圆的边界+填充圆color(由4条弧线组成的圆)
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    /**
     *  以三个点画一段曲线，一般和moveToPoint配合使用
     *  - (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
     *  参数说明:endPoint-曲线的终点, controlPoint1-画曲线的第一个基准点, controlPoint2-画曲线的第二个基准点
     */
    [ovalPath addCurveToPoint:pointB controlPoint1:pointC1 controlPoint2:pointC2];
    [ovalPath addCurveToPoint:pointC controlPoint1:pointC3 controlPoint2:pointC4];
    [ovalPath addCurveToPoint:pointD controlPoint1:pointC5 controlPoint2:pointC6];
    [ovalPath addCurveToPoint:pointA controlPoint1:pointC7 controlPoint2:pointC8];
    [ovalPath closePath];
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0, NULL, 0);
    /**
     *  同时给线条和线条包围的内部区域填充颜色
     */
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //标记出每个点并连线，方便观察，给所有关键点染色 -- 白色,辅助线颜色 -- 白色
    //语法糖：字典@{}，数组@[]，基本数据类型封装成对象@234，@12.0，@YES,@(234+12.0)
    CGContextSetFillColorWithColor(ctx, [UIColor purpleColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *points = @[[NSValue valueWithCGPoint:pointA],[NSValue valueWithCGPoint:pointB],[NSValue valueWithCGPoint:pointC],[NSValue valueWithCGPoint:pointD],[NSValue valueWithCGPoint:pointC1],[NSValue valueWithCGPoint:pointC2],[NSValue valueWithCGPoint:pointC3],[NSValue valueWithCGPoint:pointC4],[NSValue valueWithCGPoint:pointC5],[NSValue valueWithCGPoint:pointC6],[NSValue valueWithCGPoint:pointC7],[NSValue valueWithCGPoint:pointC8]];
    [self drawPoint:points withContext:ctx];
    
    //A-C1-C2-B-C3-C4-C-C5-C6-D-C7-C7辅助线--虚线
    UIBezierPath *helpPath = [UIBezierPath bezierPath];
    [helpPath moveToPoint:pointA];
    [helpPath addLineToPoint:pointC1];
    [helpPath addLineToPoint:pointC2];
    [helpPath addLineToPoint:pointB];
    [helpPath addLineToPoint:pointC3];
    [helpPath addLineToPoint:pointC4];
    [helpPath addLineToPoint:pointC];
    [helpPath addLineToPoint:pointC5];
    [helpPath addLineToPoint:pointC6];
    [helpPath addLineToPoint:pointD];
    [helpPath addLineToPoint:pointC7];
    [helpPath addLineToPoint:pointC8];
    CGContextAddPath(ctx, helpPath.CGPath);
    CGFloat dash2[] = {2,2};
    CGContextSetLineDash(ctx, 0, dash2, 2);
    //开始画
    CGContextStrokePath(ctx);
    
    
}

/**
 * ctx字面意思是上下文，你可以理解为一块全局的画布。也就是说，一旦在某个地方改了画布的一些属性，其他任何使用画布的属性的时候都是改了之后的。比如上面在 //1 中把线条样式改成了虚线，那么在下文 //2 中如果不恢复成连续的直线，那么画出来的依然是//1中的虚线样式。
 *
 *
 *  @param points 运动轨迹集合--在某个point位置画一个点，方便观察运动情况
 *  @param ctx    画布
 */
-(void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx{
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2, point.y - 2, 4, 4));
    }
}

/**
 *  实时重绘
 *  知识点说明:position--控件的位置点,一般为控件的中心点.但是控件有无数个点,这并不是唯一,所以有了抛锚点---anchorPoint,如果控件未修改anchorPoint,position默认就是中点（父控件）
 *  @param progress <#progress description#>
 */
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (progress <= 0.5) {
        self.movePoint = POINT_B;
        NSLog(@"😍😍😍😍😍😍😍B点动😍😍😍😍😍😍");
    }
    else
    {
        self.movePoint = POINT_D;
        NSLog(@"❤️❤️❤️❤️❤️❤️❤️D点动❤️❤️❤️❤️❤️❤️");
    }
    self.lastProgress = progress;
    CGFloat originX = self.position.x - outsideRectSize/2 + (progress - 0.5)*(self.frame.size.width - outsideRectSize);
    CGFloat originY = self.position.y - outsideRectSize/2;
    NSLog(@"%0.2f+++%0.2f",self.position.x,self.position.y);
    self.outsideRect = CGRectMake(originX, originY, outsideRectSize, outsideRectSize);
    [self setNeedsDisplay];
}
@end
