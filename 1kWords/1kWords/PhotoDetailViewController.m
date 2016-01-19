//
//  PhotoDetailViewController.m
//
//
//  Created by Ben Zhu on 14/10/2015.
//
//

#import "PhotoDetailViewController.h"
#import "Photo.h"
#import "FilterCollectionViewController.h"

@interface PhotoDetailViewController ()

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Since viewDidLoad only occurs once i.e. it is called when the view is loaded initially but never again, we need to implement viewWillAppear to allow for any changes to the image view
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.imageView.image = self.photo.image;
}

#pragma mark - IBAction

- (IBAction)addFilterButtonPressed:(UIButton *)sender {
    
    //NSLog(@"button was pressed");
}


- (IBAction)deleteButtonPressed:(UIButton *)sender {
    
    // Get the managedObjectContext for the photo entity and send it the deleteObject message.
    [[self.photo managedObjectContext] deleteObject:self.photo];
    
    // Must call 'save' after this deletion for it to be updated in our data base. However, when deploying to your actual device (and not the simulator) you do not need to use this save method.
    
    NSError *error = nil;
    [[self.photo managedObjectContext] save: &error];
    
    if (error) {
        NSLog(@"error");
    }
    // Pop the navigation view controller off the stack after being pushed by segue
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Filter Segue"]) {
        if ([segue.destinationViewController isKindOfClass:[FilterCollectionViewController class]]) {
            FilterCollectionViewController *filterViewController = segue.destinationViewController;
            filterViewController.photo = self.photo;
        }
    }
}
@end
