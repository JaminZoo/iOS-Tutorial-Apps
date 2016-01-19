//
//  ImageViewController.m
//  
//
//  Created by Ben Zhu on 12/12/2015.
//
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;// instance variable is not used to get the property of this image
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *downloadActivityIndicator;
@end

@implementation ImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add UIImageView to the ImageViewController's view
    [self.view addSubview:self.imageView];
    // Add the UIImageView as a subview to the UIScrollView
    [self.imageScrollView addSubview:self.imageView];
    
}

#pragma mark - Custom setter for scroll view

-(void)setImageScrollView:(UIScrollView *)imageScrollView {
    
    _imageScrollView = imageScrollView;
    // Must implement this twice (once in the setImage method) because setImageScrollView might be set after the setImage method is implemented. setImage happens because of setimageURL (which happens in prepare for segue), but since prepare for segue performs BEFORE any outlets are set, the contentSize property of the scroll view in setImage will be nil (due to setImageScrollView not being set yet).
    self.imageScrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    
    // Implement delegate method to allow zooming of image in scroll view
    _imageScrollView.minimumZoomScale = 0.2;
    _imageScrollView.maximumZoomScale  = 2.0;
    _imageScrollView.delegate = self;  // Declare ImageViewController as conforming to the UIScrollViewDelegate protocol.
    
}

#pragma mark - UIScrollViewDelegate method

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}

#pragma mark - Lazy instantiation of UIImageView

- (UIImageView *)imageView {
    
    if (!_imageView) _imageView = [[UIImageView alloc] init];
    
    return _imageView;
}

#pragma mark - Custom image getter and setter
// No @synthesize required for UIImage *image because _image is never used in our getter and setter. It is being defined in terms of another object, so compiler does not need to 'see' @synthesize in order to create the getter and setter for accessing this property. 

- (UIImage *)image {
    
    return self.imageView.image;
}

// Custom method that allows us to set up our image. 
- (void)setImage:(UIImage *)image {
    
    self.imageScrollView.zoomScale = 1.0;  // Reset scroll view's zoom to 1.0 every time image is set
    self.imageView.image = image;  // Does not change the frame of the UIImageView
    //[self.imageView sizeToFit];    // Update the UIImageView's frame to fit the UIImage
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    // Set the content size of the scroll view to be equal to that of the image size.
    self.imageScrollView.contentSize = self.image ? self.image.size : CGSizeZero;  // Protect from returning a nil value for image size by implementing simple ternary check.
    [self.downloadActivityIndicator stopAnimating];  // Stop spinner animation when image is set. 
}

#pragma mark - Image URL custom setter

// Set the UIImage property image to the data contained within the imageURL property.
-(void)setImageURL:(NSURL *)imageURL {
    
    _imageURL = imageURL;
    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];  // imageWithData method might block the main queue (as it tries to return the data from the image URL), so this is a good place to dispatch a separate queue to handle this url request.
    // Use the following startDownloadingImage method when setting image url property that will allow main queue to be free from non UI activities
    [self startDownloadingingImage];
}

#pragma mark - Perform image download off of main queue

-(void)startDownloadingingImage {
    
    // First, set image to be nil when download is in progress.
    self.image = nil;
    // If an image url exists, create a URL session to handle downloading of image from target url
    if (self.imageURL) {
        [self.downloadActivityIndicator startAnimating]; // When image url starts downloading, animate activity spinner.
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        // Configure the session when the url is being requested. Ephemeral session is used for a single image download
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        //Create download task using session and with a call back on a different i.e. not main queue when delegate is not used
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
            completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
                if (!error) {
                    // If imageURL is changed, check if the requested url is the same as our imageURL defined in ViewController.m. When multi-tasking, we need to be cognisant of what happens if our request takes a long time and to make sure the state that it was initiated under remains the same when it is finished.
                    if ([request.URL isEqual:self.imageURL]) {
                        // Set our UIImage to the downloaded image from the url
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];  // imageWithData now does not block the main queue since it is accessing a local file OFF the main queue. UIImage is one of the few UIKit classes where you can access off the main queue.
                        dispatch_async(dispatch_get_main_queue(), ^{self.image = image;});
                        // The image is executed on the main thread/queue since it is doing a lot of UI related tasks.
                    }
                }
            }];
        [task resume];  // if not called, task will sit around unused. 
    }
}

#pragma mark - UISplitViewControllerDelegate

-(void)awakeFromNib {
    
    self.splitViewController.delegate = self;
}

// Method that hides the split view when device is in portrait orientation.
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    
    return UIInterfaceOrientationIsPortrait(orientation);
}

// Hide split view and add a pop over view when in portrait orientation
-(void)splitViewController:(UISplitViewController *)svc
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)pc {
    
    // set bar button item equal to the title from the Master split view's table view cell title
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

// Unhide split view when in landscape orientation and hide bar button item.
-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // set bar button equal to nil when master split view is visible i.e. in landscape orientation.
    self.navigationItem.leftBarButtonItem = nil;
    
}
@end
