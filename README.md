# LPDrawCircleAnimationDemo
*通过layer层实时重绘
*重要属性:progress,改变该值从而影响context(上下文),API:
- (void)drawInContext:(CGContextRef)ctx

*通过各个点坐标计算(只要你肯动笔,不难推导),然后利用画虚线方法:
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
    CGContextStrokePath(ctx);
    
    *此Demo重点在于学习和了解UIView和CALayer之间的关系
    *position 和 anchorPoint的使用
