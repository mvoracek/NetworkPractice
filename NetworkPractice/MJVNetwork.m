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
@property NSURLSession *defaultSession;

@end

@implementation MJVNetwork

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 1;
        _defaultSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (NSMutableURLRequest *)makeRequestWithURL:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    return request;
}

- (NSData *)createDataWithName:(NSString *)name
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, @"nickname", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDictionary options:0 error:nil];
    return data;
}

- (NSInteger)returnServerCodeFromResponse: (NSURLResponse *)response
{
    NSInteger status = [(NSHTTPURLResponse *)response statusCode];
    return status;
}

- (void)fetchAllUsers
{
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000"];
    NSURLSessionDataTask *task = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
            NSInteger status = [self returnServerCodeFromResponse:response];
            NSLog(@"response status: %i", status);
            if (status != 200) {
                NSLog(@"%@", @"error response");
                return;
            }
        });
    }];
    
    [task resume];
}

- (NSDictionary *)fetchUserWithID:(NSNumber *)idValue
{
    __block NSDictionary *dictionary = [[NSDictionary alloc] init];
    
    NSString *idValueUrl = [NSString stringWithFormat:@"http://localhost:5000/fetch/%@", [idValue stringValue]];
    NSMutableURLRequest *request = [self makeRequestWithURL:[NSURL URLWithString:idValueUrl]];
    NSURLSessionDataTask *task = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
            NSString *name = dictionary[@"users"];
            NSLog(@"%@", name);
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            NSInteger status = [self returnServerCodeFromResponse:response];
            NSLog(@"response status: %i", status);
            if (status != 200) {
                NSLog(@"%@", @"error response");
                return;
            }
            
        });
    }];
    
    [task resume];
    
    return dictionary;
}

- (void)postNickname:(NSString *)name
{
    NSData *jsonData = [self createDataWithName:name];
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/create"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSURLSessionUploadTask *uploadTask = [self.defaultSession  uploadTaskWithRequest:request fromData:jsonData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [uploadTask resume];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"completed");
}

- (void)putNickname:(NSString *)name atIndex:(NSNumber *)index
{
    NSData *jsonData = [self createDataWithName:name];
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/update/2"];

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSURLSessionUploadTask *uploadTask = [self.defaultSession  uploadTaskWithRequest:request fromData:jsonData];
    
    [uploadTask resume];
}

- (void)deleteData
{
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/remove/1"];
    [request setHTTPMethod:@"DELETE"];
    NSURLSessionDataTask *task = [self.defaultSession  dataTaskWithRequest:request];
    
    [task resume];
}

@end
