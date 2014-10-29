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
#import "EditDreamViewController.h"
#import "Global.h"
#import "FileSystemManager.h"
#import "Dream.h"
#import "CoreDataManager.h"

@interface ProfileViewController () {
    NSURL *audioFileURL;
    NSURL *txtFileURL;
    NSString *masterDreamFolderPath;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;

@end

@implementation ProfileViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.dreamFolders = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //make imageView circular
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height /2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.profilePictureView.layer.borderWidth = 0;
    
    // get access to the managed object context
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // get entity description for entity we are selecting
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Dream" inManagedObjectContext:context];
    // create a new fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // create an error variable to pass to the execute method
    NSError *error;
    // retrieve results
    self.dreamFolders = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (self.dreamFolders == nil) {
        //error handling, e.g. display error to user
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self.tableView reloadData];
    
    NSLog(@"dreamFolders: %@", self.dreamFolders);
}

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dreamFolders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamLog" forIndexPath:indexPath];
    
    NSString *title = @"dream title";
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *audioFolderPath = [documentDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    
    NSLog(@"deleting in %@", audioFolderPath);
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", masterDreamFolderPath, self.dreamFolders[indexPath.row]]  error:&error];
    
    [self.dreamFolders removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editDream"])
    {
        EditDreamFromProfileViewController *editDreamFromProfileViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;

        editDreamFromProfileViewController.dream = self.dreamFolders[selectedIndexPath.row];
        
        NSLog(@"DREAM FOLDERS: %@", self.dreamFolders);
        
    } else if ([segue.identifier isEqualToString:@"addDream"])
    {
        EditDreamViewController *editDreamViewController = [segue destinationViewController];
        
        editDreamViewController.dreamFolders = self.dreamFolders;
    }
}

@end
