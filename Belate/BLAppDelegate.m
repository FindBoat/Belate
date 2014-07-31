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
#import "Foursquare2.h"

@implementation BLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initSDKs:launchOptions];
    
//    [PFUser logOut];
    // Color for bar button.
    self.window.tintColor = [UIColor blackColor];
    
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
    
//    
//    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//    NSDate *currentDate = [NSDate date];
//    localNotification.fireDate = [currentDate dateByAddingTimeInterval:5];;
//    localNotification.alertBody = [NSString stringWithFormat:@"You are LATE for %@!", @"Google"];
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
//    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
//
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Handle local notification.
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self application:application handleNotification:notification];
    }

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self application:application handleNotification:notification];
}

#pragma - Facebook & Foursquare related.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([[url scheme] isEqualToString:@"fb675586302528435"]) {
        return [FBAppCall handleOpenURL:url
                      sourceApplication:sourceApplication
                            withSession:[PFFacebookUtils session]];
    } else if ([[url scheme] isEqualToString:@"Belate"]) {
        return [Foursquare2 handleURL:url];
    }
    
    return NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

#pragma - ()
- (void)initSDKs:(NSDictionary *)launchOptions {
    // Init for Parse.
    [Parse setApplicationId:@"7CCK0xUiudCJaCTZc9vwsDOPXOvCtm8PsRQFeNSC"
                  clientKey:@"DD5KB441eyDCzZCXJZcF0AipYUfqVxeHcozawfuE"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Init Facebook.
    [PFFacebookUtils initializeFacebook];
    
    // Init Foursquare.
    [Foursquare2 setupFoursquareWithClientId:@"323GNBQKOPVOSTSXG2ZOFCTYOH5IRKMOBRE5R2BG2CXT3XVZ"
                                      secret:@"TA4Y1ILAU3MPWPT1UVTEKUMPZ3JHF0A4VW2MITIAN3AOPB0Q"
                                 callbackURL:@""];
}

- (void)application:(UIApplication *)application handleNotification:(UILocalNotification *)notification {
    [BLUtility showErrorAlertWithTitle:@"Oh No..." andMessage:notification.alertBody];
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hangoutLate" object:self];
}

@end
