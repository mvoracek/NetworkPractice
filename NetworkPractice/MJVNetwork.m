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
    return [self initWithURLProtocols:nil];
}

- (instancetype)initWithURLProtocols: (NSArray *)protocols
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 1;
        configuration.protocolClasses = protocols;
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

- (NSData *)createDataWithName:(NSString *)name email:(NSString *)email
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, @"nickname", email, @"email", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDictionary options:0 error:nil];
    return data;
}

- (NSData *)createDataWithName:(NSString *)name
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, @"nickname", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDictionary options:0 error:nil];
    return data;
}

- (NSData *)createDataWithEmail:(NSString *)email
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:userDictionary options:0 error:nil];
    return data;
}

- (NSInteger)returnServerCodeFromResponse: (NSURLResponse *)response
{
    NSInteger status = [(NSHTTPURLResponse *)response statusCode];
    return status;
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"completed");
}

- (void)fetchAllUsers: (void (^)(NSDictionary *))handler
{
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/fetch"];
    NSURLSessionDataTask *task = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dictionary;
        NSInteger status = [self returnServerCodeFromResponse:response];
        NSLog(@"response status: %i", status);
        if (status == 200) {
            NSError *jsonError = nil;
            dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&jsonError];
            NSLog(@"%@", dictionary);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(dictionary);
            }
        });
    }];
    
    [task resume];
}

- (void)fetchUserWithId: (NSNumber *)idValue completionHandler: (void (^)(NSDictionary *))handler
{
    NSString *idValueUrl = [NSString stringWithFormat:@"http://localhost:5000/fetch/%@", [idValue stringValue]];
    NSMutableURLRequest *request = [self makeRequestWithURL:idValueUrl];
    NSURLSessionDataTask *task = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dictionary;
        
        NSInteger status = [self returnServerCodeFromResponse:response];
        NSLog(@"response status: %i", status);
        if (status == 200) {
            dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
            NSLog(@"%@", dictionary);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(dictionary);
            }
        });
    }];
    
    [task resume];

}

- (void)postNewUser:(NSString *)name email:(NSString *)email completionHandler: (void (^)(NSInteger))handler
{
    NSData *jsonData = [self createDataWithName:name email:email];
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/create"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionUploadTask *uploadTask = [self.defaultSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSInteger status = [self returnServerCodeFromResponse:response];
        NSLog(@"response status: %i", status);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(status);
            }
        });
        
    }];
    
    [uploadTask resume];
}

- (void)putNickname:(NSString *)name andEmail:(NSString *)email atIndex:(NSNumber *)index completionHandler: (void (^)(NSInteger))handler
{
    NSData *jsonData = [self createDataWithName:name email:email];;
    NSString *idValueUrl = [NSString stringWithFormat:@"http://localhost:5000/update/%@", [index stringValue]];
    NSMutableURLRequest *request = [self makeRequestWithURL:idValueUrl];

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSURLSessionUploadTask *uploadTask = [self.defaultSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSInteger status = [self returnServerCodeFromResponse:response];
        NSLog(@"response status: %i", status);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(status);
            }
        });
        
    }];
    
    [uploadTask resume];
}

- (void)putNickname:(NSString *)name atIndex:(NSNumber *)index completionHandler: (void (^)(NSInteger))handler
{
    NSData *jsonData = [self createDataWithName:name];;
    NSString *idValueUrl = [NSString stringWithFormat:@"http://localhost:5000/update/%@", [index stringValue]];
    NSMutableURLRequest *request = [self makeRequestWithURL:idValueUrl];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSURLSessionUploadTask *uploadTask = [self.defaultSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSInteger status = [self returnServerCodeFromResponse:response];
        NSLog(@"response status: %i", status);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(status);
            }
        });
        
    }];
    
    [uploadTask resume];
}

- (void)putEmail:(NSString *)email atIndex:(NSNumber *)index completionHandler: (void (^)(NSInteger))handler
{
    NSData *jsonData = [self createDataWithEmail:email];;
    NSString *idValueUrl = [NSString stringWithFormat:@"http://localhost:5000/update/%@", [index stringValue]];
    NSMutableURLRequest *request = [self makeRequestWithURL:idValueUrl];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSURLSessionUploadTask *uploadTask = [self.defaultSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSInteger status = [self returnServerCodeFromResponse:response];
        NSLog(@"response status: %i", status);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(status);
            }
        });
        
    }];
    
    [uploadTask resume];
}

- (void)deleteUserWithID:(NSNumber *)idValue completionHandler: (void (^)(NSInteger))handler
{
    NSString *idValueUrl = [NSString stringWithFormat:@"http://localhost:5000/remove/%@", [idValue stringValue]];
    NSMutableURLRequest *request = [self makeRequestWithURL:idValueUrl];
    [request setHTTPMethod:@"DELETE"];

    NSURLSessionDataTask *task = [self.defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSInteger status = [self returnServerCodeFromResponse:response];
        NSLog(@"response status: %i", status);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(status);
            }
        });
    }];
    
    [task resume];
}

- (void)deleteData
{
    //delete all data needs to be created
    NSMutableURLRequest *request = [self makeRequestWithURL:@"http://localhost:5000/remove/1"];
    [request setHTTPMethod:@"DELETE"];
    NSURLSessionDataTask *task = [self.defaultSession  dataTaskWithRequest:request];
    
    [task resume];
}

@end
