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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self resignFirstResponder];
    NSLog(@"dream_id: %@", self.dream_id);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.textField)
    {
        return YES;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.textField)
    {
        //[self.navigationController.toolbar setContentOffset:CGPointMake(0,textField.center.y-210) animated:YES];
//        [self.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x,
//                                          self.navigationController.toolbar.frame.origin.y - keyboardFrame.size.height +self.navigationController.toolbar.frame.size.height,
//                                          self.navigationController.toolbar.frame.size.width,
//                                          self.navigationController.toolbar.frame.size.height)];
    }
}

- (void) liftMainViewWhenKeybordAppears:(NSNotification*)aNotification
{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [self.toolbar setFrame:CGRectMake(self.toolbar.frame.origin.x,
                                                           self.toolbar.frame.origin.y - keyboardFrame.size.height +self.toolbar.frame.size.height,
                                                           self.toolbar.frame.size.width,
                                                           self.toolbar.frame.size.height)];
    [UIView commitAnimations];
    
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self.tableView];
    if ([self.tableView indexPathForRowAtPoint:touchLocation])
    {
        return NO;
    }
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.comment.text = [self.fetchedComments[indexPath.row] valueForKey:@"commentContent"];
    cell.name.text = [self.fetchedComments[indexPath.row] valueForKey:@"dreamerName"];
    
    return cell;
}

- (void) dismissKeyboard
{
    [self.textField resignFirstResponder];
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
