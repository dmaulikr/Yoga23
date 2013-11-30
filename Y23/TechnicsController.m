//
//  Technics.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TechnicsController.h"
#import "AppDelegate.h"
#import "NotesModalController.h"


@interface Technics () <HideNotesViewProtocol>

@end

@implementation Technics

@synthesize selectedTechnics = _selectedTechnics, person = _person;
@synthesize clearing = _clearing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _clearing = NO;
   
    [self.view addSubview:[self renewTechnicsView]];
  
    
    // adding Notes button
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 83.0;
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:fixedSpace,notesButton, nil];
    
}

- (UIView*)renewTechnicsView {
    
    if (contentView) {
        [contentView removeFromSuperview];
        contentView = nil;
    }
    
    
    contentView = [[UIView alloc] initWithFrame:self.view.frame];
    

    
    // parse plist with technics
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Technics" ofType:@"plist"];
    allTechnics =[[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    // an array for the results of selection
    self.selectedTechnics = [appDelegate.theNewProgram objectForKey:@"technics"];
    //NSLog(@"appDelegate theNewProgramm is %@", appDelegate.theNewProgram);
    
    
    for (NSInteger i = 0; i < [allTechnics count]; ++i)
    {
        [self.selectedTechnics addObject:[NSNull null]];
    }

    
   
    //NSLog(@" allTechnics is %d", [allTechnics count]);
    
    
    // create subview of main view
    int x = 0; //  width coordinate
    int y = 0; // first height coordinate
    int elementTag = 0; // tag for identification
    
    for (id plistElement in allTechnics) {
        
        y = y + 65; // line view y coordinate
        
        // setup line view with text, checkbox and Go-button if required :
        CGRect viewFrame = CGRectMake( x, y, 768, 50 );
        CGRect labelFrame = CGRectMake( 80, 20, 480, 30 );
        
        UIView *cellView= [[UIView alloc] initWithFrame:viewFrame];
        cellView.backgroundColor = [UIColor clearColor];
        cellView.tag = elementTag;

        
        // setup line label:
        UILabel *labelString = [[UILabel alloc] initWithFrame:labelFrame];
        labelString.textColor = [UIColor whiteColor];
        labelString.font = [UIFont fontWithName:@"Chalkduster" size:22.0];
        labelString.backgroundColor = [UIColor clearColor];
        // if just string element from plist:
        if ([plistElement isKindOfClass:[NSString class]]) {
            
            labelString.text = plistElement;
            CGRect checkBoxFrame = CGRectMake( 620, 16, 40, 40 );
            CheckBoxButton *checkBox = [[CheckBoxButton alloc] initWithFrame:checkBoxFrame];
            [checkBox setImage:[UIImage imageNamed:@"WhiteCBox.png"]
                      forState:UIControlStateNormal];
            checkBox.tag = elementTag;
            [checkBox addTarget:self action:@selector(addProgramItem:) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:checkBox];
        }
        // if there are nested elements inside:
        else if ([plistElement isKindOfClass:[NSDictionary class]]) {
            
            NSArray *dictKeyString = [plistElement allKeys];
            labelString.text = [dictKeyString objectAtIndex:0];
            // add button for next view with elements
            CGRect goButtonFrame = CGRectMake( 640, 16, 40, 40 );
            UIButton *goButton = [[UIButton alloc] initWithFrame:goButtonFrame];
            goButton.tag = elementTag;
            [goButton setEnabled:YES];
            [goButton setImage:[UIImage imageNamed:@"WhiteAButton.png"]
                      forState:UIControlStateNormal];
            [goButton addTarget:self action:@selector(goTechnicDetails:) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:goButton];
        }
        [cellView addSubview:labelString];
        [contentView addSubview:cellView];        
        elementTag++;
    }
    
    return contentView;
    
}

- (void) addProgramItem: (CheckBoxButton *)sender {
    
    [sender onClicked];
    id element = [allTechnics objectAtIndex:sender.tag]; // get an element
    
    if (sender.checked) {
        
        if ([element isKindOfClass:[NSString class]]) {  // if string element, add to selected List
            // Google An
            [appDelegate eventTrackingGA:@"Technics" andAction:@"Technic Checked" andLabel:[NSString stringWithFormat:@"%@",element]];
            [self.selectedTechnics replaceObjectAtIndex:sender.tag withObject:element]; 
        }
        
        if ([element isKindOfClass:[NSDictionary class]]) { 
            // if there are nested elements - activated arrow button after checking
            // Google An
            [appDelegate eventTrackingGA:@"Technics" andAction:@"Technic group Checked" andLabel:[NSString stringWithFormat:@"tag %d",sender.tag]];
            UIView *viewAtTag = (UIView*)[self.view viewWithTag:sender.tag];
            UIButton *arrow = [[viewAtTag subviews] objectAtIndex:0];
            [arrow setEnabled:YES];            
        }
    }
    else {
        
        if ([element isKindOfClass:[NSString class]]) {  // remove element from selected List
            // Google An
            [appDelegate eventTrackingGA:@"Technics" andAction:@"Technic Unchecked" andLabel:[NSString stringWithFormat:@"%@",element]];
            [self.selectedTechnics replaceObjectAtIndex:sender.tag withObject:[NSNull null]];
        }
        
        if ([element isKindOfClass:[NSDictionary class]]) {
            // Google An
            [appDelegate eventTrackingGA:@"Technics" andAction:@"Technic group Unchecked" andLabel:[NSString stringWithFormat:@"tag %d",sender.tag]];
            // if there are nested elements - deactivated arrow button after unchecking
            UIView *viewAtTag = (UIView*)[self.view viewWithTag:sender.tag];
            UIButton *arrow = [[viewAtTag subviews] objectAtIndex:0];
            [arrow setEnabled:NO];
        }
        
    }
}

- (void) goTechnicDetails: (UIButton *)sender {
    
    
    int index = [sender tag];
    NSString *name = [[[allTechnics objectAtIndex:index] allKeys] objectAtIndex:0];
    NSArray *elements = [[allTechnics objectAtIndex:index] valueForKey:name];
   
    // Google An
    [appDelegate eventTrackingGA:@"Technics" andAction:@"Technic go Details" andLabel:[NSString stringWithFormat:@"%@",name]];

    
    TechnicDetails *td = [[TechnicDetails alloc] initWithName:name elements:elements tag:index];

    [self.navigationController pushViewController:td animated:YES];
    
}

#pragma mark Adding Notes to AppDelegate array

-(void)addNotes {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Get Notes" andLabel:@"Technics"];
    
    NotesModalController *nmc = [[NotesModalController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:nmc];
    
    // do any setup you need for navController
    navController.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    nmc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                             target:self
                                             action:@selector(notesDone)];
    nmc.navigationItem.title = @"NOTES";
    

    [self presentViewController:navController animated:YES completion:nil];

    
    nmc.delegate = self;
    
    
    navController.view.superview.center = self.view.center;
}

-(void)notesDone {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Hide Notes" andLabel:@"Technics"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewWillAppear:(BOOL)animated {

    // clear if needed
    if (_clearing) {
        _clearing = NO;
        [self.view addSubview:[self renewTechnicsView]];
    }
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [appDelegate pageTrackingGA:@"Technics MainView"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
