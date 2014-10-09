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

@interface EditDreamViewController () {
    Dream *dreamBeingAdded;
}

@property (weak, nonatomic) IBOutlet UITextView *dreamContentTextView;

@end

@implementation EditDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dreamContentTextView.delegate = self;
    
    //resign textView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //create file in library directory
    NSString *cachesFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [cachesFolder stringByAppendingPathComponent:@"testfile"];
    [[NSData data] writeToFile:file options:NSDataWritingAtomic error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playTapped:(id)sender {
    if (!self.recorder.recording){
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
}

//- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Your recording has ended"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//}

- (void) dismissKeyboard {
    // add self
    [self.dreamContentTextView resignFirstResponder];
}

- (IBAction)saveTapped:(id)sender {
    //references via tab bar controller
    UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:3];
    ProfileViewController *profileViewController = [navigationController.viewControllers objectAtIndex:0];
    [profileViewController.dreamLog addObject:dreamBeingAdded];

    dreamBeingAdded.content = self.dreamContentTextView.text;
    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    
    self.tabBarController.selectedIndex = 3;
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
