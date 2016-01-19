//
//  FourSquareAPIClient.m
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import "FourSquareAPIClient.h"

// Set this to the Four Square Base URL, Client ID and Secret
NSString *const kFourSquareBaseURLString = @"https://api.foursquare.com/v2/venues/search";


@implementation FourSquareAPIClient


// use a Singleton to create a single instance of our API call to Four Square. For multiple API clients, create one Singleton for each.
+(instancetype)sharedClient {
    
    static FourSquareAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FourSquareAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kFourSquareBaseURLString]];
    });
    return _sharedClient;
}

@end
