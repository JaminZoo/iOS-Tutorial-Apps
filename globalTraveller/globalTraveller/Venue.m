//
//  Venue.m
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import "Venue.h"
#import "Contact.h"
#import "FSCategory.h"
#import "Menu.h"
#import "Location.h"


@implementation Venue

@dynamic id;
@dynamic name;
@dynamic categories;
@dynamic contact;
@dynamic location;
@dynamic menu;

// Override the MMRecord class method declared in our Record class in order to begin at the 'response' key in four square's JSON array (rather than the meta key). This effecitvely creates our venue object using four squares API
+(NSString *)keyPathForResponseObject {
    
    return @"response.venue";
}



@end
