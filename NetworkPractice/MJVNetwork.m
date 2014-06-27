//
//  MJVNetwork.m
//  NetworkPractice
//
//  Created by Matthew Voracek on 6/25/14.
//  Copyright (c) 2014 VOKAL. All rights reserved.
//

#import "MJVNetwork.h"
#import "MJVAlbum.h"

@interface MJVNetwork() <NSURLSessionDelegate, NSURLSessionTaskDelegate>

@end

@implementation MJVNetwork

-(NSURLSession *)configSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPMaximumConnectionsPerHost = 1;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    return session;
}

-(NSMutableURLRequest *)makeRequestWithURL:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    return request;
}

- (void)fetch
{
    NSURLSession *session = [self configSession];
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:nil];
            NSString *name = dictionary[@"users"];
            NSLog(@"%@", name);
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            NSInteger status = [(NSHTTPURLResponse*)response statusCode];
            NSLog(@"response status: %i", status);
            if (status != 200) {
                NSLog(@"%@", @"error response");
                return;
            }
        });
    }];
    
    [task resume];
}

- (void)postNickname:(NSString *)name
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, @"nickname", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:0 error:nil];
    
    NSURLSession *session = [self configSession];
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/create"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:jsonData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [uploadTask resume];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"completed");
}

- (void)putNickname:(NSString *)name atIndex:(NSNumber *)index
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, @"nickname", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSURLSession *session = [self configSession];
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/update/2"];

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:jsonData];
    
    [uploadTask resume];
}

- (void)deleteData
{
    NSURLSession *session = [self configSession];
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/remove/1"];
    [request setHTTPMethod:@"DELETE"];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    [task resume];
}

@end
