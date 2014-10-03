//
//  ProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.profile setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
