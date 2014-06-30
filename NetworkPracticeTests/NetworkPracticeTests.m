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
    //NSDictionary *jsonDictionary = [network getUserWithID:14];
    dispatch_semaphore_signal(self.waitSemaphore);
    
    [self waitForSemaphoreOrSeconds:5];
    
    XCTAssertNotNil(network, @"Network think didn't return a user dictionary");
    XCTAssertEqual([network valueForKey:@"id"], @14, @"User ID returned was not correct");
}

- (void)testPost
{
    id network = [[MJVNetwork alloc] init];
    [network postNickname:@"James Baxter"];
    //XCTAssertNotNil(status, @"");
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
