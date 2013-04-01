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





@interface CreatingSequences ()

@end

#define aSViewSize 116
#define aImageSize 112
#define debug NSLog

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // adding "Notes" and "To sort" button
    if (!appDelegate) {
       appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
        sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"Creating sequences (%d)", [sequences count]];
    
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(addNotes)];
    
    UIBarButtonItem *doneButton          = [[UIBarButtonItem alloc] 
                                            initWithTitle:@"To sort" style:UIBarButtonItemStylePlain
                                            target:self action:@selector(toSorting)];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:doneButton, notesButton, nil];
    
    
    
    [self.view addSubview:[self addScrollView]]; // adding all images to main view
    
}


#pragma mark - Asanas Images Scrollview adding 

- (UIScrollView *)addScrollView {
    
    if (!allAsanas) {
        allAsanas = [NSMutableArray array];
    }else {
        [allAsanas removeAllObjects];
    }

    NSMutableArray *allNames = [[appDelegate.selectedAsanas allKeys] mutableCopy];
    debug(@"allNames is %@", allNames);
    [allNames sortUsingSelector:@selector(compare:)];
    debug(@"allNames is %@", allNames);
    for (NSString *imageName in allNames) {
        
        [allAsanas addObject:[appDelegate.selectedAsanas objectForKey:imageName]];
    }
    
    asanasCount = [allAsanas count];
    
    
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
            CGRect buttonFrame = CGRectMake( 1, 1, aImageSize, aImageSize );
            
            if (c < [allAsanas count]) {
                
                UIView *asanaView = [[UIView alloc] initWithFrame:asanaViewFrame];
                UIButton *asanaButton = [[UIButton alloc] initWithFrame:buttonFrame];
                asanaView.tag = [[allAsanas objectAtIndex:c] tag];
                //debug(@"asanaView.tag %i", asanaView.tag);
                asanaButton.tag = c;
                CALayer *buttonLayer = [asanaButton layer];
                [buttonLayer setMasksToBounds:YES];
                [buttonLayer setCornerRadius:0.0];
                [buttonLayer setBorderWidth:1.0];
                [buttonLayer setBorderColor:[[UIColor grayColor] CGColor]];
                // set action for tap on asana button
                [asanaButton addTarget:self action:@selector(checkAsanaForSequence:) forControlEvents:UIControlEventTouchUpInside];
                [asanaView addSubview:asanaButton];
                
                
                UIImage *asanaSourceImage = [allAsanas objectAtIndex:c];
                UIImage *asanaImage = [UIImage imageWithCGImage:[asanaSourceImage CGImage] scale:0.7 orientation:UIImageOrientationUp];
                [asanaButton setImage:asanaImage forState:UIControlStateNormal]; // add asana image to button after scaling
                [contentView addSubview:asanaView];
            }
            c++;
        }
    }
    if ([appDelegate.theNewProgram objectForKey:@"asanas"]) {
        sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
    }
    debug(@"sequences is %@", sequences);
    [scrollView addSubview:contentView];
    return (scrollView);
}

#pragma mark - Asanas view adding end checked to down view

- (void)checkAsanaForSequence:(id)sender {
    if (!addedAsanas) {
        addedAsanas = [[NSMutableArray alloc] initWithCapacity:2.0];
    }
    int asanasNumber = [addedAsanas count];
    if (self.currentSequenceViews && !saved) {
        asanasNumber = [self.currentSequenceViews count] + [addedAsanas count];
    }
    if (asanasNumber == 42) {
        // warning massage here
        UIAlertView *tooManyAsanas = [[UIAlertView alloc] initWithTitle:@"Too many asanas selected.."
                                                           message:@"42 is a limit to the number of asanas!" 
                                                          delegate:nil cancelButtonTitle:@"Ok" 
                                                 otherButtonTitles:nil];
        [tooManyAsanas show];
        return;
    }
    // create asana object
    UIImage *asanaImage = [sender imageForState:UIControlStateNormal];
    CGRect asanaImageViewFrame = CGRectMake( 0, 0, aImageSize, aImageSize );
    UIImageView *asanaImageView = [[UIImageView alloc] initWithFrame:asanaImageViewFrame];
    [asanaImageView setImage:asanaImage];
    asanaImageView.tag = [[sender superview] tag];
    
    //
    
   

    // copy for animation choicing
    UIView *animatedView = [[sender superview] copyWithImageView:asanaImageView];
    animatedView.frame = [[sender superview] frame];
    [[[sender superview] superview] addSubview:animatedView];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         animatedView.center = CGPointMake(770.0, 250.0);
                     }
                     completion:^(BOOL fin) { if (fin) [animatedView removeFromSuperview];}];
    
    PIAsanaView *asanaItem = [[PIAsanaView alloc] init];
    UIImageView *asanaImageViewItem = [[UIImageView alloc] initWithFrame:asanaImageViewFrame];
    [asanaImageViewItem setImage:asanaImage];

    
    [asanaItem addSubview:asanaImageViewItem];
    [addedAsanas addObject:asanaItem];

    debug(@" CreatingSequences %@", [self performSelector:@selector(currentSequenceViews)]);


    
   // debug(@"image number for current sequense %i", [[sender superview] tag]);
    
}




- (void)toSorting {
    
    
    if ([addedAsanas count] < 10) {
        
        if ([addedAsanas count] == 0) {
            // warning massage here
            UIAlertView *noAsanas = [[UIAlertView alloc] initWithTitle:@"No asanas selected.."
                                                               message:@"You have not selected any asana!" 
                                                              delegate:nil cancelButtonTitle:@"Ok" 
                                                     otherButtonTitles:nil];
            [noAsanas show];
            return;
        }else {
            
            // one more warning massage
        }
    }
    
    SortAsanasController *sac = [[SortAsanasController alloc] init];
    
    // sorting elements as image No.
 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag"
                                                                   ascending:YES] ;
    NSArray *sortedArray = [addedAsanas sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    if (self.currentSequenceViews && !saved) {
         [self.currentSequenceViews addObjectsFromArray:sortedArray];
    }else {
        self.currentSequenceViews = [NSMutableArray arrayWithArray:sortedArray];
        saved = NO;
    }
    
    sac -> sequence = [NSMutableArray arrayWithArray:self.currentSequenceViews];
    sac.delegate = self;
    [self.navigationController pushViewController:sac animated:YES];



}

#pragma mark Adding sorted sequence to AppDelegate array

- (void)saveSequence:(UIImage *)sortedSequence {
    // Saving sorted sequence to final asanas array
    if (!sequences) {
        sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
    }
    
    [sequences addObject:sortedSequence];
   
    self.currentSequenceViews = nil;
    addedAsanas = nil;
    self.navigationItem.title = [NSString stringWithFormat:@"Creating sequences (%d)", [sequences count]];
    saved = YES;
    // debug(@"appDelegate asanas array %@", appDelegate.theNewProgram);
    
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
    addedAsanas = nil;
}

- (void)didDismissModalView {
    
    [self dismissModalViewControllerAnimated:YES];

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
