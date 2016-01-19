//
//  FlickrPhotosTVC.m
//  
//
//  Created by Ben Zhu on 14/12/2015.
//
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

-(void)setPhotos:(NSArray *)photos {
    
    _photos = photos;
    // Anytime photos are set, reload the data in our table view
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.photos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get the photo from our dictionary with flickr data corresponding to the index path of the table view
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

#pragma mark - Helper method to prepare image for detail VC

-(void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(NSDictionary *)photo {
    
    // Access the public property of ImageViewController to get the image url set for the photo
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];  // Set title of ImageViewController equal to the photo title of flickr request
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]){
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        if (path) {
            if ([segue.identifier isEqualToString:@"Display Photo"]){
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[path.row]];
                }
            }
        }
    }
}

#pragma mark - UITableViewDelegate

// Method that will only be executed when in a split view i.e. landscape view
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id detail = self.splitViewController.viewControllers[1];  // [1] is the Detail object within the split view property's dictionary
    // If detail is of class UINavigationController, look at its root view controller to find it
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];  // Cast pointer to UINavigationController named detail to root view controllers first object. 
    }
    if ([detail isKindOfClass:[ImageViewController class]]) {
        // Call helper method to prepare ImageViewController to display the image in our photos array
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
    }
}

@end
