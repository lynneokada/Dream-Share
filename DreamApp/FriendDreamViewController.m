//
//  FriendDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "FriendDreamViewController.h"
#import "ServerManager.h"
#import "AddCommentViewController.h"

@interface FriendDreamViewController ()
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *tagsTextView;


@end

@implementation FriendDreamViewController
{
    NSMutableArray *fetchedComments;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textView.delegate = self;
    self.titleTextView.delegate = self;
    self.tagsTextView.delegate = self;
    self.textView.text = self.dreamContent;
    self.titleTextView.text = self.dreamTitle;
    
    self.navigationItem.title = self.navtitle;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[ServerManager sharedManager] getCommentsWith:self.dream_id andCallbackBlock:^(NSArray * comments)
     {
         fetchedComments = [comments mutableCopy];
         [self.tableView reloadData];
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addComment"])
    {
        AddCommentViewController *addCommentViewController = [segue destinationViewController];
        addCommentViewController.fetchedComments = fetchedComments;
        addCommentViewController.friendDream_id = self.dream_id;
    }
}


@end
