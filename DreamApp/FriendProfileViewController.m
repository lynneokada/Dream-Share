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
#import "AppDelegate.h"
#import "CustomProfileTableViewCell.h"

@interface FriendProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *UIView;
@property (weak, nonatomic) IBOutlet UILabel *noDreamsLabel;

@end

@implementation FriendProfileViewController
{
    NSArray *dreams;
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
    
    // Create a white border with defined width
    self.imageView.layer.borderColor = [UIColor colorWithRed:0.933 green:0.925 blue:0.941 alpha:1].CGColor;
    self.imageView.layer.borderWidth = 5;
    
    // To enable corners to be "clipped"
    [self.imageView setClipsToBounds:YES];
    
    dreams = [[NSArray alloc] init];
    
    self.navigationItem.title = self.friendName;
    
    [[self.UIView layer] setBorderWidth:1.0f];
    [[self.UIView layer] setBorderColor:[UIColor colorWithRed:0.933 green:0.925 blue:0.941 alpha:1].CGColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[ServerManager sharedManager] getDreamsWithUserID:self.friendID andCallbackBlock:^(NSArray * downloadedDreams)
    {
        dreams = downloadedDreams;
        [self.tableView reloadData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (dreams.count < 1)
    {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.noDreamsLabel.hidden = NO;
    } else{
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        self.noDreamsLabel.hidden = YES;
    }
    
    return [dreams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamCell" forIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    cell.title.text = [dreams[indexPath.row] valueForKey:@"dreamTitle"];
    cell.content.text = [dreams[indexPath.row] valueForKey:@"dreamContent"];
    cell.date.text = [dateFormatter stringFromDate:[dreams[indexPath.row] valueForKey:@"last_updated"]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FriendDreamViewController *friendDreamViewController = [segue destinationViewController];
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;

    NSLog(@"DREAMID: %@", [dreams[selectedIndexPath.row] valueForKey:@"_id"]);
    friendDreamViewController.dream_id = [dreams[selectedIndexPath.row] valueForKey:@"_id"];
    friendDreamViewController.dreamContent = [dreams[selectedIndexPath.row] valueForKey:@"dreamContent"];
    friendDreamViewController.dreamTitle = [dreams[selectedIndexPath.row] valueForKey:@"dreamTitle"];
    friendDreamViewController.navtitle = self.friendName;
    //friendDreamViewController.tags = [dreams[selectedIndexPath.row] valueForKey:@"dreamTags"];
}

@end
