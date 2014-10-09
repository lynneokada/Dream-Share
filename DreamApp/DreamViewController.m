//
//  DreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "DreamViewController.h"
#import "Dream.h"

@interface DreamViewController ()

@end

@implementation DreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dreamTextView.delegate = self;
    
    self.dreamTextView.text = self.dream.content;
    self.dreamTitleLabel.text = self.dream.title;
    // Do any additional setup after loading the view.
    
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
