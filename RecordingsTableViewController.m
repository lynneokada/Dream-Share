//
//  RecordingsTableViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/13/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "RecordingsTableViewController.h"
#import "Global.h"
#import "EditDreamViewController.h"

@interface RecordingsTableViewController () {
    AVAudioPlayer *player;
    NSString *dataPath;
    NSURL *audioFileURL;
}

@end

@implementation RecordingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //path to documents directory for audio files
    dataPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    
    //NSString of the .m4a file
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.recordingsToBeEdited count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordingCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.recordingsToBeEdited[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *audioFolderPath = [documentDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];

    NSLog(@"deleting in %@", audioFolderPath);
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", audioFolderPath, self.recordingsToBeEdited[indexPath.row]]  error:&error];
    
    [self.recordingsToBeEdited removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editDream"]) {
        EditDreamViewController *editDreamViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        audioFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", dataPath,self.recordingsToBeEdited[selectedIndexPath.row]]];
        editDreamViewController.audioURL = audioFileURL;
    }
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self.navigationController popToRootViewControllerAnimated:NO];
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
