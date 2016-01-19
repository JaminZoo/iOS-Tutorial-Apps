//
//  AlbumTableViewController.h
//  
//
//  Created by Ben Zhu on 10/10/2015.
//
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *albums;

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
