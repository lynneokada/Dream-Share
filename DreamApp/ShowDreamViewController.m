//
//  ShowDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ShowDreamViewController.h"
#import "Dream.h"

@interface ShowDreamViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation ShowDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.textView.delegate = self;
    self.textField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSString *pathToContent = [NSString stringWithFormat:@"%@/%@", self.dream.pathToFolder, self.dream.dreamName];
    NSString *content = [NSString stringWithContentsOfFile:pathToContent encoding:NSUTF8StringEncoding error:nil];
    self.textView.text = content;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", self.dream.pathToFolder, self.dream.recordingName]])
    {
        self.playButton.enabled = NO;
    } else {
        self.playButton.enabled = YES;
    }
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
