//
//  Venue.h
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GTRecord.h"

@class Contact, FSCategory, Location, Menu;

@interface Venue : GTRecord

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) FSCategory *categories;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) Menu *menu;

@end
