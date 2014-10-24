//
//  EditDreamViewController2.h
//  DreamApp
//
//  Created by Lynne Okada on 10/21/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#pragma message "Numbers in class names are bad! Is this the new EditDreamViewController? If so, then just delete the old one. Through Git you'll always have access to the old file"

@interface EditDreamViewController2 : UIViewController <AVAudioPlayerDelegate, UITextViewDelegate, UITextFieldDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) NSURL *audioFileURL;
@property (nonatomic, strong) NSURL *txtURL;
@property (nonatomic, strong) NSString *dreamFolderPath;
@property (nonatomic, strong) NSString *audioFilePath;

@end
