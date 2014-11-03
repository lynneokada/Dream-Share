//
//  InitialViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 9/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "InitialViewController.h"
#import "LoginViewController.h"
#import "CreateAccountViewController.h"
#import "ProfileViewController.h"
#import "ProfileManager.h"
#import "Dream.h"
#import "User.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *createAccount;

@end

@implementation InitialViewController
{
    User *userLoggingIn;
    NSMutableArray *facebookFriends;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    loginView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+75);
    [self.view addSubview:loginView];
    loginView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fadein];
    [self buttonAnimation];
}

- (void) buttonAnimation
{
    //saving the original position of the elements
    //CGRect originalTitleFrame = self.appName.frame;
    CGRect originalLoginFrame = self.login.frame;
    CGRect originalCreateAccountFrame = self.createAccount.frame;
    
    //create the off screen positions of each element
    //    CGRect offScreenTitleFrame = CGRectMake(originalTitleFrame.origin.x,
    //                                           originalTitleFrame.origin.y - self.view.frame.size.height / 2.0f,
    //                                           originalTitleFrame.size.width,
    //                                           originalTitleFrame.size.height);
    
    CGRect offScreenLoginFrame = CGRectMake(originalLoginFrame.origin.x + self.view.frame.size.width,
                                            originalLoginFrame.origin.y,
                                            originalLoginFrame.size.width,
                                            originalLoginFrame.size.height);
    
    CGRect offScreenCreateAccountFrame = CGRectMake(originalCreateAccountFrame.origin.x - self.view.frame.size.width,
                                                    originalCreateAccountFrame.origin.y,
                                                    originalCreateAccountFrame.size.width,
                                                    originalCreateAccountFrame.size.height);
    //set elements off screen
    //self.appName.alpha = 0.0f;
    self.login.alpha = 0.0f;
    self.createAccount.alpha = 0.0f;
    
    //self.appName.frame = offScreenTitleFrame;
    self.login.frame = offScreenLoginFrame;
    self.createAccount.frame = offScreenCreateAccountFrame;
    
    [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:0.75f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        //self.appName.alpha = 1.0f;
        self.login.alpha = 1.0f;
        self.createAccount.alpha = 1.0f;
        
        //self.appName.frame = originalTitleFrame;
        self.login.frame = originalLoginFrame;
        self.createAccount.frame = originalCreateAccountFrame;
    } completion:^(BOOL finished) {
        
    }];
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
                 
                 if ([[CoreDataManager sharedManager] requestUserInfo].count == 0)
                 {
                     NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
                     User *userBeingAdded = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                    
                     [ProfileManager sharedManager].FBUserFullName = user.name; //navigationbarTitle
                     userBeingAdded.fbFullName = user.name;
                     userBeingAdded.fbUserID = user.objectID;
                     
                 }
             });
         }
         [self performSegueWithIdentifier:@"didLogin" sender:self];
     }];
}

// Handle possible errors that can occur durqing login
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

- (IBAction)unwindToInitialViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
