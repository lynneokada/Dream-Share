//
//  GlobalTableViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/26/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "GlobalTableViewController.h"
#import "ServerManager.h"
#import "CustomGlobalDreamTableViewCell.h"
#import "FriendDreamViewController.h"

@interface GlobalTableViewController ()

@end

@implementation GlobalTableViewController
{
    NSArray *allDreams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [[ServerManager sharedManager] getAllDreamsWithBlock:^(NSArray * dreams) {
        allDreams = dreams;
        [self.tableView reloadData];
        NSLog(@"ALLDREAMS: %@", allDreams);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [allDreams count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomGlobalDreamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamCell" forIndexPath:indexPath];
    NSString *imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [allDreams[indexPath.row] objectForKey:@"fbUser_id"]];
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        UIImage *profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        cell.imageView.image = profilePic;
    });
    cell.name.text = [allDreams[indexPath.row] objectForKey:@"dreamerName"];
    cell.title.text = [allDreams[indexPath.row] objectForKey:@"dreamTitle"];
    cell.content.text = [allDreams[indexPath.row] objectForKey:@"dreamContent"];
    return cell;
}
                   
                   
#pragma mark - Navigation
                   - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        FriendDreamViewController *friendDreamViewController = [segue destinationViewController];
        if ([segue.identifier isEqualToString:@"showDream"])
        {
            friendDreamViewController.dream_id = [allDreams[selectedIndexPath.row] valueForKey:@"_id"];
            friendDreamViewController.navtitle = [allDreams[selectedIndexPath.row] valueForKey:@"dreamerName"];
            friendDreamViewController.dreamTitle = [allDreams[selectedIndexPath.row] valueForKey:@"dreamTitle"];
            friendDreamViewController.dreamContent = [allDreams[selectedIndexPath.row] valueForKey:@"dreamContent"];
            friendDreamViewController.tags = [allDreams[selectedIndexPath.row] valueForKey:@"dreamTags"];
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
