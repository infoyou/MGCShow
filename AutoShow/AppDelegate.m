//
//  AppDelegate.m
//  WebviewDemo
//
//  Created by 5adian on 15/3/9.
//  Copyright (c) 2015年 Adam. All rights reserved.
//

#import "AppDelegate.h"
#import "SurveyViewController.h"
#import "LoginViewController.h"
#import "MobClick.h"
#import "GlobalConstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self regist3rd];
    
    [self showLogin];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)regist3rd
{
    // Umeng
    [MobClick startWithAppkey:UMENG_ANALYS_APP_KEY reportPolicy:SEND_INTERVAL channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
}

- (void)showLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.window addSubview:loginNav.view];
    self.window.rootViewController = loginNav;
}

- (void)showSurvey
{
    SurveyViewController *surveyVC = [[SurveyViewController alloc] init];
    UINavigationController *surveyNav = [[UINavigationController alloc] initWithRootViewController:surveyVC];
    [self.window addSubview:surveyNav.view];
    self.window.rootViewController = surveyNav;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
