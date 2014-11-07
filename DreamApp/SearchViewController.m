//
//  SearchViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "SearchViewController.h"
#import "ServerManager.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SearchViewController {
    NSArray *searchResults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchResults = [[NSMutableArray alloc] init];
    NSString *searchTag = searchBar.text;
    NSLog(@"SEARCH: %@", searchTag);
    
    [[ServerManager sharedManager] getDreamsWithTag:searchTag andCallbackBlock:^(NSArray * foundDreams) {
        searchResults = foundDreams;
        [self.tableView reloadData];
        NSLog(@"found dreams: %d", searchResults.count);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [searchResults[indexPath.row] valueForKey:@"dreamTitle"];
    
    return cell;
}

- (void) dismissKeyboard
{
    // add self
    [self.searchBar resignFirstResponder];
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
