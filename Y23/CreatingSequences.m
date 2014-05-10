//
//  CreatingSequences.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreatingSequences.h"
#import "QuartzCore/QuartzCore.h"
#import "PIAsanaView.h"
#import "UIView+Animation.h"
#import "NotesModalController.h"
#import "FFTransAlertView.h"
#import "CSAsanaViewController.h"

@interface CreatingSequences () <HideNotesViewProtocol>

@end

#define aSViewSize 116
#define aImageSize 112

@implementation CreatingSequences

@synthesize currentSequenceViews = _currentSequenceViews;


- (id)initWithAsanas:(NSMutableArray *)asanas
{
    self = [super init];
    if (self) {
        allAsanas = asanas;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!appDelegate) {
            appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
            sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
            trackedObjects = [NSMutableArray array];
            addedAsanas = appDelegate.unsavedSequence;
        }
    }
    return self;
}

- (void)setAddedAsanas:(NSMutableArray *)views {
    
    appDelegate.unsavedSequence = views;
    addedAsanas = appDelegate.unsavedSequence;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // adding "Notes" and "To sort" button
    //appDelegate.unsavedSequence = addedAsanas;
    
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Creating sequences (%d)", @""), [sequences count]];
    
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:NSLocalizedString(@"Notes", @"") style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(addNotes)];
    
    UIBarButtonItem *doneButton          = [[UIBarButtonItem alloc] 
                                            initWithTitle:NSLocalizedString(@"To sort", @"") style:UIBarButtonItemStylePlain
                                            target:self action:@selector(toSorting)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 30.0;
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:doneButton,fixedSpace, notesButton, nil];
    
    
    counterBG = [UIImage imageNamed:@"numberPic"];
    [self.view addSubview:[self addScrollView]]; // adding all images to main view
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [appDelegate pageTrackingGA:@"Creating sequences"];
}



#pragma mark - Asanas Images Scrollview adding 

- (UIScrollView *)addScrollView {
    
    if (!allAsanas) {
        allAsanas = [NSMutableArray array];
    }else {
        [allAsanas removeAllObjects];
    }

    NSArray *allKeys = [appDelegate.selectedAsanas allKeys] ;
    //dPrint(@"allNames is %@", allKeys);
    NSMutableArray *sortedNumbers = [NSMutableArray array];
    for (NSString *imageName in allKeys) {
        
        NSNumber *numberKey = [NSNumber numberWithInt:[imageName intValue]];
        [sortedNumbers addObject:numberKey];
    }

    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    [sortedNumbers sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    //.dPrint(@"allNames is %@", sortedNumbers);
    
    
    for (NSNumber *keyNumber in sortedNumbers) {
        
        [allAsanas addObject:[appDelegate.selectedAsanas objectForKey:[keyNumber stringValue]]];
    }
    
    asanasCount = [allAsanas count];
    controllersContainer = [NSMutableArray array];
    
    
    unsigned lineCount; // define line count for each 9 asanas
    lineCount = asanasCount / 6;
    if (asanasCount%6 != 0) {
        lineCount ++;
    }
    // creating scrollview and its contentview
    CGRect scrollFrame = CGRectMake(0, 16, self.view.frame.size.width, self.view.frame.size.height - 119);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    CGRect contentFrame = CGRectMake(36, 0, 748, (lineCount*aSViewSize)+ 100);
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    scrollView.contentSize = CGSizeMake(contentView.frame.size.width,contentView.frame.size.height);
    
    NSUInteger c = 0; // c is number of images
    for (unsigned i = 1; i < lineCount*aSViewSize; i+= aSViewSize) {
        
        
        for (unsigned a = 0; a <= aSViewSize*5; a += aSViewSize) {
            
            CGRect asanaViewFrame = CGRectMake( a, i, aSViewSize - 4.0 , aSViewSize - 4.0);
            
            if (c < [allAsanas count]) {
                
                CSAsanaViewController *asanaController = [[CSAsanaViewController alloc] init];
                asanaController.view.frame = asanaViewFrame;
                [trackedObjects addObject:asanaController];
                // find asanas identifier
                NSArray *key = [appDelegate.selectedAsanas allKeysForObject:[allAsanas objectAtIndex:c]];
                NSString *number = [appDelegate.asanasCounter objectForKey:[key objectAtIndex:0]];
                asanaController.asanaKey = [key objectAtIndex:0];
                
                if (!number) {
                    asanaController.countView.hidden = YES;
                }else {
                    asanaController.countLabel.text = number;
                }
                
                asanaController.button.tag = c;
                
                CALayer *buttonLayer = [asanaController.button layer];
                [buttonLayer setMasksToBounds:YES];
                [buttonLayer setCornerRadius:0.0];
                [buttonLayer setBorderWidth:1.0];
                [buttonLayer setBorderColor:[[UIColor grayColor] CGColor]];
                // set action for tap on asana button
                [asanaController.button addTarget:self action:@selector(checkAsanaForSequence:) forControlEvents:UIControlEventTouchUpInside];
                
                UIImage *asanaSourceImage = [allAsanas objectAtIndex:c];
                UIImage *asanaImage = [UIImage imageWithCGImage:[asanaSourceImage CGImage] scale:0.7 orientation:UIImageOrientationUp];
                [asanaController.button setImage:asanaImage forState:UIControlStateNormal]; // add asana image to button after scaling
                [contentView addSubview:asanaController.view];
                [controllersContainer addObject:asanaController];
                
            }
            c++;
        }
    }
    if ([appDelegate.theNewProgram objectForKey:@"asanas"]) {
        sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
    }
    //dPrint(@"sequences is %@", sequences);
    [scrollView addSubview:contentView];
    return (scrollView);
}

#pragma mark - Asanas view adding end checked to down view

- (void)checkAsanaForSequence:(id)sender {
    
   
    int asanasNumber = [addedAsanas count];

    if (asanasNumber == 42) {
        // warning massage here
        CustomAlert *tooManyAsanas = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"Too many asanas selected..", @"")
                                                           message:NSLocalizedString(@"42 is a limit of asanas number", @"")
                                                          delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                                 otherButtonTitles:nil];
        [tooManyAsanas show];
        [appDelegate eventTrackingGA:@"Creating sequences" andAction:@"Too many asanas alert" andLabel:nil];
        return;
    }
    
    
    // create asana object
    UIButton *senderButton = (UIButton*)sender;
    [appDelegate eventTrackingGA:@"Creating sequences" andAction:@"Added to sequence" andLabel:[NSString stringWithFormat:@"Asana number is %d",(senderButton.tag + 1)]];
    CSAsanaViewController *asController = [trackedObjects objectAtIndex:senderButton.tag];
    UIImage *asanaImage = [asController.button imageForState:UIControlStateNormal];
    CGRect asanaImageViewFrame = CGRectMake( 0, 0, aImageSize, aImageSize );
    UIImageView *asanaImageView = [[UIImageView alloc] initWithFrame:asanaImageViewFrame];
    [asanaImageView setImage:asanaImage];
    asanaImageView.tag = [asController.asanaKey integerValue];
    //
    NSString *asanaKey = asController.asanaKey;
    NSString *number = [appDelegate.asanasCounter objectForKey:asanaKey];
    
    if (!number) {
        number = @"1";
        asController.countView.alpha = 0.0;
        asController.countView.hidden = NO;
        
        [UIView animateWithDuration:0.5
                         animations:^{asController.countView.alpha = 1.0;}
                         completion:nil];
        
        asController.countLabel.text = @"1";
        [appDelegate.asanasCounter setObject:number forKey:asanaKey];
    
    }else {
        number = [appDelegate.asanasCounter objectForKey:asanaKey];
        NSString *newNumber = [NSString stringWithFormat:@"%d",([number integerValue] +1)];
        [appDelegate.asanasCounter setObject:newNumber forKey:asanaKey];
         asController.countLabel.alpha = 0.0;
        asController.countLabel.text = newNumber;
        
        [UIView animateWithDuration:0.5
                         animations:^{asController.countLabel.alpha = 1.0;}
                         completion:nil];
    }
    //
    

    // copy for animation
    UIView *animatedView = [[sender superview] copyWithImageView:asanaImageView];
    animatedView.frame = [[sender superview] frame];
    [[[sender superview] superview] addSubview:animatedView];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         animatedView.center = CGPointMake(770.0, 250.0);
                     }
                     completion:^(BOOL fin) { if (fin) [animatedView removeFromSuperview];}];
    
    PIAsanaView *asanaItem = [[PIAsanaView alloc] init];
    asanaItem.identificator = asanaKey;
    UIImageView *asanaImageViewItem = [[UIImageView alloc] initWithFrame:asanaImageViewFrame];
    [asanaImageViewItem setImage:asanaImage];

    
    [asanaItem addSubview:asanaImageViewItem];
    [addedAsanas addObject:asanaItem];

    


    
   // dPrint(@"image number for current sequense %i", [[sender superview] tag]);
    
}

