//
//  ViewController.m
//  JFAnimation
//
//  Created by huangpengfei on 2018/6/8.
//  Copyright © 2018年 huangpengfei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CAAnimationDelegate>
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, copy) NSArray *leftButtonNames;
@property (nonatomic, copy) NSArray *optionsButtonNames;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftButtonNames = [NSArray arrayWithObjects:@"位移",@"缩放",@"透明度",@"旋转",@"圆角",@"晃动",@"位移",@"动画组", nil];
    self.optionsButtonNames = [NSArray arrayWithObjects:@"暂停",@"继续",@"停止", nil];
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = self.view.center;
    layer.backgroundColor = [UIColor redColor].CGColor;
    self.layer = layer;
    [self.view.layer addSublayer:layer];
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.link .frameInterval = 30;
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    for (int i = 0; i < self.leftButtonNames.count; i++) {
        UIButton *aniButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aniButton.tag = i;
        [aniButton setTitle:self.leftButtonNames[i] forState:UIControlStateNormal];
        aniButton.exclusiveTouch = YES;
        aniButton.frame = CGRectMake(10, 50 + 60 * i, 100, 50);
        aniButton.backgroundColor = [UIColor blueColor];
        [aniButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aniButton];
    }
    
    for (int i = 0; i < self.optionsButtonNames.count; i++) {
        UIButton *aniButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aniButton.tag = i;
        [aniButton setTitle:self.optionsButtonNames[i] forState:UIControlStateNormal];
        aniButton.exclusiveTouch = YES;
        aniButton.frame = CGRectMake(150, 50 + 60 * i, 100, 50);
        aniButton.backgroundColor = [UIColor blueColor];
        [aniButton addTarget:self action:@selector(optionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:aniButton];
    }
}

//动画组
-(void)animationGroup{
    //晃动动画
    CAKeyframeAnimation *keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    keyFrameAni.values = @[@(-(4) / 180.0*M_PI),@((4) / 180.0*M_PI),@(-(4) / 180.0*M_PI)];
    //每一个动画可以单独设置时间和重复次数,在动画组的时间基础上,控制单动画的效果
    keyFrameAni.duration = 0.3;
    keyFrameAni.repeatCount=MAXFLOAT;
    keyFrameAni.delegate = self;
    //
    //位移动画
    CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"position"];
    //到达位置
    basicAni.byValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
    //
    basicAni.duration = 1;
    basicAni.repeatCount = 1;
    //
    basicAni.removedOnCompletion = NO;
    basicAni.fillMode = kCAFillModeForwards;
    //设置代理
    basicAni.delegate = self;
    //动画时间
    basicAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = @[keyFrameAni,basicAni];
    aniGroup.autoreverses = YES;
    //动画的表现时间和重复次数由动画组设置的决定
    aniGroup.duration = 3;
    aniGroup.repeatCount=MAXFLOAT;
    //
    [self.layer addAnimation:aniGroup forKey:@"groupAnimation"];
}


- (void)tapAction:(UIButton *)sender{
    [self basicAnimationWithTag:sender.tag];
}

- (void)optionBtnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            [self animationPause];
            break;
        case 1:
            [self animationResume];
            break;
        case 2:
            [self animationStop];
            break;
        default:
            break;
    }
    
}

