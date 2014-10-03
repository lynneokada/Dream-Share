//
//  DreamListTableViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "DreamListTableViewController.h"
#import "DreamViewController.h"
#import "Dream.h"
#import "AppDelegate.h"
#import "RecordViewController.h"

@interface DreamListTableViewController ()

@end

@implementation DreamListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    self.privateDreamList = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (self.privateDreamList == nil) {
        //error handling, e.g. display error to user
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.privateDreamList = [NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.privateDreamList count];
}

- (IBAction)unwindToDreamListTableViewController:(UIStoryboardSegue *)unwindSegue {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DreamViewController *dreamViewController = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"DreamCells"]) {
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        dreamViewController.dream = self.privateDreamList[selectedIndexPath.row];
    } else if ([segue.identifier isEqualToString:@"addDream"]) {
        RecordViewController *recordViewController = [segue destinationViewController];
        recordViewController.privateDreamList = self.privateDreamList;
    }
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DreamCell" forIndexPath:indexPath];
    
    //cell.textLabel.text = [self.privateDreamList[indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.privateDreamList removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    // get access to the managed object context
//    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication
//                                                       sharedApplication].delegate).managedObjectContext;
//    // delete object
//    [context deleteObject:];
//    // create an error variable to pass to the save method
//    NSError *error = nil;
//    // attempt to save the context and persist our changes
//    [context save:&error];
//    if (error) {
//        //error handling, e.g. display error to user
//    }
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
