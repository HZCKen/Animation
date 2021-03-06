//
//  AYSLaunchAnimationController.m
//  Animation
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 AiChen smart Windows and doors technology co., LTD. All rights reserved.
//

#import "AYSLaunchAnimationController.h"
#import <POP.h>
#import "ViewController.h"
#import "AYSAnimationDelegate.h"

@interface AYSLaunchAnimationController ()
/** 云 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/** 4个图片组 */
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
/** 遮盖组 */
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *coverViews;
/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
/** 宣言 */
@property (weak, nonatomic) IBOutlet UILabel *purposeLable;
/** 动画代理 */
@property (nonatomic, strong) AYSAnimationDelegate *animationDelegate;
/** nameLayer */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** purposeLayer */
@property (nonatomic, strong) CAGradientLayer *purposeGradientLayer;

/** 云朵动画 */
@property (nonatomic, strong) CABasicAnimation *iconAnimation;

@end

@implementation AYSLaunchAnimationController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self startAnimation];
}

- (void)setupUI {
    self.iconImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.appNameLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.purposeLable.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.appNameLabel.hidden = YES;
    self.purposeLable.hidden = YES;
}

/** 开始动画 */
- (void)startAnimation {
    [UIView animateWithDuration:1.0 animations:^{
        self.iconImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self imageViewsBeginAnimation];
    }];
}

/** 图片组合动画 */
- (void)imageViewsBeginAnimation {
    __weak typeof(self) weakSelf = self;
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        animation.toValue = @(obj.center.y);
        animation.fromValue = @(obj.center.y + 500);
        animation.springBounciness = 8;
        animation.springSpeed = 8;
        animation.beginTime = CACurrentMediaTime() + idx * 0.3;
        obj.hidden = NO;
        [obj pop_addAnimation:animation forKey:@"spring"];
        
        animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            UIView *coverView = self.coverViews[idx];
            coverView.alpha = 0;
            
            if (idx == self.imageViews.count - 1) {
                [weakSelf iconImageViewAndLabelBeginAnimation];
            }
            
        };
    }];
}

/** 云朵和文字动画 */
- (void)iconImageViewAndLabelBeginAnimation {
    [UIView animateWithDuration:1.0 animations:^{
        self.appNameLabel.transform = CGAffineTransformIdentity;
        self.purposeLable.transform = CGAffineTransformIdentity;
    }];
    [self.iconImageView.layer addAnimation:self.iconAnimation forKey:@"iconAnimation"];
    
    self.appNameLabel.hidden = NO;
    self.appNameLabel.layer.mask = self.gradientLayer;
    self.purposeLable.hidden = NO;
    self.purposeLable.layer.mask = self.purposeGradientLayer;
}

- (CABasicAnimation *)iconAnimation {
    if (!_iconAnimation) {
        _iconAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。闪烁效果
        _iconAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        _iconAnimation.toValue = [NSNumber numberWithFloat:0.3f];//这是透明度。
        _iconAnimation.autoreverses = YES;
        _iconAnimation.duration = 0.6;
        _iconAnimation.repeatCount = 2;
        _iconAnimation.removedOnCompletion = NO;
        _iconAnimation.fillMode = kCAFillModeForwards;
        _iconAnimation.delegate = self.animationDelegate;
        _iconAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    }
    return _iconAnimation;
}


- (AYSAnimationDelegate *)animationDelegate {
    __weak  typeof(self) weakSelf = self;
    if (!_animationDelegate) {
        _animationDelegate = [[AYSAnimationDelegate alloc]init];
        [_animationDelegate setCompleteBlock:^(CAAnimation *anim,BOOL flag){
            if ([anim isEqual:[weakSelf.appNameLabel.layer.mask animationForKey:@"launchNameLabelAnimation"]]) {
                NSLog(@"launchNameLabelAnimation finished");
                weakSelf.appNameLabel.layer.mask = nil;
           
            } else if ([anim isEqual:[weakSelf.purposeLable.layer.mask animationForKey:@"launchPurposeLabelAnimation"]]) {
                NSLog(@"launchPurposeLabelAnimation finished");
                weakSelf.purposeLable.layer.mask = nil;
                
            } else if ([anim isEqual:[weakSelf.iconImageView.layer animationForKey:@"iconAnimation"]]) {
                NSLog(@"iconAnimation finished");
                if (weakSelf.completionBlock) {
                    weakSelf.completionBlock();
                }
            }
        }];
    }
    return _animationDelegate;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.appNameLabel.bounds;
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.locations = @[@(0.0), @(0.0), @(0.3)];
        _gradientLayer.colors = @[(__bridge id)[[UIColor greenColor] colorWithAlphaComponent:0.3].CGColor,
                                  (__bridge id)[UIColor yellowColor].CGColor,
                                  (__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.3].CGColor];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
        animation.duration = 2.0f;
        animation.toValue = @[@(1.0), @(1.0), @(1.0)];
        animation.removedOnCompletion = NO;
        animation.repeatCount = 0;
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self.animationDelegate;
        [_gradientLayer addAnimation:animation forKey:@"launchNameLabelAnimation"];
        
    }
    return _gradientLayer;
}

- (CAGradientLayer *)purposeGradientLayer {
    if (!_purposeGradientLayer) {
        _purposeGradientLayer = [CAGradientLayer layer];
        _purposeGradientLayer.frame = self.purposeLable.bounds;
        _purposeGradientLayer.startPoint = CGPointMake(0, 0);
        _purposeGradientLayer.endPoint = CGPointMake(1, 0);
        _purposeGradientLayer.locations = @[@(0.0), @(0.0), @(0.3)];
        _purposeGradientLayer.colors = @[(__bridge id)[[UIColor greenColor] colorWithAlphaComponent:0.3].CGColor,
                                         (__bridge id)[UIColor yellowColor].CGColor,
                                         (__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.3].CGColor];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
        animation.duration = 2.0f;
        animation.toValue = @[@(1.0), @(1.0), @(1.0)];
        animation.removedOnCompletion = NO;
        animation.repeatCount = 0;
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.delegate = self.animationDelegate;
        [_purposeGradientLayer addAnimation:animation forKey:@"launchPurposeLabelAnimation"];
    }
    return _purposeGradientLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
