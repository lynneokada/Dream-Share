//
//  AddCommentViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 11/10/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "AddCommentViewController.h"
#import "ServerManager.h"
#import "CustomCommentTableViewCell.h"

@interface AddCommentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation AddCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"dream_id: %@", self.dream_id);
    
    if (self.fetchedComments.count > 6)
    {
        
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedComments count];
}

- (IBAction)sendTapped:(id)sender
{
    NSString *comment = self.textField.text;
    [[ServerManager sharedManager] postComment:comment withDreamID:self.dream_id];
    [[ServerManager sharedManager] getCommentsWith:self.dream_id andCallbackBlock:^(NSArray * comments) {
        self.fetchedComments = [comments mutableCopy];
        [self.tableView reloadData];
    }];
    
    self.textField.text = @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.comment.text = [self.fetchedComments[indexPath.row] valueForKey:@"commentContent"];
    cell.name.text = [self.fetchedComments[indexPath.row] valueForKey:@"dreamerName"];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
