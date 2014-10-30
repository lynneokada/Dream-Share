//
//  ShowDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ShowDreamViewController.h"
#import "Dream.h"
#import "CommentTableViewController.h"

@interface ShowDreamViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation ShowDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textView.delegate = self;
    self.textField.delegate = self;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

    self.textView.text = self.dream.dreamContent;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", self.dream.pathToFolder, self.dream.recordingName]])
    {
        self.playButton.enabled = NO;
    } else {
        self.playButton.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addComment"])
    {
        CommentTableViewController *commentTableViewController = [segue destinationViewController];
        commentTableViewController.dream = self.dream;
    }
}


@end
