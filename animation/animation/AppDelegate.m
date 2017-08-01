//
//  AppDelegate.m
//  animation
//
//  Created by Apple on 2017/7/28.
//  Copyright © 2017年 AiChen smart Windows and doors technology co., LTD. All rights reserved.
//

#import "AppDelegate.h"
#import "AYSLaunchAnimationController.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    AYSLaunchAnimationController *lvc = [[AYSLaunchAnimationController alloc]init];
    __weak typeof(lvc) weakLvc = lvc;
//    [lvc setCompletionBlock:^{
//        UIImage *image = [self getNormalImage:weakLvc.view];
//        
//        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//        imageView.frame = [UIScreen mainScreen].bounds;
//        
//        [self.window addSubview:imageView];
//        
//        
//        ViewController *vc = [[ViewController alloc]init];
//        self.window.rootViewController = vc;
//        self.window.rootViewController.view.alpha = 0;
//        
//        [UIView animateWithDuration:3 animations:^{
//            self.window.rootViewController.view.alpha = 1;
//            imageView.alpha = 0;
//        } completion:^(BOOL finished) {
//            [imageView removeFromSuperview];
//        }];
//    
//    }];
    
    self.window.rootViewController = lvc;
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (UIImage *)getNormalImage:(UIView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
