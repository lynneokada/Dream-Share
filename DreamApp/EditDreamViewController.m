//
//  EditDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "EditDreamViewController.h"
#import "Dream.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "Global.h"

@interface EditDreamViewController () {
    Dream *dreamBeingAdded;
    NSString *masterDreamFolderPath;
}

@property (weak, nonatomic) IBOutlet UITextView *dreamContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation EditDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dreamContentTextView.delegate = self;
    
    //resign textView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //create NSManagedObjectContext - CORE DATA
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    dreamBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Dream" inManagedObjectContext:context];
    
    //FILE SYSTEM
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    masterDreamFolderPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    NSLog(@"%@", masterDreamFolderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:masterDreamFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Does audio file exist
    NSLog(@"%@", self.audioURL);
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.audioURL.path])
    {
        [self.playButton setEnabled:NO];
    } else {
        [self.playButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playTapped:(id)sender {
        [self.playButton setEnabled:YES];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:nil];
        NSLog(@"%@", self.audioURL);
        [self.player setDelegate:self];
        [self.player play];
}

- (void) dismissKeyboard {
    // add self
    [self.dreamContentTextView resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)shareTapped:(id)sender {
    //references via tab bar controller
//    UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:3];
//    ProfileViewController *profileViewController = [navigationController.viewControllers objectAtIndex:0];
//    [profileViewController.dreamLog addObject:dreamBeingAdded];
//    
//    dreamBeingAdded.content = self.dreamContentTextView.text;
//    dreamBeingAdded.title = self.dreamTitleLabel.text;
//    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    
    
    NSLog(@"dreamFolderPath: %@", _dreamFolderPath);
    
    NSString *dreamContent = _dreamContentTextView.text;
    
    NSString *dreamContentPath = [NSString stringWithFormat:@"%@/dreamContent.txt", _dreamFolderPath];
    
    NSData *dreamContentData = [dreamContent dataUsingEncoding:NSASCIIStringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:dreamContentPath contents:dreamContentData attributes:NULL];
    
    NSLog(@"%@", dreamContentData);
    
    
    
    self.tabBarController.selectedIndex = 3;
}

- (IBAction)saveTapped:(id)sender {
//    UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:3];
//    ProfileViewController *profileViewController = [navigationController.viewControllers objectAtIndex:0];
//    [profileViewController.dreamLog addObject:dreamBeingAdded];
//    
//    dreamBeingAdded.content = self.dreamContentTextView.text;
//    dreamBeingAdded.title = self.dreamTitleLabel.text;
//    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    
    self.tabBarController.selectedIndex = 3;
}

- (IBAction)unwindToEditDreamViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"unwindToProfile"]) {
//
//        //dreamBeingAdded.recording = self.player.data;
//
//    }
//}

@end
