//
//  PersonalDataController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonalDataController.h"
#import "NotesModalController.h"

@implementation PersonalDataController

@synthesize firstName = _firstName, lastName = _lastName, eMail = _eMail, notes = _notes;
@synthesize personalData = _personalData;

- (void)viewDidUnload
{
    self.firstName = nil;
    self.lastName  = nil;
    self.eMail = nil;
    self.notes = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set image icons for Personal Tab
    UIImage *personalIcon = [UIImage imageNamed:@"Personal@2x.png"];
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    item0.image = personalIcon;
    
    // set image icons for Asanas Tab
    UIImage *asanasIcon = [UIImage imageNamed:@"Asanas@2x.png"];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    item1.image = asanasIcon;
    
    // set image icons for Technics Tab
    UIImage *technicsIcon = [UIImage imageNamed:@"Technics@2x.png"];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    item2.image = technicsIcon;
    
    // set image icons for Dashboard Tab
    UIImage *dashboardIcon = [UIImage imageNamed:@"Dashboard@2x.png"];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    item3.image = dashboardIcon;
    
    // set image icons for Preview Tab
    UIImage *previewIcon = [UIImage imageNamed:@"Preview@2x.png"];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
    item4.image = previewIcon;
    
    // adding Notes button
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:notesButton, nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    _firstName.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.lastName.keyboardAppearance = UIKeyboardAppearanceAlert;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.firstName || theTextField == self.lastName || theTextField == self.eMail) {
        
        [theTextField resignFirstResponder];
        
    }
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
        
    if (!self.personalData) {
        
        // get to the New Programm data storage in AppDelegate class
        AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.personalData = [appDelegate.theNewProgram objectForKey:@"personal"];
        
        // set current date
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd/MM/YY HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        [self.personalData setObject:dateString forKey:@"createDate"]; 
      //  NSLog(@"%@",dateString);
    }
    if (textField == self.firstName )
    {
        [self.personalData setObject:self.firstName.text forKey:@"firstName"];

    }
    if (textField == self.lastName) {
        [self.personalData setObject:self.lastName.text forKey:@"lastName"];
    }
    if (textField == self.eMail) {
        [self.personalData setObject:self.eMail.text forKey:@"eMail"];
    }
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
