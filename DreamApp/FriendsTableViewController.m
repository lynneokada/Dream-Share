//
//  FriendsTableViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "FriendTableViewCell.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FriendsTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell;

@end

@implementation FriendsTableViewController
{
    NSMutableArray *facebookFriends;
    NSDictionary<FBGraphUser>* friend;
    UIImage *friendImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.imageView.layer.cornerRadius = self.imageView.frame.size.height /2;
//    self.imageView.layer.masksToBounds = YES;
//    self.imageView.layer.borderWidth = 0;
    
    facebookFriends = [[NSMutableArray alloc] init];
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     { if (error) {
        //error handling
    } else {
         //dictionary
         NSDictionary *resultDictionary = (NSDictionary *)result;
         NSArray *data = [resultDictionary objectForKey:@"data"];
         
         for (NSDictionary *dic in data)
         {
             [facebookFriends addObject:[dic objectForKey:@"name"]];
             [facebookFriends addObject:[dic objectForKey:@"id"]];
         }//for
         NSString *imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", friend.objectID];
         dispatch_async(dispatch_get_main_queue(), ^(void)
                        {
                            //do any update stuff here
                    
                            friendImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                            
                        }); //main queue dispatch
    }
     }];//FBrequest block
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
    }];
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        facebookFriends = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", facebookFriends.count);
        for (friend in facebookFriends) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [facebookFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    
    friend = facebookFriends[indexPath.row];
    cell.friendName.text = friend.name;
    cell.imageView.image = friendImage;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
