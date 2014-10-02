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
    
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    dreamBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"Dream" inManagedObjectContext:context];

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

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Your recording has ended"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
}

- (IBAction)saveTapped:(id)sender {
    [_privateDreamList addObject:dreamBeingAdded];
    dreamBeingAdded.recording = self.player.data;
    dreamBeingAdded.content = self.dreamContentTextView.text;
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
