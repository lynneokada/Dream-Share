//
//  LoginViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 9/30/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameInput.delegate = self;
    self.passwordInput.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
