//
//  ProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "EditProfileViewController.h"
#import "EditDreamFromProfileViewController.h"
#import "Global.h"

@interface ProfileViewController () {
    NSURL *audioFileURL;
    NSURL *txtFileURL;
    NSString *masterDreamFolderPath;
    NSMutableArray *dreamFolders;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *posts;
@property (weak, nonatomic) IBOutlet UIButton *followers;
@property (weak, nonatomic) IBOutlet UIButton *following;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;

@end

@implementation ProfileViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.dreamLog = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //make imageView circular
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height /2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.profilePictureView.layer.borderWidth = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.tableView reloadData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    masterDreamFolderPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    NSLog(@"masterDreamFolderPath: %@", masterDreamFolderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:masterDreamFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSArray *masterDreamFolderContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:masterDreamFolderPath error:NULL];
    dreamFolders = [NSMutableArray arrayWithCapacity: [masterDreamFolderContent count]];
    NSString *filename;
    for (filename in masterDreamFolderContent)
    {
        [dreamFolders addObject: filename];
    }
    NSLog(@"dreamFolders: %@", dreamFolders);
    
    NSURL *url = [NSURL URLWithString:@"http://10.0.32.225:3000/dream"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (responseStatusCode == 200 && data) {
            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // do something with this data
            // if you want to update UI, do it on main queue
            [self.dreamFeed removeAllObjects];
            for (int i = 0; i < [downloadedJSON count]; i++)
            {
                [self.dreamFeed addObject:downloadedJSON[i][@"content"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            // error handling
        }
    }];
    [dataTask resume];
    NSLog(@"dreamFeed: %@", self.dreamFeed);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)unwindSegue {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dreamFolders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamLog" forIndexPath:indexPath];
    
    NSLog(@"%@", masterDreamFolderPath);
    
    //[masterDreamFolderPath[indexPath.row]];
    
    NSString *title = @"dream title";
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *audioFolderPath = [documentDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    
    NSLog(@"deleting in %@", audioFolderPath);
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", masterDreamFolderPath, dreamFolders[indexPath.row]]  error:&error];
    
    [dreamFolders removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editDream"]) {
        EditDreamFromProfileViewController *EditDreamFromProfileViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        
        audioFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/dreamRecording.m4a", masterDreamFolderPath, dreamFolders[selectedIndexPath.row]]];
        EditDreamFromProfileViewController.audioFileURL = audioFileURL;
        
        txtFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/dreamContent.txt", masterDreamFolderPath, dreamFolders[selectedIndexPath.row]]];
        EditDreamFromProfileViewController.txtURL = txtFileURL;
        
        EditDreamFromProfileViewController.dreamFolderPath = dreamFolders[selectedIndexPath.row];
        
        NSLog(@"dreamFolderPath: %@", dreamFolders[selectedIndexPath.row]);
        NSLog(@"audioFile: %@", audioFileURL);
        NSLog(@"txtFile: %@", txtFileURL);
    }
}

@end
