//
//  EditProfileViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/9/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import "UserInfo.h"

@interface EditProfileViewController () {
    UserInfo *userInfoChanged;
    NSURL *imageURL;
    UIImage *chosenImage;
}

@end

@implementation EditProfileViewController {
    UIImage *image;
}
@synthesize imgPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //make imageView circular
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height /2;
    self.profilePicture.layer.masksToBounds = YES;
    self.profilePicture.layer.borderWidth = 0;
    
    self.imgPicker = [[UIImagePickerController alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.profilePicture.userInteractionEnabled = YES;
    
    //core data for user info
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    self.userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:context];
}

- (IBAction)TakePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)ChooseExisting {
    //[self presentModalViewController:self.imgPicker animated:YES];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //display image
    chosenImage = info[UIImagePickerControllerEditedImage];
    self.profilePicture.image = chosenImage;
    
    //path to documents directory
    //    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [path objectAtIndex:0];
    //    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    //    NSLog(@"%@", getImagePath);
    //
    //    chosenImage = [[UIImage alloc] initWithContentsOfFile:@"savedImage.png"];
    //    NSLog(@"%@", chosenImage);
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickedImage);
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    
    NSLog(@"%@", path);
    
    NSError * error = nil;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
        return;
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    UITouch *touch = [touches anyObject];
//    if ([touch view] == self.profilePicture){
//        NSLog(@"touchrecieved");
//        //[self performSegueWithIdentifier:@"imageScroll" sender:self];
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"doneEdittingProfile"]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        //profile picture
        profileViewController.profilePicture.image = chosenImage;
        
        
        //user info
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        NSError *error = nil;
        [context save:&error];
        if (error) {
            
        }
        [(AppDelegate *)[UIApplication sharedApplication].delegate saveContext];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
