//
//  Contact.h
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GTRecord.h"

@interface Contact : GTRecord

@property (nonatomic, retain) NSString * formattedPhone;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSManagedObject *venue;

@end
