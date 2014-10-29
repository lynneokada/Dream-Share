//
//  ShowDreamViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class Dream;

@interface ShowDreamViewController : UIViewController <AVAudioPlayerDelegate, UITextViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) Dream *dream;

@end
