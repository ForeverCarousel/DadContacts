//
//  AppDelegate.m
//  Contacts
//
//  Created by chenxiaolong on 2020/3/12.
//  Copyright © 2020 chenxiaolong. All rights reserved.
//

#import "AppDelegate.h"
#import "XLRootViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    XLRootViewController* rootViewController = [[XLRootViewController alloc] initWithNibName:@"XLRootViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}



@end
