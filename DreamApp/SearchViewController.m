//
//  SearchViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "SearchViewController.h"
#import "ServerManager.h"
#import "FriendDreamViewController.h"
#import "CustomSearchTableViewCell.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController
{
    NSArray *searchResults;
    NSString *imageURL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchResults = [[NSMutableArray alloc] init];
    NSString *searchTag = searchBar.text;
    NSLog(@"SEARCH: %@", searchTag);
    
    [[ServerManager sharedManager] getDreamsWithTag:searchTag andCallbackBlock:^(NSArray * foundDreams)
    {
        searchResults = foundDreams;
        [self.tableView reloadData];
        NSLog(@"found dreams: %lu", (unsigned long)searchResults.count);
        NSLog(@"%@", searchResults);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [searchResults[indexPath.row] objectForKey:@"dreamerName"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
    cell.imageView.image = image;
    
    cell.dreamerName.text = [searchResults[indexPath.row] valueForKey:@"dreamerName"];
    cell.dreamTitle.text = [searchResults[indexPath.row] valueForKey:@"dreamTitle"];

    
    return cell;
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

- (void) dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showSearchedDream"])
    {
        FriendDreamViewController *friendDreamViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        
        friendDreamViewController.dreamTitle = [searchResults[selectedIndexPath.row] valueForKey:@"dreamTitle"];
        friendDreamViewController.dreamContent = [searchResults[selectedIndexPath.row] valueForKey:@"dreamContent"];
        friendDreamViewController.navtitle = [searchResults[selectedIndexPath.row] valueForKey:@"dreamerName"];
        friendDreamViewController.tags = [searchResults[selectedIndexPath.row] valueForKey:@"dreamTags"];
        friendDreamViewController.dream_id = [searchResults[selectedIndexPath.row] valueForKey:@"_id"];
    }
}


@end
