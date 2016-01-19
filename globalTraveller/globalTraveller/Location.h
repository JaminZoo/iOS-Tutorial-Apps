//
//  Location.h
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GTRecord.h"


@interface Location : GTRecord

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * cc;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * crossStreet;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSManagedObject *venue;

@end
