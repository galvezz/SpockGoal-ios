//
//  ASAppDelegate.m
//  SpockGoal
//
//  Created by Alan Sparrow on 1/7/14.
//  Copyright (c) 2014 Alan Sparrow. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASMainViewController.h"
#import "ASGoalStore.h"
#import "ASTimeProcess.h"

#define ASLog(...) NSLog(__VA_ARGS__)

@implementation ASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Create a MainViewController
    ASMainViewController *mainViewController = [[ASMainViewController alloc] init];
    
    // Create an instance of a UINavigationController
    // its stack contains only mainViewController
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:mainViewController];
    
    // Place MainViewController's table view in the window hierarchy
    [[self window] setRootViewController:navController];
    
    // Reset all alarm
    [self resetAllAlarm];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)resetAllAlarm
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    ASTimeProcess *timeProcess = [[ASTimeProcess alloc] init];
    NSArray *allGoals = [[ASGoalStore sharedStore] allGoals];
    
    for (ASGoal *g in allGoals) {
        [timeProcess setAlarmForGoal:g];
    }
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
    
    BOOL success = [[ASGoalStore sharedStore] saveChanges];
    if (success) {
        ASLog(@"Saved all of the ASGoal");
    } else {
        ASLog(@"Could not save any of the ASGoal");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"SpockGoal"
                              message:[[notification userInfo] valueForKey:@"message"]
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

@end
