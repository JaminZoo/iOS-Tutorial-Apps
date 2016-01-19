//
//  ViewController.h
//  globalTraveller
//
//  Created by Ben Zhu on 20/10/2015.
//  Copyright (c) 2015 Ben Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kCLIENTID;
extern NSString *const kCLIENTSECRET;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)refreshBarButtonItemPressed:(UIBarButtonItem *)sender;

@end

