//
//  Menu.h
//  
//
//  Created by Ben Zhu on 23/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GTRecord.h"


@interface Menu : GTRecord

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSManagedObject *venue;

@end