-(void)basicAnimationWithTag:(NSInteger)tag{
    CABasicAnimation *basicAni = nil;
    switch (tag) {
        case 0:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"position"];
            //到达位置
            basicAni.byValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
            break;
        case 1:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            //到达缩放
            basicAni.toValue = @(0.1f);
            break;
        case 2:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
            //透明度
            basicAni.toValue=@(0.1f);
            break;
        case 3:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"transform"];
            //3D
            basicAni.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2+M_PI_4, 1, 1, 0)];
            break;
        case 4:
            //初始化动画并设置keyPath
            basicAni = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            //圆角
            basicAni.toValue=@(50);
            break;
        case 7:
            [self animationGroup];
        break;
        default:
            [self keyframeAnimationWithTag:tag];
            break;
    }
    
    //设置代理
    basicAni.delegate = self;
    //延时执行
    //basicAni.beginTime = CACurrentMediaTime() + 2;
    //动画时间
    basicAni.duration = 1;
    //动画节奏
    basicAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画速率
    //basicAni.speed = 0.1;
    //图层是否显示执行后的动画执行后的位置以及状态
    //basicAni.removedOnCompletion = NO;
    //basicAni.fillMode = kCAFillModeForwards;
    //动画完成后是否以动画形式回到初始值
    basicAni.autoreverses = YES;
    //动画时间偏移
    //basicAni.timeOffset = 0.5;
    //添加动画
    [self.layer addAnimation:basicAni forKey:NSStringFromSelector(_cmd)];
}

//关键帧动画
-(void)keyframeAnimationWithTag:(NSInteger)tag{
    CAKeyframeAnimation *keyFrameAni = nil;
    if (tag == 5) {
        //晃动
        keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        keyFrameAni.duration = 0.3;
        keyFrameAni.values = @[@(-(4) / 180.0*M_PI),@((4) / 180.0*M_PI),@(-(4) / 180.0*M_PI)];
        keyFrameAni.repeatCount=MAXFLOAT;
    }else if (tag == 6){
        //曲线位移
        keyFrameAni = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:self.layer.position];
        [path addCurveToPoint:CGPointMake(300, 500) controlPoint1:CGPointMake(100, 400) controlPoint2:CGPointMake(300, 450)];
        keyFrameAni.path = path.CGPath;
        keyFrameAni.duration = 1;
    }
    [self.layer addAnimation:keyFrameAni forKey:@"keyFrameAnimation"];
}


- (void)handleDisplayLink:(CADisplayLink *)displayLink{
    NSLog(@"modelLayer_%@,presentLayer_%@",[NSValue valueWithCGPoint:self.layer.position],[NSValue valueWithCGPoint:self.layer.presentationLayer.position]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint position = [touches.anyObject locationInView:self.view];
    self.currentPoint = position;
    [self addAnimateWithPosition:position];
}

- (void)addAnimateWithPosition:(CGPoint)point{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    basicAnimation.toValue = [NSValue valueWithCGPoint:point]; // 目标位置
    basicAnimation.duration = 1.f;  // 动画执行时间
    basicAnimation.speed = 1.0f; // 速度
//    basicAnimation.timeOffset = 0.2f; // 动画偏移量
    basicAnimation.delegate = self;
    // 动画执行方式
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 禁止动画结束之后 视图闪动
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    // 结束后回到原点
//    basicAnimation.autoreverses = YES;
    [self.layer addAnimation:basicAnimation forKey:NSStringFromSelector(_cmd)];
    NSLog(@"ss");
}

//暂停动画
-(void)animationPause{
    //获取当前layer的动画媒体时间
    CFTimeInterval interval = [self.layer convertTime:CACurrentMediaTime() toLayer:nil];
    //设置时间偏移量,保证停留在当前位置
    self.layer.timeOffset = interval;
    //暂定动画
    self.layer.speed = 0;
}
//恢复动画
-(void)animationResume{
    //获取暂停的时间
    CFTimeInterval beginTime = CACurrentMediaTime() - self.layer.timeOffset;
    //设置偏移量
    self.layer.timeOffset = 0;
    //设置开始时间
    self.layer.beginTime = beginTime;
    //开始动画
    self.layer.speed = 1;
}
//停止动画
-(void)animationStop{
    //[_aniLayer removeAllAnimations];
    //[_aniLayer removeAnimationForKey:@"groupAnimation"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"");
    [anim setValue:[NSValue valueWithCGPoint:self.currentPoint] forKey:@"positionToEnd"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"");
    
    // 对于非根图层，设置它的可动画属性有隐式动画的,需要关闭它
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.layer.position = [[anim valueForKey:@"positionToEnd"] CGPointValue];
//    [CATransaction commit];
}

@end


