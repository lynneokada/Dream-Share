//
//  AddDreamViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/28/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class Dream;
@class Tag;

@interface AddDreamViewController : UIViewController <AVAudioPlayerDelegate, UITextViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) Dream *dreamBeingAdded;

@property (nonatomic, strong) NSString *pathToRecording;

@end
