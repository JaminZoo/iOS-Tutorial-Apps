//
//  ViewController.m
//  globalTraveller
//
//  Created by Ben Zhu on 20/10/2015.
//  Copyright (c) 2015 Ben Zhu. All rights reserved.
//

#import "ViewController.h"
#import "FourSquareAPIClient.h"
#import "AFMMRecordResponseSerializer.h"
#import "AFMMRecordResponseSerializationMapper.h"
#import "MagicalRecord/MagicalRecord.h"
#import "Venue.h"
#import "Location.h"

NSString *const kCLIENTID = @"4FK00WVCWGLQHWB2ZIEC4ILJM2ED2BTAM0WJK4VIX0HXXJJS";
NSString *const kCLIENTSECRET = @"4AXGA2RGB4N1HYPZFC4GPCYWQPGOLC0KWCOPVLYIBEUNQRD3";

@interface ViewController ()

@property (strong, nonatomic) NSArray *venues;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create an instance of FourSquareAPIClient. Because this is a Singleotn, there can only be a maximum of one instance of FourSquareAPIClient in our application at any one time.
    FourSquareAPIClient *client = [FourSquareAPIClient sharedClient];
    
    // Get the NSManagedObjectContext from Magical Record.
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    // Create a serializer to properly handle the HTTPResponse and register our Entity description to end point we'll be accessing. We know the response will be in JSON format.
    AFHTTPResponseSerializer *HTTPResponseSerializer = [AFJSONResponseSerializer serializer];
    AFMMRecordResponseSerializationMapper *mapper = [[AFMMRecordResponseSerializationMapper alloc] init];
    [mapper registerEntityName:@"Venue" forEndpointPathComponent:@"venues/search?"];
    
    // Leverage AFMMRecordResponseSerializer which is a response serializer for AFNetworking. It will serialize an HTTP response object into a list of MMRecord objects.
    AFMMRecordResponseSerializer *serializer = [AFMMRecordResponseSerializer serializerWithManagedObjectContext:context responseObjectSerializer:HTTPResponseSerializer entityMapper:mapper];
    client.responseSerializer = serializer;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    [[FourSquareAPIClient sharedClient] GET:@"venues/search" parameters:@{@"client_id" : kCLIENTID, @"client_secret" : kCLIENTSECRET, @"v" :@"20140416", @"ll" : @"30.25,-97.75"} success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSArray *venues;
        self.venues = venues;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.venues count];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Venue *venue = self.venues[indexPath.row];
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = venue.location.address;
    
    return cell;

}



#pragma mark - UITableViewDelegate




@end
