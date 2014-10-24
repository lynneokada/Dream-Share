//
//  EditDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/2/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "EditDreamViewController.h"
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "Global.h"

@interface EditDreamViewController () {
#pragma message "try to be consistent with the use of underscores for instance variables. Both options are fine but try to stick with one of the two"
    NSString *masterDreamFolderPath;
    NSString *textFile;
    NSMutableArray *_addedDreamContent;
}

@property (weak, nonatomic) IBOutlet UITextView *dreamContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end

@implementation EditDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dreamContentTextView.delegate = self;
    
    _addedDreamContent = [NSMutableArray new];
    
    //resign textView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //FILE SYSTEM
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    masterDreamFolderPath = [documentsDirectory stringByAppendingPathComponent:DREAM_DIRECTORY];
    NSLog(@"%@", masterDreamFolderPath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:masterDreamFolderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Does audio file exist
    NSLog(@"audioFile exists? %@", self.audioURL);
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.audioURL.path])
    {
#pragma message "Use .enabled = YES instead of setEnabled:YES"
        [self.playButton setEnabled:NO];
    } else {
        [self.playButton setEnabled:YES];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.txtURL.path])
    {
        textFile = [NSString stringWithContentsOfURL:self.txtURL encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"textFile: %@", textFile);
        self.dreamContentTextView.text = textFile;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playTapped:(id)sender {
    [self.playButton setEnabled:YES];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioURL error:nil];
    NSLog(@"%@", self.audioURL);
    [self.player setDelegate:self];
    [self.player play];
}

- (void) dismissKeyboard
{
    [self.dreamContentTextView resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)shareTapped:(id)sender
{
#pragma message "Absolutely fine for now, however I would refactor this future; split it up in multiple methods and move it to a separate class" 
    NSString *dreamContent = _dreamContentTextView.text;
    
    //FILE SYSTEM
    if (![[NSFileManager defaultManager] fileExistsAtPath:_dreamFolderPath])
    {
        //date formatter
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
        
        _dreamFolderPath = [masterDreamFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [dateFormatter stringFromDate:date]]];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:masterDreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *dreamContentPath = [NSString stringWithFormat:@"%@/dreamContent.txt", _dreamFolderPath];
    
    NSData *dreamContentData = [dreamContent dataUsingEncoding:NSASCIIStringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:dreamContentPath contents:dreamContentData attributes:NULL];
    
    
    //MONGODB/IP
    NSDictionary *dictionaryDream = [NSDictionary dictionaryWithObject:self.dreamContentTextView.text forKey:@"content"];
    
    //url to mac
    NSURL *url = [NSURL URLWithString:@"http://10.0.32.225:3000/dream"];
    
    //post request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryDream options:0 error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionUploadTask *dataUpload = [urlSession uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (responseStatusCode == 200)
        {
            //            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"uploaded");
            
            NSURL *url = [NSURL URLWithString:@"http://10.0.32.225:3000/dream"];
//??? wrong
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            [request setHTTPMethod:@"GET"];
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
            
            NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                                               NSInteger responseStatusCode = [httpResponse statusCode];
                                                               
                                                               if (responseStatusCode == 200 && data) {
                                                                   NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                   // do something with this data
                                                                   // if you want to update UI, do it on main queue
                                                                   [_addedDreamContent removeAllObjects];
                                                                   for (int i = 0; i < [downloadedJSON count]; i++) {
                                                                       [_addedDreamContent addObject:downloadedJSON[i][@"content"]];
                                                                   }
//                                                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                                                       [self.tableView reloadData];
//                                                                       
//                                                                   });
                                                               } else {
                                                                   // error handling
                                                               }
                                                           }];
            [dataTask resume];
        }
        else {
            
        }
    }];
    
    [dataUpload resume];
    
    self.dreamContentTextView.text = @"";
    
    self.tabBarController.selectedIndex = 3;
}

- (IBAction)saveTapped:(id)sender
{
    
    NSString *dreamContent = _dreamContentTextView.text;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_dreamFolderPath])
    {
        //date formatter
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss-a"];
        
        _dreamFolderPath = [masterDreamFolderPath stringByAppendingString:[NSString stringWithFormat:@"/%@", [dateFormatter stringFromDate:date]]];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:_dreamFolderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *dreamContentPath = [NSString stringWithFormat:@"%@/dreamContent.txt", _dreamFolderPath];
    
    NSData *dreamContentData = [dreamContent dataUsingEncoding:NSASCIIStringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:dreamContentPath contents:dreamContentData attributes:NULL];
    
    self.dreamContentTextView.text = @"";
    
    self.tabBarController.selectedIndex = 3;
}

- (IBAction)unwindToEditDreamViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.tabBarController.tabBar.userInteractionEnabled = YES;
}

@end
