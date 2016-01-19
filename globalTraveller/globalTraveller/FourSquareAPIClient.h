//
//  FourSquareAPIClient.h
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import <AFNetworking/AFNetworking.h>

// Define global constants for base URL, client ID and secrets
extern NSString *const kFourSquareBaseURLString;



@interface FourSquareAPIClient : AFHTTPSessionManager

// AFHTTPSessionManager provides many method for making HTTP requests. AFNetworking recommends subclassing AFHTTPSessionManager for each API we intergrate into our app. Our subclass needs to return a Singleton so that all requests to the Four Square API will be processed by the same instance of AFHTTPSessionManager.

+ (instancetype)sharedClient;

@end
