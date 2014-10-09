//
//  ProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ProfileViewController.h"
#import "DreamViewController.h"
#import "AppDelegate.h"
#import "EditProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

@implementation ProfileViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.dreamLog = [NSMutableArray array];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //make imageView circular
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height /2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
    
    // Do any additional setup after loading the view.
    // get access to the managed object context
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // get entity description for entity we are selecting
    NSEntityDescription *dreamDescription = [NSEntityDescription entityForName:@"Dream" inManagedObjectContext:context];
    NSEntityDescription *userInfoDescription = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
    // create a new fetch request
    NSFetchRequest *requestDream = [[NSFetchRequest alloc] init];
    NSFetchRequest *requestUserInfo = [[NSFetchRequest alloc] init];
    
    [requestDream setEntity:dreamDescription];
    [requestUserInfo setEntity:userInfoDescription];
    // create an error variable to pass to the execute method
    NSError *error;
    // retrieve results
    self.dreamLog = [[context executeFetchRequest:requestDream error:&error] mutableCopy];
    if (self.dreamLog == nil) {
        //error handling, e.g. display error to user
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)unwindSegue {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dreamLog count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamLog" forIndexPath:indexPath];
    
    //cell.textLabel.text = [self.privateDreamList[indexPath.row] name];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDream"]) {
        DreamViewController *dreamViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        dreamViewController.dream = self.dreamLog[selectedIndexPath.row];
    } else if ([segue.identifier isEqualToString:@"editProfile"]) {
        //EditProfileViewController *editProfileViewController = [segue destinationViewController];
    }
}

@end
