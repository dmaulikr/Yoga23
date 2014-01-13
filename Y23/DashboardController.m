//
//  DashboardController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DashboardController.h"
#import "NotesModalController.h"
#import "AppDelegate.h"

@interface DashboardController () <HideNotesViewProtocol>

@end

@implementation DashboardController

@synthesize person = _person;

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

#pragma mark Adding Notes to AppDelegate array

-(void)addNotes {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Get Notes" andLabel:@"Dashboard"];
    
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
    nmc.navigationItem.title = NSLocalizedString(@"NOTES", @"");
    

    [self presentViewController:navController animated:YES completion:nil];
    
    nmc.delegate = self;
    
    
    navController.view.superview.center = self.view.center;
}

-(void)notesDone {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Hide Notes" andLabel:@"Dashboard"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma RemoveTipViewsProtocol method

- (void)removeTips {
    [tpvc.view removeFromSuperview];
    tpvc = nil;
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    // adding Notes button
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:NSLocalizedString(@"Notes", @"") style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 83.0;
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:fixedSpace,notesButton, nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [appDelegate pageTrackingGA:@"Technics MainView"];
    
    // if first launch
    if (![appDelegate retrieveFromUserDefaults:@"DashboardScreen_FirstTime"]) {
        [appDelegate saveToUserDefaults:@"NO" forKey:@"DashboardScreen_FirstTime"];
        tpvc = [[CSTipsViewController alloc] initWithSender:@"Dashboard"];
        tpvc.viewDelegate = self;
        tpvc.view.frame = CGRectMake(0.0,0.0,768.0,1000.0);
        [self.view addSubview:tpvc.view];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
#ifdef DEBUG
    
    if (tpvc) {
        [tpvc.view removeFromSuperview];
        tpvc = nil;
    }
    
#endif
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
