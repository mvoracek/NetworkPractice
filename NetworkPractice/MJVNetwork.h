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
- (void)fetchAllUsers;
- (NSDictionary *)fetchUserWithID:(NSNumber *)idValue;
- (void)postNickname:(NSString *)name;
- (void)putNickname:(NSString *)name atIndex:(NSNumber *)number;
- (void)deleteData;

@end
