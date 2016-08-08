//
//  AppDelegate.m
//  Huanxindemo
//
//  Created by happying on 16/8/8.
//  Copyright © 2016年 jzg. All rights reserved.
//

#import "AppDelegate.h"
#import <EMSDK.h>
#import "EaseSDKHelper.h"
#import "AppDelegate+EaseMob.h"
#import "EaseUI.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [self easemobApplication:application
                      didFinishLaunchingWithOptions:launchOptions
                                             appkey:@"douser#istore"
                                       apnsCertName:@"istore_dev"
                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"304375986-hb#taozhubao"];
    options.apnsCertName = @"happyinghu";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //注册
    EMError *error = [[EMClient sharedClient] registerWithUsername:@"8001" password:@"111111"];
    if (error==nil) {
        NSLog(@"注册成功");
    }
    //登录
//    EMError *error = [[EMClient sharedClient] loginWithUsername:@"8001" password:@"111111"];
    if (!error) {
        NSLog(@"登录成功");
        //自动登录
        [[EMClient sharedClient].options setIsAutoLogin:YES];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
   
    [[EMClient sharedClient] applicationDidEnterBackground:application];

}
// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
        [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
