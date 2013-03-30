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

@implementation Technics

@synthesize selectedTechnics = _selectedTechnics, person = _person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

    // parse plist with technics
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Technics" ofType:@"plist"];
    allTechnics =[[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    // an array for the results of selection
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.selectedTechnics = [appDelegate.theNewProgram objectForKey:@"technics"];
    NSLog(@"appDelegate theNewProgramm is %@", appDelegate.theNewProgram);
    
    for (NSInteger i = 0; i < [allTechnics count]; ++i)
    {
        [self.selectedTechnics addObject:[NSNull null]];
    }
    NSLog(@" allTechnics is %d", [allTechnics count]);

    
    // create subview of main view
    int x = 0; //  width coordinate
    int y = 0; // first height coordinate    
    int elementTag = 0; // tag for identification
    
    for (id plistElement in allTechnics) {
        
        y = y + 65; // line view y coordinate
        
        // setup line view with text, checkbox and Go-button if required :
        CGRect viewFrame = CGRectMake( x, y, 768, 50 );
        CGRect labelFrame = CGRectMake( 80, 20, 480, 30 );
        CGRect checkBoxFrame = CGRectMake( 580, 16, 40, 40 );
        
        UIView *cellView= [[UIView alloc] initWithFrame:viewFrame];
        cellView.backgroundColor = [UIColor clearColor];
        cellView.tag = elementTag;
        CheckBoxButton *checkBox = [[CheckBoxButton alloc] initWithFrame:checkBoxFrame];
        [checkBox setImage:[UIImage imageNamed:@"WhiteCBox.png"] 
                  forState:UIControlStateNormal];
        checkBox.tag = elementTag;
        [checkBox addTarget:self action:@selector(addProgramItem:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        // setup line label:
        UILabel *labelString = [[UILabel alloc] initWithFrame:labelFrame];
        labelString.textColor = [UIColor whiteColor];
        labelString.font = [UIFont fontWithName:@"Chalkduster" size:22.0];
        labelString.backgroundColor = [UIColor clearColor];
        // if just string element from plist:       
        if ([plistElement isKindOfClass:[NSString class]]) {
            
            labelString.text = plistElement;
            
        } 
        // if there are nested elements inside:
        else if ([plistElement isKindOfClass:[NSDictionary class]]) {
            
            NSArray *dictKeyString = [plistElement allKeys];
            labelString.text = [dictKeyString objectAtIndex:0];
         // add button for next view with elements  
            CGRect goButtonFrame = CGRectMake( 640, 16, 40, 40 );
            UIButton *goButton = [[UIButton alloc] initWithFrame:goButtonFrame];
            goButton.tag = elementTag;
            [goButton setEnabled:NO];
            [goButton setImage:[UIImage imageNamed:@"WhiteAButton.png"] 
                      forState:UIControlStateNormal];
            [goButton addTarget:self action:@selector(goTechnicDetails:) forControlEvents:UIControlEventTouchUpInside];
            [cellView addSubview:goButton];
        }
        
        [cellView addSubview:labelString];
        [cellView addSubview:checkBox];
        [self.view addSubview:cellView];
        
        elementTag++;
    }
    // adding Notes button
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:notesButton, nil];
    
}

- (void) addProgramItem: (CheckBoxButton *)sender {
    
    [sender onClicked];
    id element = [allTechnics objectAtIndex:sender.tag]; // get an element
    
    if (sender.checked) {
        
        if ([element isKindOfClass:[NSString class]]) {  // if string element, add to selected List
            
            [self.selectedTechnics replaceObjectAtIndex:sender.tag withObject:element]; 
        }
        
        if ([element isKindOfClass:[NSDictionary class]]) { 
            
            // if there are nested elements - activated arrow button after checking
            UIView *viewAtTag = (UIView*)[self.view viewWithTag:sender.tag];
            UIButton *arrow = [[viewAtTag subviews] objectAtIndex:0];
            [arrow setEnabled:YES];            
        }
    }
    else {
        
        if ([element isKindOfClass:[NSString class]]) {  // remove element from selected List
            [self.selectedTechnics replaceObjectAtIndex:sender.tag withObject:[NSNull null]];
        }
        
        if ([element isKindOfClass:[NSDictionary class]]) {
            
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
   
    
    TechnicDetails *td = [[TechnicDetails alloc] initWithName:name elements:elements tag:index];

    [self.navigationController pushViewController:td animated:YES];
    
}

#pragma mark Adding Notes to AppDelegate array

-(void)addNotes {
    
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
    
    if ([self respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [self presentModalViewController:navController animated:YES];
    }else {
        [self presentViewController:navController animated:YES completion:nil];
    }
    
    nmc.delegate = self;
    
    
    navController.view.superview.center = self.view.center;
}

-(void)notesDone {
    
    if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [self dismissModalViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



- (void)viewWillAppear:(BOOL)animated {
    
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
