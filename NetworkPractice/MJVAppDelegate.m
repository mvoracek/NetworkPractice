//
//  MJVAppDelegate.m
//  NetworkPractice
//
//  Created by Matthew Voracek on 6/25/14.
//  Copyright (c) 2014 VOKAL. All rights reserved.
//

#import "MJVNetwork.h"
#import "MJVAppDelegate.h"

@implementation MJVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MJVNetwork *network = [[MJVNetwork alloc]init];
    [network fetchUserWithId:@3 completionHandler:^(NSDictionary *user) {}];
    [network postNewUser:@"Lily" completionHandler:^(NSInteger status) {}];
    [network putNickname:@"Lily Claire" atIndex:@6 completionHandler:^(NSInteger status) {}];
    [network deleteUserWithID:@4 completionHandler:^(NSInteger status) {}];
    [network fetchAllUsers:^(NSDictionary *status) {}];
    return YES;
}



@end
