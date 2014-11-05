//
//  FriendProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 11/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "ServerManager.h"
#import "FriendDreamViewController.h"

@interface FriendProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FriendProfileViewController
{
    NSMutableArray *dreams;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",self.friendID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.imageView.image = image;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height /2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 0;
    
    self.navigationItem.title = self.friendName;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[ServerManager sharedManager] getDream:self.friendID];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dreams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamCell" forIndexPath:indexPath];
    
    NSString *title = @"dream title";
    
    cell.textLabel.text = title;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FriendDreamViewController *friendDreamViewController = [segue destinationViewController];
    
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    
    friendDreamViewController.dream = dreams[selectedIndexPath.row];
}

@end
