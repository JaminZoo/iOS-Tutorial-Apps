//
//  AlbumTableViewController.m
//
//
//  Created by Ben Zhu on 10/10/2015.
//
//

#import "AlbumTableViewController.h"
#import "Album.h"
#import "CoreDataHelper.h"
#import "PhotosCollectionViewController.h"

@interface AlbumTableViewController ()

@end

@implementation AlbumTableViewController


#pragma mark - Lazy Instatiation

-(NSMutableArray *)albums {
    if(!_albums) _albums = [[NSMutableArray alloc] init];
    
    return _albums;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

// To get back the information stored from Core Data, we need to write code inside viewWillAppear because we want to store data every time our view is just about to come on screen e.g. when we click back from the add album view rather than only once as is the case with viewDidLoad.
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    // An NSFetchRequest object is used as a search criteria for NSManagedObjects in the persistent store (SQLlite db).
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    
    //  Sort through the data using the the key descriptor 'date' and in ascending order i.e. earliest date first.
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    // Refactored to its own class method
    //    id delegate = [[UIApplication sharedApplication] delegate];
    //    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    NSError *error = nil;
    NSArray *fetchedAlbums = [[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    self.albums = [fetchedAlbums mutableCopy];  // return a mutable copy of fetchedAlbums and set it to the albums mutable array.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    // Assign the 'Add' button when alert view appears to be the delegate of the AlertViewDelegate, so that when user taps this button it will delegate control to what ever logic/code is associated with it.
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newAlbumAlertView show];
}

#pragma mark - Helper Methods

// Persist information into our Core Data file system (SQLite db)
- (Album *)albumWithName: (NSString *)name {
    // Create a variable 'context' that points to the NSManagedObjectContext from our App Delegate
    
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    
    // Create an NSManagedObject subclass with the class method insertNewObjectForEntityForName and set its attributes e.g. name and date.
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.name = name;
    album.date = [NSDate date];
    
    // Call the method 'save' on the instance of our NSManagedObjectContext
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%@", error);
    }
    return album;
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // If buttonIndex (or number of buttons) is equal to 1 (button at index = 0 is 'Cancel' and index = 1 is 'Add').
    if(buttonIndex == 1) {
        // assign an NSString object named alertText to equal to return value of the alertView's textField at the index 0. Since the alert view style was set to PlainTextInput, it has a textfield and therefore we can access the text inside this at the specified index.
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        // Create an instance of Album (which is a subclass of NSManagedObject) and send it the alertText using the helper method created above.
        [self.albums addObject:[self albumWithName:alertText]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.albums count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        /* The code below does the same as the two lines above, but is slightly less efficient.
         Album *newAlbum = [self alubmWithName:alertText];
         [self.albums addObject:newAlbum];  // Add new albume to NSMutableArray property
         [self.tableView reloadData];  // update table view to reflect new data entry
         */
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Album *selectedAlbum = self.albums[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Album Chosen"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotosCollectionViewController class]]) {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            PhotosCollectionViewController *targetVC = segue.destinationViewController;
            targetVC.album = self.albums[path.row];
        }
    }
}


@end
