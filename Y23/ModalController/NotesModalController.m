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
    self.notesText = nil;
    [super viewDidUnload];
}

-(IBAction)finishEditing {
   
    [self.delegate performSelector:@selector(notesDone)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.notesTextView) {
        self.notesTextView.delegate = self;
    }
    
    CGRect textViewFrame = CGRectMake(0.0, 0.0, 500.0, 500.0);
    self.notesTextView.frame = textViewFrame;
    [self.notesTextView setFont:[UIFont systemFontOfSize:18.0]];
    
    // get to the New Programm data storage in AppDelegate class
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.notesText = [appDelegate.theNewProgram objectForKey:@"notes"];
    
    self.notesTextView.text = self.notesText;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                               target:self.delegate
                                              action:@selector(notesDone)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
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


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.view.superview.bounds = CGRectMake(0, 0, 600, 750);  // your size here
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
