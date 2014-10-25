//
//  EditDreamFromProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/21/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface EditDreamFromProfileViewController : UIViewController <AVAudioPlayerDelegate, UITextViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate> {
    UIToolbar *keyboardToolBar;
}

@property (nonatomic, strong) NSURL *audioFileURL;
@property (nonatomic, strong) NSURL *txtURL;
@property (nonatomic, strong) NSString *dreamFolderPath;
@property (nonatomic, strong) NSString *audioFilePath;

@property (nonatomic, retain) UIToolbar *keyboardToolBar;
@end
