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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"dream_id: %@", self.dream_id);
    [self.textField becomeFirstResponder];
    
    if (self.fetchedComments.count > 5)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.fetchedComments.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)keyboardDidShow: (NSNotification *) notif
{
    NSDictionary* userInfo = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    NSLog(@"keyboard.height: %f", keyboardFrame.size.height);
    NSLog(@"toolbar height: %f", self.toolbar.frame.origin.y);
    [self.toolbar setFrame:CGRectMake(self.toolbar.frame.origin.x, self.toolbar.frame.origin.y - 174, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
    //[self.toolbar setFrame:CGRectMake(0, keyboardFrame.size.height - self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
    [UIView commitAnimations];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.fetchedComments.count == 0)
    {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    return [self.fetchedComments count];
}

- (IBAction)sendTapped:(id)sender
{
    NSString *comment = self.textField.text;
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    if ([[comment stringByTrimmingCharactersInSet: set] length] == 0)
    {
        self.textField.text = @"";
    } else {
        [[ServerManager sharedManager] postComment:comment withDreamID:self.dream_id];
        [[ServerManager sharedManager] getCommentsWith:self.dream_id andCallbackBlock:^(NSArray * comments)
        {
            self.fetchedComments = [comments mutableCopy];
            [self.tableView reloadData];
        }];
    }
    
    self.textField.text = @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    NSString *imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [self.fetchedComments[indexPath.row] objectForKey:@"fbUser_id"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    cell.imageView.image = image;
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
