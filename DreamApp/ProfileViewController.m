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
#import "AddDreamViewController.h"
#import "Global.h"
#import "FileSystemManager.h"
#import "Dream.h"
#import "CoreDataManager.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;

@end

@implementation ProfileViewController {
    //array of dreams fetched from core data
    NSArray *dreams;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height /2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.profilePictureView.layer.borderWidth = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    dreams = [[CoreDataManager sharedManager] requestDreams];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dreams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamLog" forIndexPath:indexPath];
    
    NSString *title = @"dream title";
    
    cell.textLabel.text = title;
    
    return cell;
}

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editDream"])
    {
//        EditDreamFromProfileViewController *editDreamFromProfileViewController = [segue destinationViewController];
//        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
//
//        editDreamFromProfileViewController.dream = self.dreamFolders[selectedIndexPath.row];
//        
//        NSLog(@"DREAM FOLDERS: %@", self.dreamFolders);
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
