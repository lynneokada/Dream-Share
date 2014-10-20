//
//  ProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "EditProfileViewController.h"
#import "EditDreamViewController.h"
#import "Global.h"

@interface ProfileViewController () {
    NSString *profilePicturePath;
    NSURL *audioFileURL;
    NSURL *txtFileURL;
    NSString *masterDreamFolderPath;
    NSMutableArray *dreamFolders;
}


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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToProfileViewController:(UIStoryboardSegue *)unwindSegue {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dreamFolders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreamLog" forIndexPath:indexPath];
    
    //cell.textLabel.text = [self.privateDreamList[indexPath.row] name];
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //path to documents directory
    self.profilePicture.image = [UIImage imageWithContentsOfFile:@"savedImage.png"];
    NSLog(@"%@", self.profilePicture.image);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    masterDreamFolderPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    NSLog(@"masterDreamFolderPath: %@", masterDreamFolderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:masterDreamFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSArray *masterDreamFolderContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:masterDreamFolderPath error:NULL];
    dreamFolders = [NSMutableArray arrayWithCapacity: [masterDreamFolderContent count]];
    NSString *filename;
    for (filename in masterDreamFolderContent)
    {
        [dreamFolders addObject: filename];
    }
    
    //self.recordingsToBeEdited = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:NULL] mutableCopy];
    
    NSLog(@"dreamFolders: %@", dreamFolders);
    //    profilePicturePath = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL] mutableCopy];
    //
    //    _profilePicture.image = [[UIImageView alloc] initWithImage:[NSString stringWithFormat:profilePicturePath]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editDream"]) {
        EditDreamViewController *editDreamViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        
        NSLog(@"dreamFolders: %@", dreamFolders);
        audioFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/dreamRecording.m4a", masterDreamFolderPath, dreamFolders[selectedIndexPath.row]]];
        editDreamViewController.audioURL = audioFileURL;
        
        txtFileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/dreamContent.txt", masterDreamFolderPath, dreamFolders[selectedIndexPath.row]]];
        editDreamViewController.txtURL = txtFileURL;
        
        NSLog(@"audioFile: %@", audioFileURL);
        NSLog(@"txtFile: %@", txtFileURL);
    }
}

@end
