//
//  AppDelegate.m
//  MADContest
//
//  Created by JingFeng Ma on 2020/2/18.
//  Copyright © 2020 JingFeng Ma. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //config AFNetworking
    AFNetworkConfig *config = [AFNetworkConfig shareAFNetWorkConfig];
    config.AFManager = [AFHTTPSessionManager manager];
    config.requestSerializer = [AFJSONRequestSerializer serializer];
    config.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [config.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [config.requestSerializer setValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [config.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    config.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
//    [config.requestSerializer setValue:[UserCenter getUserValueForKey:@"token"] forHTTPHeaderField:@"token"];
//    [config.requestSerializer setValue:[UserCenter getUserValueForKey:@"uid"] forHTTPHeaderField:@"uid"];
    [config.requestSerializer setValue:@"ios" forHTTPHeaderField:@"plat"];
//    [config.requestSerializer setValue:@"360" forHTTPHeaderField:@"platinfo"];
//    [config.requestSerializer setValue:@"5.0.0" forHTTPHeaderField:@"version"];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
