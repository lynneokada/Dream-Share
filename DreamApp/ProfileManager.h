//
//  ProfileManager.h
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProfileManager : NSObject

@property (nonatomic, strong) UIImage *FBProfilePicture;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *user_id;

+ (instancetype) sharedManager;

@end