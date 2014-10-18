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
}

@property (weak, nonatomic) IBOutlet UITextView *dreamContentTextView;
@property (weak, nonatomic) IBOutlet UITextField *dreamTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tags;

@end

@implementation EditDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dreamContentTextView.delegate = self;
    _dreamTitleLabel.delegate = self;
    _tags.delegate = self;
    
    //resign textView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //create NSManagedObjectContext
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    dreamBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Dream" inManagedObjectContext:context];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)playTapped:(id)sender
//{
//    if ([self.recordPlay.titleLabel.text isEqualToString:@"RECORD"])
//    {
//        [self performSegueWithIdentifier:@"recordDream" sender:self];
//    }
//}

- (IBAction)recordPlayTapped:(id)sender {
    if ([[NSFileManager defaultManager] fileExistsAtPath: [self.audioURL absoluteString]]) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:nil];
        NSLog(@"%@", self.audioURL);
        [self.player setDelegate:self];
        [self.player play];
    } else {
        [self performSegueWithIdentifier:@"recordDream" sender:self];
    }
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
            
            //    if (textField == _tags) {
            //
            //    }
            return YES;
        }
        
        - (IBAction)saveTapped:(id)sender {
            //references via tab bar controller
            UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:3];
            ProfileViewController *profileViewController = [navigationController.viewControllers objectAtIndex:0];
            [profileViewController.dreamLog addObject:dreamBeingAdded];
            
            dreamBeingAdded.content = self.dreamContentTextView.text;
            dreamBeingAdded.title = self.dreamTitleLabel.text;
            [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
            
            self.tabBarController.selectedIndex = 3;
        }
        - (IBAction)editLaterTapped:(id)sender {
            UINavigationController *navigationController = [self.tabBarController.viewControllers objectAtIndex:3];
            ProfileViewController *profileViewController = [navigationController.viewControllers objectAtIndex:0];
            [profileViewController.dreamLog addObject:dreamBeingAdded];
            
            dreamBeingAdded.content = self.dreamContentTextView.text;
            dreamBeingAdded.title = self.dreamTitleLabel.text;
            [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
            
            self.tabBarController.selectedIndex = 3;
        }
        
        - (IBAction)unwindToEditDreamViewController:(UIStoryboardSegue *)unwindSegue
    {
        
    }
        
        
        - (void)viewDidDisappear:(BOOL)animated {
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
