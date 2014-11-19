//
//  InitialViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 9/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "InitialViewController.h"
#import "ProfileViewController.h"
#import "ProfileManager.h"
#import "Dream.h"
#import "User.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "ServerManager.h"

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *appName;

@end

@implementation InitialViewController
{
    NSMutableArray *facebookFriends;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    loginView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:loginView];
    loginView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fadein];
}

- (void) fadein {
    self.appName.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    self.appName.alpha = 1;
    
    [UIView commitAnimations];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    ProfileManager *sharedProfileManager = [ProfileManager sharedManager];
    
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error)
         {
             //error handling no wifi
             
         } else {
             
             NSString *imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.objectID];
             
             dispatch_async(dispatch_get_global_queue(0, 0),^{
                 UIImage *profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                 
                 sharedProfileManager.FBProfilePicture = profilePic;
                 
                 NSLog(@"username: %@", user.name);
                 NSLog(@"user_id: %@", user.objectID);
                 NSLog(@"user.count %lu", (unsigned long)[[CoreDataManager sharedManager] requestUserInfo].count);
                 
                 //CHECK IF USER EXISTS
                 [[ServerManager sharedManager] checkForUser:user.objectID andCallbackBlock:^(NSArray * userInfo)
                  {
                      NSLog(@"%@", userInfo);
                      if (userInfo == nil)
                      {
                          //CREATE USER IN CORE DATA AND POST TO SERVER
                          NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
                          User *userBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                          
                          userBeingAdded.fbFullName = user.name;
                          userBeingAdded.fbUserID = user.objectID;
                          
                          [[ServerManager sharedManager] postUser:userBeingAdded];
                          [ProfileManager sharedManager].user = userBeingAdded;
                      } else {
                          //ELSE IF USER IS IN SERVER CHECK IF USER IS STORED IN CORE DATE
                          if ([[CoreDataManager sharedManager] requestUserInfo].count == 0)
                          {
                              //IF NOT MAKE ONE
                              NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
                              User *userBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                              
                              userBeingAdded.fbFullName = user.name;
                              userBeingAdded.fbUserID = user.objectID;
                              
                              [ProfileManager sharedManager].user = userBeingAdded;
                          } else {
                              //ELSE GRAB ALL THE INFO FROM CORE DATAAaaaaaa
                              NSMutableArray *userInfo = [[CoreDataManager sharedManager] requestUserInfo];
                              [ProfileManager sharedManager].user = userInfo[0];
                          }
                      }
                  }];
             });
         }
         [self performSegueWithIdentifier:@"didLogin" sender:self];
     }];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
