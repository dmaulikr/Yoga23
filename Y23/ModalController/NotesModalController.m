//
//  NotesModalController.m
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//

#import "NotesModalController.h"
#import "AppDelegate.h"

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
    appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.notesText = [appDelegate.theNewProgram objectForKey:@"notes"];
    
    if ([_notesText isEqualToString:NSLocalizedString(@"Type notes here..", @"")]) {
        _notesTextView.textColor = [UIColor lightGrayColor];
    }
    else _notesTextView.textColor = [UIColor blackColor];
    
    
    _notesTextView.text = _notesText;
    [_notesTextView setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (text.length > 1 && [textView.text isEqualToString:NSLocalizedString(@"Type notes here..", @"")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }

    return YES;
}


//- (void)textViewDidChangeSelection:(UITextView *)textView{
//    
//    if ([_notesTextView.text isEqualToString:NSLocalizedString(@"Type notes here..", @"")] && [_notesTextView.textColor isEqual:[UIColor lightGrayColor]])[_notesTextView setSelectedRange:NSMakeRange(0, 0)];
//    
//}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:NSLocalizedString(@"Type notes here..", @"")] && [textView.textColor isEqual:[UIColor lightGrayColor]]){
        [textView setSelectedRange:NSMakeRange(0, 0)];
        
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0 && [[textView.text substringFromIndex:1] isEqualToString:NSLocalizedString(@"Type notes here..", @"")] && [textView.textColor isEqual:[UIColor lightGrayColor]]){
        textView.text = [textView.text substringToIndex:1];
        textView.textColor = [UIColor blackColor];
        
    }
    else if(textView.text.length == 0){
        textView.text = NSLocalizedString(@"Type notes here..", @"");
        textView.textColor = [UIColor lightGrayColor];
        [textView setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"Type notes here..", @"");
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    
    if (![self.notesText isEqualToString:textView.text]) {
        self.notesText = [NSMutableString stringWithString:textView.text];
        [self.notesText appendString:@"\n\n"];
        
        // set text into programm entity
        [appDelegate.theNewProgram setObject:self.notesText forKey:@"notes"];
    }
    
    

    return YES;
   
}


- (void) viewDidAppear:(BOOL)animated {
    
    // Google An
    [appDelegate pageTrackingGA:@"Notes"];
    
    [self.notesTextView becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