- (void)increaseCounterOfAsana:(NSString*)asanaID {  // not work, example
    
    NSString *number = [appDelegate.asanasCounter objectForKey:asanaID];
    if (!number) {
        number = @"1";
        [appDelegate.asanasCounter setObject:number forKey:number];
        
    }else {
        number = [appDelegate.asanasCounter objectForKey:number];
        NSString *newNumber = [NSString stringWithFormat:@"%d",([number integerValue] +1)];
        [appDelegate.asanasCounter setObject:newNumber forKey:number];
        
    }

}




- (void)toSorting {
    
    [appDelegate eventTrackingGA:@"Creating sequences" andAction:@"To Sorting" andLabel:[NSString stringWithFormat:@"Number of asanas %d",[addedAsanas count]]];
    
    if ([addedAsanas count] == 0) {
        // warning massage here
        CustomAlert *noAsanas = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"No asanas selected..", @"")
                                                           message:NSLocalizedString(@"Tap to select asanas you need.", @"")
                                                          delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                                 otherButtonTitles:nil];
        [noAsanas show];
        return;
    }
    SortAsanasController *sac = [[SortAsanasController alloc] init];
    //dPrint(@" addedAsanas -  %@", addedAsanas);
    sac -> sequence = addedAsanas;
    sac.delegate = self;
    [self.navigationController pushViewController:sac animated:YES];



}

#pragma mark Adding sorted sequence to AppDelegate array

- (void)saveSequence:(UIImage *)sortedSequence {
    // Saving sorted sequence to final asanas array
    sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
    if (!sequences) {
        [appDelegate.theNewProgram setObject:[NSMutableArray array] forKey:@"asanas"];
        sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
    }
    
    [sequences addObject:sortedSequence];
   
    [addedAsanas removeAllObjects];
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Creating sequences (%d)", @""), [sequences count]];
    // dPrint(@"appDelegate asanas array %@", appDelegate.theNewProgram);
    
}



#pragma mark Adding Notes to AppDelegate array

-(void)addNotes {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Get Notes" andLabel:@"Creating sequences"];
    
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
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Hide Notes" andLabel:@"Creating sequences"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    for (CSAsanaViewController *asanaController in controllersContainer) {
        NSString *number = [appDelegate.asanasCounter objectForKey:asanaController.asanaKey];
        if (!number) {
            asanaController.countView.hidden = YES;
        }else {
            asanaController.countLabel.text = number;
        }
    }
}

- (void)didDismissModalView {
    
   [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

@end
