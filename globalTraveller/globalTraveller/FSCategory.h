//
//  FSCategory.h
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GTRecord.h"

@interface FSCategory : GTRecord

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *venue;

@end
