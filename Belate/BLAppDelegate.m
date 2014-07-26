//
//  BLAppDelegate.m
//  Belate
//
//  Created by Hang Zhao on 7/15/14.
//  Copyright (c) 2014 FindBoat. All rights reserved.
//

#import "BLAppDelegate.h"
#import "BLLoginViewController.h"
#import "BLHangoutListViewController.h"
#import "BLUtility.h"
#import <Parse/Parse.h>

@implementation BLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init for Parse.
    [Parse setApplicationId:@"7CCK0xUiudCJaCTZc9vwsDOPXOvCtm8PsRQFeNSC"
                  clientKey:@"DD5KB441eyDCzZCXJZcF0AipYUfqVxeHcozawfuE"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Init Facebook.
    [PFFacebookUtils initializeFacebook];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [PFUser logOut];
    // Color for bar button.
    self.window.tintColor = [UIColor blackColor];
    
    PFObject *hangout = [PFObject objectWithClassName:kHangoutClassKey];
    hangout[kHangoutLocationKey] = @"Bad Ass coffee of Hawaii";
    hangout[kHangoutTimeKey] = [NSDate date];
    [hangout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *userHangout = [PFObject objectWithClassName:kUserHangoutClassKey];
            userHangout[kUserHangoutStatusKey] = kUserHangoutStatusCreate;
            userHangout[kUserHangoutUserKey] = [PFUser currentUser];
            userHangout[kUserHangoutHangoutKey] = hangout;
            [userHangout saveEventually];
        }
    }];
    
    UINavigationController *navigationController;
    if (![PFUser currentUser]) {
        BLLoginViewController *loginViewController = [BLLoginViewController new];
        navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    } else {
        [BLUtility refreshFacebookFriends];
        
        BLHangoutListViewController *hangoutListViewController = [BLHangoutListViewController new];
        navigationController = [[UINavigationController alloc] initWithRootViewController:hangoutListViewController];
    }
    
    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma - Facebook related.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

@end
