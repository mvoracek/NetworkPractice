//
//  MJVMockDataProtocol.m
//  NetworkPractice
//
//  Created by Matthew Voracek on 7/3/14.
//  Copyright (c) 2014 VOKAL. All rights reserved.
//

#import "MJVMockDataProtocol.h"

@implementation MJVMockDataProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return YES;
}

- (void)stopLoading
{
    
}

- (void)startLoading
{
    NSLog(@"serving mock data from disk");
    
    NSString *endOfPath = [self.request.URL.pathComponents lastObject];
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:endOfPath ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

@end
