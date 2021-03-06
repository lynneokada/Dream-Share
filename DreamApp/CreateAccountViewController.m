//
//  CreateAccountViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 9/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "WelcomeViewController.h"

@interface CreateAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameInput.delegate = self;
    self.passwordInput.delegate = self;
    self.locationInput.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"accountCreated"]) {
//        WelcomeViewController *welcomeViewController = [segue destinationViewController];
//    }
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
