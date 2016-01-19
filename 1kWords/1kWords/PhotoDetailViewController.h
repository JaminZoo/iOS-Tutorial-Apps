//
//  PhotoDetailViewController.h
//  
//
//  Created by Ben Zhu on 14/10/2015.
//
//

#import <UIKit/UIKit.h>

// Forward header declaration that is simpler than importing Photo
@class Photo;

@interface PhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addFilterButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;


@end
