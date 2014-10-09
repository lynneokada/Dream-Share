//
//  EditProfileViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/9/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@class UserInfo;

@interface EditProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic, retain) UIImagePickerController *imgPicker;

@property (nonatomic, strong) UserInfo *userInfo;
@end
