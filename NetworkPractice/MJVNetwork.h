//
//  MJVNetwork.h
//  NetworkPractice
//
//  Created by Matthew Voracek on 6/25/14.
//  Copyright (c) 2014 VOKAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJVNetwork : NSObject

- (NSInteger)returnServerCodeFromResponse: (NSURLResponse *)response;
- (void)fetchAllUsers: (void (^)(NSDictionary *))handler;
- (void)fetchUserWithId: (NSNumber *)idValue completionHandler: (void (^)(NSDictionary *))handler;
- (void)postNewUser:(NSString *)name completionHandler: (void (^)(NSInteger))handler;
- (void)putNickname:(NSString *)name atIndex:(NSNumber *)index completionHandler: (void (^)(NSInteger))handler;
- (void)deleteUserWithID:(NSNumber *)idValue completionHandler: (void (^)(NSInteger))handler;
- (void)deleteData;

@end
