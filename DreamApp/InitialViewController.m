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

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *createAccount;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self fadein];
    [self whoaThatWasKindaCool];
}

- (void) whoaThatWasKindaCool {
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
        NSLog(@"Fancy animation complete!");
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"login"]) {
//        LoginViewController *loginViewController = [segue destinationViewController];
//    }
//    if ([segue.identifier isEqualToString:@"createAccount"]) {
//        CreateAccountViewController *createAccountViewController = [segue destinationViewController];
//    }
//}

- (IBAction)unwindToInitialViewController:(UIStoryboardSegue *)unwindSegue {
    
}

@end
