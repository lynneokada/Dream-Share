//
//  SearchViewController.h
//  DreamApp
//
//  Created by Lynne Okada on 10/3/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate>
//tool bar references
@property (weak, nonatomic) IBOutlet UITabBarItem *home;
@property (weak, nonatomic) IBOutlet UITabBarItem *add;
@property (weak, nonatomic) IBOutlet UITabBarItem *search;
@property (weak, nonatomic) IBOutlet UITabBarItem *profile;


//search bar reference
@property (weak, nonatomic) IBOutlet UISearchBar *searchDreamTags;

@end
