//
//  FriendsTableViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendTableViewCell.h"
#import "ProfileManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FriendProfileViewController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController
{
    NSMutableArray *facebookFriends;
    NSString *imageURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    facebookFriends = [[NSMutableArray alloc] init];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState status,
                                                      NSError *error) {
                                  }];
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
    }];
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error)
     {
         facebookFriends = [result objectForKey:@"data"];
         
         NSLog(@"Found: %lu friends", (unsigned long)facebookFriends.count);
         
         for (NSDictionary<FBGraphUser> *friend in facebookFriends)
         {
             
             NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
             
         }
         [self.tableView reloadData];
     }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [facebookFriends count];
    return [facebookFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.friendName.text = [facebookFriends[indexPath.row] objectForKey:@"name"];
    
    imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [facebookFriends[indexPath.row] objectForKey:@"id"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    cell.imageView.image = image;
    
    return cell;
}

 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showFriend"])
    {
        FriendProfileViewController *friendProfileViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        
        friendProfileViewController.friendName = [facebookFriends[selectedIndexPath.row] objectForKey:@"name"];
        friendProfileViewController.friendID = [facebookFriends[selectedIndexPath.row] objectForKey:@"id"];
    }
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



@end
