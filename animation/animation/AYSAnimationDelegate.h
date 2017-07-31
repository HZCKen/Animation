//
//  AYSAnimationDelegate.h
//  animation
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 AiChen smart Windows and doors technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 动画代理类 防止使用CABaseAnimation代理时产生的循环引用 */
@interface AYSAnimationDelegate : NSObject<CAAnimationDelegate>

/** 动画完成回调 */
@property (nonatomic, copy) void (^completeBlock)(CAAnimation *,BOOL flag);

- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
@end
