//
//  MJVAlbum.h
//  NetworkPractice
//
//  Created by Matthew Voracek on 6/25/14.
//  Copyright (c) 2014 VOKAL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJVAlbum : NSObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * year;

@property (nonatomic, retain) NSData *albumCover;

@end
