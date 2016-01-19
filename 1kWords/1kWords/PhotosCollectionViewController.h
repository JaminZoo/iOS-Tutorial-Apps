//
//  PhotosCollectionViewController.h
//  
//
//  Created by Ben Zhu on 11/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface PhotosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Album *album;

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
