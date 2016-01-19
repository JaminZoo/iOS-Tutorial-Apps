//
//  PictureDataTransformer.m
//  
//
//  Created by Ben Zhu on 11/10/2015.
//
//

#import "PictureDataTransformer.h"

@implementation PictureDataTransformer

// Determines which class to be transformed e.g. NSData or UIImage
+ (Class)transformedValueClass {
 
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
    
    // Allow the receiver to reverse a value transformation
    
    return YES;
}

// Convert UIImage to NSData and returns the data for the specified image in PNG format
- (id)transformedValue:(id)value {
    
    return UIImagePNGRepresentation(value);
}

// Reverses the conversion above and returns an image object that uses the image data created in the above instance method.
-(id)reverseTransformedValue:(id)value {
    
    UIImage *image = [UIImage imageWithData:value];

    return image;
}

@end
