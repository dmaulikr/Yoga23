//
//  NotesModalController.m
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//

#import "NotesModalController.h"

@interface NotesModalController ()

@end

@implementation NotesModalController

@synthesize delegate = _delegate, notesText = _notesText, notesTextView = _notesTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidUnload {
    
    self.notesTextView = nil;
    [super viewDidUnload];
}

-(IBAction)finishEditing {
   
    [self.delegate performSelector:@selector(notesDone)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_notesTextView) {
        _notesTextView.delegate = self;
    }
    
    CGRect textViewFrame = CGRectMake(0.0, 0.0, 500.0, 500.0);
    _notesTextView.frame = textViewFrame;
    [_notesTextView setFont:[UIFont systemFontOfSize:18.0]];
    
    // get to the New Programm data storage in AppDelegate class
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.notesText = [appDelegate.theNewProgram objectForKey:@"notes"];
    
    _notesTextView.text = _notesText;
    [_notesTextView setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if (![self.notesText isEqualToString:textView.text]) {
        self.notesText = [NSMutableString stringWithString:textView.text];
        [self.notesText appendString:@"\n\n"];
        
        // set text into programm entity
        AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.theNewProgram setObject:self.notesText forKey:@"notes"];
    }
    
    

    return YES;
   
}


- (void) viewDidAppear:(BOOL)animated {
    
    [self.notesTextView becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
