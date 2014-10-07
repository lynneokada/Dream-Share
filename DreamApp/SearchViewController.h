//
//  SearchViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate>
//search bar reference
@property (weak, nonatomic) IBOutlet UISearchBar *searchDreamTags;

@end
