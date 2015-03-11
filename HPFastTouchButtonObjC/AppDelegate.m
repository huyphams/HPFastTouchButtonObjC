//
//  AppDelegate.m
//  HPFastTouchButtonObjC
//
//  Created by Huy Pham on 3/11/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]];
    [self.window setRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
