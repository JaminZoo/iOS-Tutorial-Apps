//
//  JustPostedFlickrPhotosTVC.m
//  
//
//  Created by Ben Zhu on 14/12/2015.
//
//

#import "JustPostedFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface JustPostedFlickrPhotosTVC ()

@end

@implementation JustPostedFlickrPhotosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPhotos];
}

# pragma mark - Get photos from Flickr

//Add an IBAction as a return type to allow referesh 'pull down' control to fetch photos.
- (IBAction)fetchPhotos {
    
    [self.refreshControl beginRefreshing];
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    // Create a separate queue to requeset network url from flickr api
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    // Add queue with block that fetches json data and converts to plist format
    dispatch_async(fetchQ, ^{
        // Get data from url
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        // Convert it from JSON to PLIST i.e. NSDictionary
        NSDictionary *propertyListResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults options:0 error:NULL];
        //NSLog(@"Flickr results = %@", propertyListResults);
        // Set our model (photos NSArray) to the result of getting the value and key pairs of photos.photo from the propertyListResults with our url request.
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        // dispatch the UI activity of setting photos on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
