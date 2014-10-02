//
//  RecordViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol RecordViewControllerDelegate <NSObject>

- (void) dreamRecorded:(NSData*)dream;

@end

@interface RecordViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) id <RecordViewControllerDelegate> delegate;
@end
