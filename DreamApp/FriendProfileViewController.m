//
//  FriendProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 11/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "FriendProfileViewController.h"

@interface FriendProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FriendProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString* imageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",self.idString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];

    self.imageView.image = image;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height /2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 0;
    
    self.navigationItem.title = self.friendName;
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
