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

- (void)fetch
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"http://localhost:5000"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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

- (void)post
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Lily", @"nickname", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:0 error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",jsonString);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *uploadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:5000/create"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSURLSessionUploadTask *uploadTask = [uploadSession uploadTaskWithRequest:request fromData:jsonData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [uploadTask resume];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"completed");
}

- (void)put
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Mami Chula", @"nickname", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",jsonString);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *uploadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:5000/update/2"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSURLSessionUploadTask *uploadTask = [uploadSession uploadTaskWithRequest:request fromData:jsonData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [uploadTask resume];
}

- (void)deleteData
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"http://localhost:5000/remove/1"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    
    [task resume];
}

@end
