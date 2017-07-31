//
//  AYSAnimationDelegate.m
//  animation
//
//  Created by Apple on 2017/7/31.
//  Copyright © 2017年 AiChen smart Windows and doors technology co., LTD. All rights reserved.
//

#import "AYSAnimationDelegate.h"

@implementation AYSAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"Animation Start");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"Animation Stop");
    
    if (self.completeBlock) {
        self.completeBlock(anim,flag);
    }
}

- (void)dealloc
{
    NSLog(@"Delegate Dealloc");
}



@end
