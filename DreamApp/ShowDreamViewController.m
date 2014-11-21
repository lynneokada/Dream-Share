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
#import "AddCommentViewController.h"
#import "ServerManager.h"
#import "CustomCommenttTableViewCell.h"

@interface ShowDreamViewController ()
{
    UIToolbar *keyboardToolBar;
    NSMutableArray *dreamTags;
    AVAudioPlayer *player;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) UIToolbar *keyboardToolBar;
@property (nonatomic, strong) NSString *stringHolder;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *noCommentsLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation ShowDreamViewController
{
    NSMutableArray *fetchedComments;
}
@synthesize keyboardToolBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    dreamTags = [[NSMutableArray alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleTextView.delegate = self;
    self.textView.delegate = self;
    self.textField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    
    NSLog(@"tags: %@", tagsArray);
    if (tagsArray.count == 0)
    {
        //MAKE PLACEHOLDER WHITE

    }
    
    for (NSString *hashit in tagsArray)
    {
        NSString *rehashedTag = [NSString stringWithFormat:@"#%@", hashit];
        [hashedTagArray addObject:rehashedTag];
    }
    
    self.textField.text = [hashedTagArray componentsJoinedByString: @" "];
    self.stringHolder = [NSString stringWithFormat:@"%@ ", self.textField.text];
    self.textView.text = self.dream.dreamContent;
    self.titleTextView.text = self.dream.dreamTitle;
    
    fetchedComments = [NSMutableArray new];
    [[ServerManager sharedManager] getCommentsWith:[self.dream valueForKey:@"db_id"] andCallbackBlock:^(NSArray *comments)
    {
        fetchedComments = [comments mutableCopy];
        [self.tableView reloadData];
    }];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/recording.m4a", self.dream.pathToFolder]])
    {
        self.playButton.enabled = NO;
    } else {
        self.playButton.enabled = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (fetchedComments.count < 1)
    {
        self.noCommentsLabel.hidden = NO;
    } else {
        self.noCommentsLabel.hidden = YES;
    }
    return [fetchedComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCommenttTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.name.text = [fetchedComments[indexPath.row] objectForKey:@"dreamerName"];
    cell.comment.text = [fetchedComments[indexPath.row] objectForKey:@"commentContent"];
    
    return cell;
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

- (IBAction)editTapped:(id)sender
{
    NSLog(@"button: %@", self.editButton.title);
    if ([self.editButton.title isEqualToString:@"edit"])
    {
        self.editButton.title = @"done";
        self.titleTextView.editable = YES;
        self.textView.editable = YES;
        self.textField.enabled = YES;
    }
    else if ([self.editButton.title isEqualToString: @"done"])
    {
        self.editButton.title = @"edit";
        self.titleTextView.editable = NO;
        self.textView.editable = NO;
        self.textField.enabled = NO;
    }
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textField)
    {
        [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-210) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textField)
    {
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self.tableView];
    if ([self.tableView indexPathForRowAtPoint:touchLocation])
    {
        return NO;
    }
    
    return YES;
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
        AddCommentViewController *addCommentViewController = [segue destinationViewController];
        addCommentViewController.dream = self.dream;
        addCommentViewController.dream_id = self.dream.db_id;
        addCommentViewController.fetchedComments = fetchedComments;
    }
}


@end
