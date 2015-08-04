//
//  CircleTriangleView.m
//  SqliteDemo
//
//  Created by troll on 15/8/4.
//  Copyright (c) 2015年 troll. All rights reserved.
//

#import "CircleTriangleView.h"

#define LineWidth 2
#define TopBlank 2
#define TextLayerHeight  18

@interface CircleTriangleView()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *trianglLayer;
@property (nonatomic, strong) NSTimer  *timer;
@property (nonatomic, assign) CGFloat count;
@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation CircleTriangleView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _time = 20;
        _fontColor = [UIColor lightGrayColor];
        _fontSize = 11;
        _color = [UIColor lightGrayColor];
        [self createSubLayer];
    }
    
    return self;
}

- (void)createSubLayer{
    if(_circleLayer == nil){
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.fillColor = [UIColor whiteColor].CGColor;
        _circleLayer.strokeColor = _color.CGColor;
        _circleLayer.lineWidth = LineWidth;
        [self.layer addSublayer:_circleLayer];
    }
    
    if(_trianglLayer == nil){
        _trianglLayer = [CAShapeLayer layer];
        _trianglLayer.backgroundColor = [UIColor clearColor].CGColor;
        _trianglLayer.fillColor = [UIColor lightGrayColor].CGColor;
        _trianglLayer.strokeColor = _color.CGColor;
        _trianglLayer.frame = CGRectMake((self.frame.size.width-4-LineWidth)/2.0, 0, LineWidth+4, self.frame.size.height/2.0);
        _trianglLayer.anchorPoint = CGPointMake(0.5, 1);
        _trianglLayer.position = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, 0, LineWidth+TopBlank*2);
        CGPathAddLineToPoint(path, NULL, LineWidth+4, (LineWidth+2*TopBlank)/2.0);
        CGPathAddLineToPoint(path, NULL, 0, 0);
        _trianglLayer.path = path;
        [self.layer addSublayer:_trianglLayer];
    }
    
    if(_textLayer == nil){
        _textLayer = [CATextLayer layer];
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.contentsScale = [[UIScreen mainScreen] scale];
        _textLayer.foregroundColor = _fontColor.CGColor;
        _textLayer.frame = CGRectMake(0, (self.frame.size.height-TextLayerHeight)/2.0, self.frame.size.width, TextLayerHeight);
        _textLayer.fontSize = _fontSize;
        _textLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_textLayer];
    }
}

- (void)setTime:(NSInteger)time{
    if(time > 60){
        time = 60;
    }
    
    _time = time;
    _textLayer.string = [NSString stringWithFormat:@"%.1f",(CGFloat)_time];
}

- (void)stop{
    _trianglLayer.affineTransform = CGAffineTransformRotate(_trianglLayer.affineTransform, -360/_time*(M_PI/180)*_count);
    _count = 0;
    _circleLayer.path = nil;
    _textLayer.string = [NSString stringWithFormat:@"%.1f",(CGFloat)_time];
    [_timer invalidate];
    _timer = nil;
}

- (void)pause{
    [_timer invalidate];
    _timer = nil;
}

- (void)start{
    [_timer invalidate];
    _timer = nil;
    _textLayer.string = [NSString stringWithFormat:@"%.1f",(CGFloat)_time-_count];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerEvent:) userInfo:nil repeats:YES];
}

//计时响应
- (void)timerEvent:(NSTimer *)timer{
    _trianglLayer.affineTransform = CGAffineTransformRotate(_trianglLayer.affineTransform, 360/_time*(M_PI/180)/10);
    _count += 0.1;
    [self rotationCircleLayer];
    _textLayer.string = [NSString stringWithFormat:@"%.1f",_time-_count];
}


//圆圈路径动画
- (void)rotationCircleLayer{
    if(_count > _time){
        [self stop];
        return;
    }
    
    CGMutablePathRef path = [self createPathFromDegree:-M_PI_2-360/_time*(M_PI/180)*0.5 toDegree:(-M_PI_2)+(360/_time*(M_PI/180)*_count)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = (__bridge id)(_circleLayer.path);
    animation.toValue = (__bridge id)(path);
    animation.duration = 0.0001;
    [_circleLayer addAnimation:animation forKey:nil];
    _circleLayer.path = path;
}

//创建圆圈路径
- (CGMutablePathRef)createPathFromDegree:(CGFloat)startDegree toDegree:(CGFloat)endDegree{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.height/2-TopBlank-LineWidth/2, startDegree, endDegree, NO);
    
    return path;
}

@end
