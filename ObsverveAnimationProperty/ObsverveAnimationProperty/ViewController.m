//
//  ViewController.m
//  ObsverveAnimationProperty
//
//  Created by xiaomanwang on 14-3-7.
//  Copyright (c) 2014年 xiaomanwang. All rights reserved.
//

#import "ViewController.h"

static const int duration = 2;

@interface ViewController ()

@property(nonatomic, strong)UIView*viewForAnimated;
@property(nonatomic, strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _viewForAnimated = [UIView new];
    _viewForAnimated.backgroundColor = [UIColor redColor];
    _viewForAnimated.frame = CGRectMake(20, 20, 100,100);
    [self.view addSubview:_viewForAnimated];

    _viewForAnimated.layer.delegate = self;
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"do" forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(200, 100, 40, 30);
    [btn addTarget:self action:@selector(doAnimation) forControlEvents:UIControlEventTouchUpInside];
    
//    [self addObserver:self forKeyPath:@"viewForAnimated.frame" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"viewForAnimated.layer.presentationLayer.position" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"viewForAnimated.layer.presentationLayer.bounds" options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //这里观察的presentationlayer没有东西，观察不到,动画的时候的presentationlayer是临时创建的
    NSLog(@"change:%@",change);
}

- (void)doAnimation
{
    self.timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(getPos) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    CGRect frame = _viewForAnimated.frame;
    if(_viewForAnimated.frame.origin.y >= 250.0)
    {
        frame.origin.y = 20;
    }
    else
    {
        frame.origin.y = 250;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _viewForAnimated.frame = frame;
        
    } completion:^(BOOL finished) {
        [self performSelector:@selector(stopTimer) withObject:nil afterDelay:duration];
    }];
}

- (void)stopTimer
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)getPos
{
    NSLog(@"current pos%@",NSStringFromCGPoint([[_viewForAnimated.layer presentationLayer] position]));
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    NSLog(@"view.layer:%@",_viewForAnimated.layer);
    NSLog(@"view.layer.presentationLayer:%@",_viewForAnimated.layer.presentationLayer);
    //这里观察到的event是position
    NSLog(@"layer:%@:event:%@",layer, event);
    return nil;
}

@end
