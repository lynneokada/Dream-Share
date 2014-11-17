//
//  CustomSearchTableViewCell.m
//  DreamApp
//
//  Created by Lynne Okada on 11/8/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "CustomSearchTableViewCell.h"

@implementation CustomSearchTableViewCell
@synthesize imageView;

- (void)awakeFromNib
{
    // Initialization code
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height /2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 0;
    
    
    // Create a white border with defined width
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 3;
    
    // To enable corners to be "clipped"
    [self.imageView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
