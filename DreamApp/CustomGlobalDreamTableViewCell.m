//
//  CustomGlobalDreamTableViewCell.m
//  DreamApp
//
//  Created by Lynne Okada on 11/12/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "CustomGlobalDreamTableViewCell.h"

@implementation CustomGlobalDreamTableViewCell
@synthesize imageView;

- (void)awakeFromNib {
    // Initialization code
    imageView.layer.cornerRadius = self.imageView.frame.size.height /2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0;
    
    
    // Create a white border with defined width
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 5;
    
    // To enable corners to be "clipped"
    [imageView setClipsToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
