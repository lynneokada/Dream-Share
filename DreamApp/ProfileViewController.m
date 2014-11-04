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

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

@implementation ProfileViewController {
    //array of dreams fetched from core data
    NSMutableArray *dreams;
    NSMutableArray *userInfo;
    NSMutableArray *objectID;
}
@synthesize navigationItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height /2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.profilePictureView.layer.borderWidth = 0;
    
    objectID = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = [[ProfileManager sharedManager] FBUserFullName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.profilePictureView.image = [[ProfileManager sharedManager] FBProfilePicture];
    dreams = [[CoreDataManager sharedManager] requestDreams];
    userInfo = [[CoreDataManager sharedManager] requestUserInfo];
    
    [[ServerManager sharedManager] getUserObject_id:objectID];
    NSLog(@"%@", objectID[0]);
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dreams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamCell" forIndexPath:indexPath];
    
    NSString *title = @"dream title";
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DELETE FROM CORE DATA
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    [context deleteObject:dreams[indexPath.row]];
    
    Dream *dream = dreams[indexPath.row];
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
        
        showDreamViewController.dream = dreams[selectedIndexPath.row];
    }
    else if ([segue.identifier isEqualToString:@"addDream"])
    {
        AddDreamViewController *addDreamViewController = [segue destinationViewController];
        
        //create dream object
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        Dream *dreamBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Dream" inManagedObjectContext:context];
        addDreamViewController.dreamBeingAdded = dreamBeingAdded;
        
        //pass user info
        addDreamViewController.user = userInfo[0];
        
        //create path to dream folder
        NSString *dreamFolderPath = [[FileSystemManager sharedManager] createDreamFolder];
        dreamBeingAdded.pathToFolder = dreamFolderPath;
    }
}

@end
