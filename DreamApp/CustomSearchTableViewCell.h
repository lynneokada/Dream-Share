//
//  CustomSearchTableViewCell.h
//  DreamApp
//
//  Created by Lynne Okada on 11/8/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *dreamerName;
@property (weak, nonatomic) IBOutlet UILabel *dreamTitle;

@end
