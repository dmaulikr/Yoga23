//
//  PersonalDataController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonalDataController.h"
#import "NotesModalController.h"
#import "AppDelegate.h"
#import "CSTipsViewController.h"

@interface PersonalDataController () <HideNotesViewProtocol>

@end


@implementation PersonalDataController

@synthesize firstName = _firstName, lastName = _lastName, eMail = _eMail, notes = _notes;
@synthesize personalData = _personalData;


#pragma RemoveTipViewsProtocol method

- (void)removeTips {
    [tpvc.view removeFromSuperview];
    tpvc = nil;
    [_firstName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
}

- (IBAction)closeKeyboard:(id)sender {
    
    for (UITextField *field in fieldsArray) {
        if ([field isEditing]) {
            [field resignFirstResponder];
            break;
        }
    }
}

- (IBAction)segmentControlClicked:(id)sender {
    
    if (!segmentControl) {
        segmentControl = (UISegmentedControl*)sender;
    }
    
    if (segmentControl.selectedSegmentIndex == 1) {
        [self nextField];
    }else {
         [self prevField];
    }
    
    
}

- (void)nextField {
    
    int s;
    
    for (UITextField *field in fieldsArray) {
        if ([field isEditing]) {
            s = [fieldsArray indexOfObject:field];
            break;
        }
    }
   
    //NSLog(@" fieldsArray - %@next s - %d",fieldsArray, s);
    if (s == 0) {
        [self unselectSegmentControl];
    }
    
    if (s != 2) {
        [[fieldsArray objectAtIndex:s + 1] becomeFirstResponder];
    }
    
}

- (void)prevField {
    
    int s;
    
    for (UITextField *field in fieldsArray) {
        if ([field isEditing]) {
            s = [fieldsArray indexOfObject:field];
            break;
        }
    }
    NSLog(@"prev s - %d", s);
    if (s == 2) {
        [self unselectSegmentControl];
    }
    
    [[fieldsArray objectAtIndex:s - 1] becomeFirstResponder];
    
}

- (void)unselectSegmentControl {
    
    segmentControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    
}

- (void)viewDidUnload
{
    
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
    
    // get to the New Programm data storage in AppDelegate class
    appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
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
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 83.0;
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:fixedSpace,notesButton, nil];
    
    // first launch Guide
//    NSUserDefaults *standartUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *firstLaunch = [standartUserDefaults objectForKey:@"FirstLaunch"];
//    if (!firstLaunch) {
//        [standartUserDefaults setObject:@"was" forKey:@"FirstLaunch"];
//        [self showGuide];
//    }
    
    _firstName.keyboardAppearance = UIKeyboardAppearanceAlert;
    _firstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _lastName.keyboardAppearance = UIKeyboardAppearanceAlert;
    _lastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    _eMail.keyboardType = UIKeyboardTypeEmailAddress;
    
    
    fieldsArray = @[_firstName,_lastName,_eMail];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //NSLog(@"first name from delegate - %@",[[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"firstName"]);
    _firstName.text = [[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"firstName"];
    _lastName.text = [[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"lastName"];
    _eMail.text = [[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"eMail"];
    
    //NSLog(@"first name - %@, last - %@, emial - %@", _firstName, _lastName, _eMail);
    //fieldsArray = @[_firstName,_lastName,_eMail];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [appDelegate pageTrackingGA:@"PersonalView"];
    
    // if first launch
    if (![appDelegate retrieveFromUserDefaults:@"PersonalScreen_FirstTime"]) {
        [appDelegate saveToUserDefaults:@"NO" forKey:@"PersonalScreen_FirstTime"];
        tpvc = [[CSTipsViewController alloc] initWithSender:@"Personal"];
        tpvc.viewDelegate = self;
        tpvc.view.frame = CGRectMake(0.0,0.0,768.0,1000.0);
        [self.view addSubview:tpvc.view];
    }else {
        
        [_firstName becomeFirstResponder];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [textField setInputAccessoryView:keyboardToolBar];
    
    if (textField == _firstName) {
        segmentControl.selectedSegmentIndex = 0;
    }else if (textField == _eMail) {
        segmentControl.selectedSegmentIndex = 1;
    }else {
        segmentControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
    
    if (textField == self.firstName) {
        // Google An
        [appDelegate eventTrackingGA:@"Personal Data" andAction:@"Text field begin editing" andLabel:@"First Name"];
    }else if (textField == self.lastName) {
        // Google An
        [appDelegate eventTrackingGA:@"Personal Data" andAction:@"Text field begin editing" andLabel:@"Last Name"];
    }else if (textField == self.eMail) {
        // Google An
        [appDelegate eventTrackingGA:@"Personal Data" andAction:@"Text field begin editing" andLabel:@"Email"];
    }
    
    
    
    
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
        //NSLog(@"personalData 1 from delegate - %@ text - %@",[appDelegate.theNewProgram objectForKey:@"personal"],self.firstName.text);
        [self.personalData setObject:[NSString stringWithString:self.firstName.text] forKey:@"firstName"];
        //NSLog(@"personalData2 from delegate - %@",[appDelegate.theNewProgram objectForKey:@"personal"] );
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
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Get Notes" andLabel:@"Personal"];
    
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
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Hide Notes" andLabel:@"Personal"];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
  
}


- (void)dealloc {
    keyboardToolBar = nil;
    self.firstName = nil;
    self.lastName  = nil;
    self.eMail = nil;
    self.notes = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
