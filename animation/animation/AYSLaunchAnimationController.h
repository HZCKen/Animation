//
//  AYSLaunchAnimationController.h
//  Animation
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 AiChen smart Windows and doors technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 启动页面动画 */
@interface AYSLaunchAnimationController : UIViewController
/** 动画完成回调 */
@property (nonatomic, copy) void (^completionBlock)();
@end
