//
//  PhotosCollectionViewController.m
//  
//
//  Created by Ben Zhu on 11/10/2015.
//
//

#import "PhotosCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "PictureDataTransformer.h"
#import "CoreDataHelper.h"
#import "PhotoDetailViewController.h"

@interface PhotosCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation PhotosCollectionViewController

#pragma mark - Lazy Instantiation

- (NSMutableArray *)photos {
    
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

//static NSString * const reuseIdentifier = @"Photo Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    // Query core data to get back all the photos for a specific album at time of view being loaded. The photos will be stored as an unordered NSSet, then we will order the photos using NSSortDescriptor according to the date.
    NSSet *unorderedPhotos = self.album.photos;
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"Date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];  // Transform NSArray to NSMutableArray of which is the type for the photos property.
    
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Detail Segue"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoDetailViewController class]]) {
            PhotoDetailViewController *detailViewController = segue.destinationViewController;
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
            Photo *selectedPhoto = self.photos[indexPath.row];
            detailViewController.photo = selectedPhoto;
        }
    }
}


#pragma mark - Helper Methods

// Saves the photo into the database
- (Photo *)photoFromImage: (UIImage *)image {
    // Create a new managed object named 'photo'
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[CoreDataHelper managedObjectContext]];
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    
    NSError *error = nil;
    if (![[photo managedObjectContext] save:&error]) {
        // Take care of the error
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    return photo;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.photos count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Photo Cell";
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = photo.image;
    
    return cell;
}

#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // The dictionary named 'info' contains both the image data and metadata. An image object will be assigned to this dictionary as an edited or original depending on the users actions.
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    [self.photos addObject:[self photoFromImage:image]];
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Cancel photo saving to core data database
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    // If the image picker source type is camera, then
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:	nil];
    
}
@end
