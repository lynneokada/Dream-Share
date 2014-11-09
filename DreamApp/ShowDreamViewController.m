//
//  ShowDreamViewController.m
//  DreamApp
//
//  Created by Lynne Okada on 10/29/14.
//  Copyright (c) 2014 Lynne Okada. All rights reserved.
//

#import "ShowDreamViewController.h"
#import "Dream.h"
#import "Tag.h"
#import "CommentTableViewController.h"

@interface ShowDreamViewController ()
{
    UIToolbar *keyboardToolBar;
    NSMutableArray *dreamTags;
    AVAudioPlayer *player;
}

@property (retain, nonatomic) UIToolbar *keyboardToolBar;
@property (nonatomic, strong) NSString *stringHolder;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end

@implementation ShowDreamViewController
@synthesize keyboardToolBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    dreamTags = [[NSMutableArray alloc] init];
    self.stringHolder = @"";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleTextView.delegate = self;
    self.textView.delegate = self;
    self.textField.delegate = self;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (keyboardToolBar == nil)
    {
        keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        [keyboardToolBar setItems:[[NSArray alloc] initWithObjects:done, nil]];
    }
    
    self.textField.inputAccessoryView = keyboardToolBar;
    self.textView.inputAccessoryView = keyboardToolBar;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //REHASHING TAGS (BETTER WAY?)
    NSMutableArray *tagsArray = [NSKeyedUnarchiver unarchiveObjectWithData:self.dream.tags.tagsArray];
    NSMutableArray *hashedTagArray = [[NSMutableArray alloc] init];
    
    for (NSString *hashit in tagsArray)
    {
        NSString *rehashedTag = [NSString stringWithFormat:@"#%@", hashit];
        [hashedTagArray addObject:rehashedTag];
    }
    
    self.textField.text = [hashedTagArray componentsJoinedByString: @" "];
    self.textView.text = self.dream.dreamContent;
    self.titleTextView.text = self.dream.dreamTitle;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/recording.m4a", self.dream.pathToFolder]])
    {
        self.playButton.enabled = NO;
    } else {
        self.playButton.enabled = YES;
    }
}

#pragma textEditing/KeyboardToolBar
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:self.stringHolder])
    {
        textField.text = [NSString stringWithFormat:@"%@#%@", self.stringHolder, [textField.text substringFromIndex:[self.stringHolder length]]];
        [dreamTags addObject:[textField.text substringFromIndex:[self.stringHolder length]]];
        NSLog(@"TAGS: %@", dreamTags);
    }
    
    if ([textField.text characterAtIndex:([textField.text length] - 1)] != ' ')
    {
        textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
    }
    
    self.stringHolder = textField.text;
    
    return YES;
}

-(void)textFieldDidChange
{
    if ([self.textField.text length] < [self.stringHolder length])
    {
        int textFieldLength = [self.textField.text length];
        
        for (int i = textFieldLength - 1; i >= 0; i--)
        {
            if ([self.textField.text characterAtIndex:i] == '#')
            {
                self.textField.text = [self.textField.text substringToIndex:i];
                break;
            }
        }
        self.stringHolder = self.textField.text;
    }
}

- (void)resignKeyboard:(id)sender
{
    if ([self.textField isFirstResponder])
    {
        [self.textField resignFirstResponder];
    } else if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
}
- (IBAction)playTapped:(id)sender
{
    [self.playButton setEnabled:YES];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSString *pathToRecording = [NSString stringWithFormat:@"%@/recording.m4a", self.dream.pathToFolder];
    NSURL *recordingURL = [NSURL fileURLWithPath:pathToRecording];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordingURL error:nil];

    [player setDelegate:self];
    [player play];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addComment"])
    {
        CommentTableViewController *commentTableViewController = [segue destinationViewController];
        commentTableViewController.dream = self.dream;
    }
}


@end
