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
    [network postNickname:@"Lily"];
    [network putNickname:@"Mami Chula" atIndex:@2];
    [network deleteData];
    [network fetch];
    return YES;
}



@end
