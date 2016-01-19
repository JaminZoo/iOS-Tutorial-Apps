//
//  FilterCollectionViewController.m
//  
//
//  Created by Ben Zhu on 14/10/2015.
//
//

#import "FilterCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"

@interface FilterCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context;

@end

@implementation FilterCollectionViewController

//static NSString * const reuseIdentifier = @"Photo Cell";


#pragma mark - Lazy Instantiation

- (NSMutableArray *)filters {
    
    if (!_filters) _filters = [[NSMutableArray alloc] init];
    
    return _filters;
}

// This context is responsible for rednering our CIImage, and allows us to create a CGImage from it.
- (CIContext *)context {
    
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.filters = [[[self class] photoFilters] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Helper Methods

+ (NSArray *)photoFilters {
    
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: nil];
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:nil];
    
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
    
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
    
    CIFilter *colorControl = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
    
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
    
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
    
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControl, transfer, unsharpen, monochrome];
    
    return allFilters;
}

// Returns an UIImage with a filter applied to it
-(UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter {
    
    // Convert UIImage (unfiltered) to CIImage by initialising an CIImage and calling CGImage on the image.
    CIImage *unfilteredImage = [[CIImage alloc]initWithCGImage:image.CGImage];
    
    // Set filter to be applied to the UIImage using an Apple constant for the key i.e. kCIInputImageKey.
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    
    // Apply the selected filter to the  image.
    CIImage *filteredImage = [filter outputImage];
    
    // Determine how big the image is
    CGRect extent = [filteredImage extent];
    
    // Allows the filtered UIImage to be converted to a CGImage
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    
    
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    
    //NSLog(@"Data from image conversion %@", UIImagePNGRepresentation(finalImage));
    
    return finalImage;
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.filters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Photo Cell";
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    // Use Grand Central Dispatch to dispatch the filtering functionality to a separate thread whilst updating the collection view cells with the filtered images in the UI in our main queue.
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL); // This is a C function that creates a dispatch queue for blocks to be submitted
    dispatch_async(filterQueue, ^{
        UIImage *filterImgae = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = filterImgae;
        });
    });
    
//    cell.imageView.image = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];

    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Cast PhotoCollectionViewCell object to the return of the cellForItemAtIndexPath method as we know we only want an PhotoCollectionViewCell object.
    PhotoCollectionViewCell *selectedCell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // Set the selectedCell image (filtered image) to the image property of the photo entity in our database.
    self.photo.image = selectedCell.imageView.image;
    
    // Persist selected filtered image to core data only when the image loads i.e. do not allow user to select blank image to be added.
    if (self.photo.image) {
        NSError *error = nil;
        
        if (![[self.photo managedObjectContext] save:&error]) {
            // Handle error
        }
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    
}
          

@end
