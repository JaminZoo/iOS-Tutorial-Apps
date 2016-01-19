//
//  CoreDataHelper.m
//  
//
//  Created by Ben Zhu on 10/10/2015.
//
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    // Test that the delegate variable exists and that we can call the method (managedObjectContext) on it. 
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

@end
