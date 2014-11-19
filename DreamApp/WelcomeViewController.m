//
//  WelcomeViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/1/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *UIButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[self.UIButton layer] setBorderWidth:1.0f];
    [[self.UIButton layer] setBorderColor:[UIColor colorWithRed:0.933 green:0.925 blue:0.941 alpha:1].CGColor];
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
