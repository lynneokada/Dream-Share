//
//  RecordViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class Dream;

@interface RecordViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) Dream *dreamBeingAdded;

@end
