//
//  EditDreamViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ProfileViewController.h"

@interface EditDreamViewController : UIViewController <AVAudioPlayerDelegate, UITextViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate, NSURLSessionDelegate> {
    UIToolbar *keyboardToolBar;
}
@property (nonatomic, strong) Dream *dreamBeingAdded;
@property (nonatomic, strong) NSMutableArray *dreamFolders;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) NSMutableArray *recordingsToBeEdited;
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) NSString *audioFilePath;
@property (nonatomic, strong) NSURL *audioURL;
@property (nonatomic, strong) NSURL *txtURL;
@property (nonatomic, strong) NSString *dreamFolderPath;

@property (nonatomic, retain) UIToolbar *keyboardToolBar;

@property (nonatomic, strong) NSMutableArray *pathToDreams;
@property (nonatomic, strong) NSMutableArray *pathToRecordings;


- (void)createNewDreamToEdit;

@end