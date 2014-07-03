//
//  NetworkPracticeTests.m
//  NetworkPracticeTests
//
//  Created by Matthew Voracek on 6/25/14.
//  Copyright (c) 2014 VOKAL. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MJVNetwork.h"

@interface NetworkPracticeTests : XCTestCase
@property dispatch_semaphore_t waitSemaphore;

@end

@implementation NetworkPracticeTests

- (void)setUp
{
    self.waitSemaphore = dispatch_semaphore_create(0);
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetch
{
    id network = [[MJVNetwork alloc] init];
    [network fetchUserWithId:@6 completionHandler:^(NSDictionary *dictionary) {
        NSString *name = dictionary[@"user"][@"nickname"];
        XCTAssertNotNil(dictionary, @"Network didn't return a user dictionary");
        XCTAssertEqualObjects(name, @"Lily", @"Returned wrong nickname");
        dispatch_semaphore_signal(self.waitSemaphore);
    }];
    
    [self waitForSemaphoreOrSeconds:5];
}

- (void)testPost
{
    id network = [[MJVNetwork alloc] init];
    [network postNewUser:@"James Baxter" completionHandler:^(NSInteger status) {
        NSLog(@"%ld", (long)status);
        XCTAssertEqual(201, status, @"Code is not 201");
        dispatch_semaphore_signal(self.waitSemaphore);
    }];
    
    [self waitForSemaphoreOrSeconds:5];
}

- (void)testPut
{
    id network = [[MJVNetwork alloc] init];
    [network putNickname:@"Clever Handle" atIndex:@5 completionHandler:^(NSInteger status) {
        NSLog(@"%ld", (long)status);
        XCTAssertEqual(201, status, @"Code is not 201");
        [network fetchUserWithId:@5 completionHandler:^(NSDictionary *dictionary) {
            NSString *name = dictionary[@"user"][@"nickname"];
            XCTAssertEqualObjects(name, @"Clever Handle", @"Returned wrong nickname");
            dispatch_semaphore_signal(self.waitSemaphore);
        }];
    }];
    
    [self waitForSemaphoreOrSeconds:5];
}

- (void)testDelete
{
    id network = [[MJVNetwork alloc] init];
    
    [network deleteUserWithID:@11 completionHandler:^(NSInteger status) {
        NSLog(@"%ld", (long)status);
        XCTAssertEqual(204, status, @"Code is not 204");
        [network fetchUserWithId:@11 completionHandler:^(NSDictionary *dictionary) {
            NSString *name = dictionary[@"user"][@"nickname"];
            XCTAssertNil(name, "Element was not deleted");
            dispatch_semaphore_signal(self.waitSemaphore);
        }];
    }];
    
    [self waitForSemaphoreOrSeconds:5];
}

- (void)waitForSemaphoreOrSeconds:(NSInteger)waitTimeInSeconds
{
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:waitTimeInSeconds];
    while (dispatch_semaphore_wait(self.waitSemaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        NSLog(@"waiting for response...");
        if (timeoutDate == [timeoutDate earlierDate:[NSDate date]]) {
            XCTAssertTrue(NO, @"Waiting for a response took longer than %zd seconds", waitTimeInSeconds);
            return;
        }
    }
}

@end
