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
#import "AddDreamViewController.h"
#import "Global.h"
#import "FileSystemManager.h"
#import "Dream.h"
#import "CoreDataManager.h"
#import "ShowDreamViewController.h"
#import "ProfileManager.h"
#import "User.h"
#import "ServerManager.h"
#import "CustomProfileTableViewCell.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

@implementation ProfileViewController {
    //array of dreams fetched from core data
    NSMutableArray *dreams;
}
@synthesize navigationItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height/2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.profilePictureView.layer.borderWidth = 0;
    
    // Create a white border with defined width
    self.profilePictureView.layer.borderColor = [UIColor colorWithRed:0.933 green:0.925 blue:0.941 alpha:1].CGColor;
    self.profilePictureView.layer.borderWidth = 5;
    
    // To enable corners to be "clipped"
    [self.profilePictureView setClipsToBounds:YES];
    
    self.navigationItem.title = [ProfileManager sharedManager].user.fbFullName;
    
    [self.tableView reloadData];
    
    dreams = [[CoreDataManager sharedManager] requestDreams];
    NSLog(@"dream count: %lu", (unsigned long)dreams.count);
    //FOR WHEN DREAM IS CREATED WITHOUT SERVER CONNECTION
    for (int i = 0; i < dreams.count; i++)
    {
        if ([dreams[i] valueForKey:@"db_id"] == nil)
        {
            [[ServerManager sharedManager] postDream:dreams[i]];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.profilePictureView.image = [[ProfileManager sharedManager] FBProfilePicture];
    
    dreams = [[CoreDataManager sharedManager] requestDreams];
    
    [self.tableView reloadData];
    NSLog(@"DREAMS FROM CORE DATA: %@", dreams);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dreams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamCell" forIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    cell.date.text = [dateFormatter stringFromDate:[dreams[indexPath.row] valueForKey:@"last_updated"]];
    cell.title.text = [dreams[indexPath.row] valueForKey:@"dreamTitle"];
    cell.content.text = [dreams[indexPath.row] valueForKey:@"dreamContent"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Dream *dream = dreams[indexPath.row];
    
    //DELETE FROM SERVER
    [[ServerManager sharedManager] deleteDreamUsing:dream.db_id];
    [[ServerManager sharedManager] deleteCommentsFromDream:dream.db_id];
    
    //DELETE FROM CORE DATA
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    [context deleteObject:dreams[indexPath.row]];
    
        //DELETE FROM FILE SYSTEM
    NSString *dreamToBeDeleted = dream.pathToFolder;
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:dreamToBeDeleted error:&error];
    
    [dreams removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDream"])
    {
        ShowDreamViewController *showDreamViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        
        NSLog(@"DREAM: %@", dreams[selectedIndexPath.row]);
        showDreamViewController.dream = dreams[selectedIndexPath.row];
    }
    else if ([segue.identifier isEqualToString:@"addDream"])
    {
        AddDreamViewController *addDreamViewController = [segue destinationViewController];
        
        //create dream object
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        Dream *dreamBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Dream" inManagedObjectContext:context];
        addDreamViewController.dreamBeingAdded = dreamBeingAdded;
        
        //create path to dream folder
        NSString *dreamFolderPath = [[FileSystemManager sharedManager] createDreamFolder];
        dreamBeingAdded.pathToFolder = dreamFolderPath;
    }
}

@end
