//
//  GTRecord.m
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import "GTRecord.h"

@implementation GTRecord

+(NSString *)keyPathForResponseObject {
    
    return @"response"; // This corresponds to the foursquare API JSON associated array format, whereby response is a key value that stores the venue, location, menue, category data etc.
}

@end
