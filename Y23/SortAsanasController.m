//
//  SortAsanasController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SortAsanasController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIView+Animation.h"
#import "PIAsanaView.h"
#import "SetBreathDataController.h"
#import "NotesModalController.h"
#import "FFTransAlertView.h"
#import "AppDelegate.h"






@interface SortAsanasController () <HideNotesViewProtocol>

@end

#define aSViewSize 116
#define aImageSize 112
#define dPrint NSLog

@implementation SortAsanasController

@synthesize delegate = _delegate, asanasViews = _asanasViews;

- (id)initWithSequence:(NSMutableArray*)currentSequence
{
    self = [super init];
    if (self) {
        sequence = currentSequence;
        noSimultant = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // adding "Notes" button
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    self.navigationItem.title = NSLocalizedString(@"Sorting and rearrangement", @"");
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:NSLocalizedString(@"Notes", @"") style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    
    UIBarButtonItem *saveButton          = [[UIBarButtonItem alloc]
                                            initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStylePlain
                                            target:self action:@selector(saving)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 44.0;
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:saveButton,fixedSpace, notesButton, nil];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 1024.0)];
    backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [backgroundImage setImage:[UIImage imageNamed:@"yoga_back.jpg"]];
    [self.view addSubview:backgroundImage];
    

    [self.view sendSubviewToBack:backgroundImage];
    
    [self.view addSubview:[self addSortView]]; // adding all images to main view

}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    // Google An
    [appDelegate pageTrackingGA:@"Sorting"];
}





#pragma mark - Asanas Images Scrollview adding 

- (UIView *)addSortView {
    
    asanasCount = [sequence count];
    
    unsigned lineCount; // define line count for each 9 asanas
    lineCount = asanasCount / 6;
    if (asanasCount%6 != 0) {
        lineCount ++;
    }
    
    // creating view and its contentview
    CGRect contentFrame = CGRectMake(36, 18, 696, lineCount*aSViewSize);
    contentView = [[UIView alloc] initWithFrame:contentFrame];
    
    NSUInteger c = 0; // c is number of images
    for (unsigned i = 0; i < lineCount*aSViewSize; i+= aSViewSize) {
        
        for (unsigned a = 0; a <= aSViewSize*5; a += aSViewSize) {
            
            CGRect asanaViewFrame = CGRectMake( a + 2, i + 2, aImageSize , aImageSize);
            
            if (c < [sequence count]) {
                
                PIAsanaView *asanaView = [sequence objectAtIndex:c];
                asanaView.frame = asanaViewFrame;

                // set action for tap on asana button
                CGRect asanaButtonFrame = CGRectMake( 0, 0, aSViewSize , aSViewSize);
                UIButton *breath = [[UIButton alloc] initWithFrame:asanaButtonFrame]; // button for choice breath parameters
                [breath addTarget:self action:@selector(inputBreathData:) forControlEvents:UIControlEventTouchUpInside];
                [asanaView addSubview:breath];
                asanaView.tag = c;
                CALayer *asanaLayer = [asanaView layer];
                [asanaLayer setMasksToBounds:YES];
                [asanaLayer setCornerRadius:0.0];
                [asanaLayer setBorderWidth:1.0];
                [asanaLayer setBorderColor:[[UIColor grayColor] CGColor]];
                
                // set action for moving asana
                UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
                recognizer.delegate = self;
                [asanaView addGestureRecognizer:recognizer];
                [[sequence objectAtIndex:c] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth];
                //[asanaView addSubview:[sequence objectAtIndex:c]]; // add asana imageview to button
                [contentView addSubview:asanaView];
                if (!_asanasViews) {
                    _asanasViews = [[NSMutableArray alloc] initWithCapacity:2];
                }
                [_asanasViews addObject:asanaView];
            }
            c++;
        }

    }
    //dPrint(@" _asanasViews %@", _asanasViews);

    
    return contentView;
}



#pragma mark -
#pragma mark UIGestureRecognizerDelegate protocol methodes

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
                shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {        
                    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    
    if (noSimultant) {
        return NO;
    }
    noSimultant = YES;
    return YES;
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:contentView];
    NSArray *sorting;
    
    // delimitation
    float limitCenterX;
    float limitCenterY;
    unsigned rest = [_asanasViews count]%6;
    unsigned rows = [_asanasViews count]/6;
    
    
    if (rest != 0 && [_asanasViews count] > 6) {
        rows +=1;
        limitCenterX = (rest*aSViewSize - aSViewSize/2);
    }else {
        if ([_asanasViews count] > 6) {
            limitCenterX = 638;
        }else {
            rows = 1;
            limitCenterX = [_asanasViews count]*aSViewSize - aSViewSize/2;
        }
    }
    limitCenterY = rows*aSViewSize - aSViewSize/2 ;
    
    
    // determination starting point
    if ([recognizer state] == UIGestureRecognizerStateBegan ) {
        
        panGesture = recognizer; // set for tracking, only one recognizer
        
        currLocation = recognizer.view.center;
        // scale up view and subview image
        [recognizer.view scaleTo:CGRectMake(0,0,140,140) duration:0.2];
        
    }
    
    if ([recognizer state] == UIGestureRecognizerStateChanged) {
        
        NSSortDescriptor * myDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
        
        // moving views
        UIView *movedView;
        
        // replace if drag view in +x direction
        if (recognizer.view.center.x - currLocation.x > aSViewSize/2 && currLocation.x < 638.0) {
            if(currLocation.x == limitCenterX && currLocation.y == limitCenterY) { // if last asana
                if (rows > 1) { //if numder of rows is one - nothing
                    
                    for(unsigned i = 1; i < 6; i++) {
                        movedView = [_asanasViews objectAtIndex:(recognizer.view.tag - i)];
                        if (movedView.center.x == 638.0) {
                            [movedView moveTo:CGPointMake(aSViewSize/2, movedView.center.y + aSViewSize) duration:0.2
                                       option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                        }else {
                            [movedView moveTo:CGPointMake(movedView.center.x + aSViewSize, movedView.center.y) duration:0.2
                                       option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                        }
                        movedView.tag += 1;
                    }
                    currLocation.y = limitCenterY - aSViewSize;
                    recognizer.view.tag -= 5;
                    
                    currLocation.x += aSViewSize;
                }
            }else if(!(currLocation.x == limitCenterX && rows == 1)){
                movedView = [_asanasViews objectAtIndex:(recognizer.view.tag + 1)];
                [movedView moveTo:currLocation duration:0.1
                           option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                [movedView setTag:recognizer.view.tag];
                movedView.tag = movedView.tag;
                recognizer.view.tag += 1;
                currLocation.x += aSViewSize;
            }
            sorting = [_asanasViews sortedArrayUsingDescriptors:[NSArray arrayWithObjects:myDescriptor, nil]];
            _asanasViews = [sorting mutableCopy];
        }
        
        // replace if drag view in -x direction
        if (currLocation.x - recognizer.view.center.x > aSViewSize/2 && currLocation.x > aSViewSize/2) {
            // if above and right from last asana
            if(currLocation.x == limitCenterX + aSViewSize && recognizer.view.center.y > limitCenterY - aSViewSize/2){
                for(unsigned i = 1; i < 6; i++) {
                    movedView = [_asanasViews objectAtIndex:(recognizer.view.tag + i)];
                    if (movedView.center.x == aSViewSize/2) {
                        [movedView moveTo:CGPointMake(638.0, movedView.center.y - aSViewSize) duration:0.2
                                   option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                        //  dPrint(@"moved in x- direction view tag is %i", movedView.tag);
                    }else {
                        [movedView moveTo:CGPointMake(movedView.center.x - aSViewSize, movedView.center.y) duration:0.2
                                   option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                        // dPrint(@"moved in x- direction view tag is %i", movedView.tag);
                    }
                    [movedView setTag:(movedView.tag - 1)];
                }
                currLocation.y = limitCenterY;	
                recognizer.view.tag += 5;
            }else {
                movedView = [_asanasViews objectAtIndex:(recognizer.view.tag - 1)];
                [movedView moveTo:currLocation duration:0.1
                           option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                [movedView setTag:recognizer.view.tag]; 
                recognizer.view.tag = recognizer.view.tag - 1;
            }
            currLocation.x -= aSViewSize;
            
            sorting = [_asanasViews sortedArrayUsingDescriptors:[NSArray arrayWithObjects:myDescriptor, nil]];
            _asanasViews = [sorting mutableCopy];
        }
        
        // replace views row if drag view in +y direction
        if ((recognizer.view.center.y - currLocation.y > aSViewSize/2) && currLocation.y < limitCenterY){
            if (!(currLocation.x > limitCenterX && currLocation.y == limitCenterY - aSViewSize)) {
                unsigned movedCount = 6;
                for (int i = (recognizer.view.tag +1); i <= (recognizer.view.tag + movedCount); i++) {
                    movedView = [_asanasViews objectAtIndex:i];
                    if (movedView.center.x > aSViewSize/2) {
                        [movedView moveTo:CGPointMake(movedView.center.x - aSViewSize, movedView.center.y) duration:0.1
                                   option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                        //dPrint(@"moved y+ view tag is %i", movedView.tag);
                    }else {
                        [movedView moveTo:CGPointMake(638.0, movedView.center.y - aSViewSize) duration:0.2
                                   option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                        //dPrint(@"moved y+ first view tag is %i", movedView.tag);
                    }
                    [movedView setTag:(movedView.tag -1)];
                }
                recognizer.view.tag = recognizer.view.tag + movedCount;
                currLocation.y += aSViewSize;
            }
            sorting = [_asanasViews sortedArrayUsingDescriptors:[NSArray arrayWithObjects:myDescriptor, nil]];
            _asanasViews = [sorting mutableCopy];
        }
        
        
        // moving views row if drag view in -y direction
        if (currLocation.y - recognizer.view.center.y > aSViewSize/2 && currLocation.y > aSViewSize/2 ) { 
            
            for (int i = (recognizer.view.tag - 6); i < recognizer.view.tag; i++) {
                movedView = [_asanasViews objectAtIndex:i];
                if (movedView.center.x < 638.0) {
                    [movedView moveTo:CGPointMake(movedView.center.x + aSViewSize, movedView.center.y) duration:0.1
                               option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                    //dPrint(@"moved -y view tag is %i", movedView.tag);
                }else if(movedView.center.x == 638.0){
                    [movedView moveTo:CGPointMake(movedView.center.x - 580.0, movedView.center.y + aSViewSize) duration:0.2
                               option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
                    //dPrint(@"moved view tag is %i", movedView.tag);
                }
                [movedView setTag:(movedView.tag + 1)];
            }
            recognizer.view.tag = recognizer.view.tag - 6;
            currLocation.y -= aSViewSize;
            
            sorting = [_asanasViews sortedArrayUsingDescriptors:[NSArray arrayWithObjects:myDescriptor, nil]];
            _asanasViews = [sorting mutableCopy];
        }
    }
    
    if ([recognizer state] == UIGestureRecognizerStateEnded ) {
        
        // scale down view and subview image
        if (recognizer.enabled) {   
            [recognizer.view scaleTo:CGRectMake(0,0,aImageSize,aImageSize) duration:0.2];
            recognizer.view.center = currLocation;
        }
        noSimultant = NO;
        panGesture = nil;
    }
    if (recognizer.enabled) {
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                             recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}


#pragma mark -
#pragma mark UIPopover content methodes

- (void) inputBreathData:(UIButton*)sender {
    
    if (panGesture) {
        return;
    }
    
    //content ViewController
    
    popoverContent = [[SetBreathDataController alloc] init];
    popoverContent.delegate = self;
    popoverContent.theAsana = [_asanasViews objectAtIndex:[sender superview].tag];
    
    // set UINavBar there title and item
    
    UINavigationController *navbar = [[UINavigationController alloc] initWithRootViewController:popoverContent];
    
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:popoverContent action:@selector(removeTheAsana)];
    [popoverContent.navigationItem setLeftBarButtonItem:deleteButton]; // trash button
    
    popController = [[UIPopoverController alloc] initWithContentViewController:navbar];
    UIPopoverArrowDirection direction;
    if ([sender superview].tag < 24) {
         direction = UIPopoverArrowDirectionUp;
    }else {
         direction = UIPopoverArrowDirectionDown;
    }
    
    [popController presentPopoverFromRect:[[sender superview] frame] inView:contentView permittedArrowDirections:direction animated:YES];

}


- (void)dismissPopover {
    [popController dismissPopoverAnimated:YES];
}


- (void) removeAsanaView:(UIView *)view {
    
    int tag = view.tag;
    PIAsanaView *removedAsana = [self.asanasViews objectAtIndex:tag];
    
    // Google An
    [appDelegate eventTrackingGA:@"Sorting" andAction:@"Remove asana" andLabel:removedAsana.identificator];
    //NSLog(@"remove asana %@",removedAsana.identificator);
    // decrease counter
    NSString *asanaID = removedAsana.identificator;
    NSString *number = [appDelegate.asanasCounter objectForKey:asanaID];
    NSString *newNumber = [NSString stringWithFormat:@"%d",([number integerValue] - 1)];
    
    if ([newNumber isEqualToString:@"0"]) {
        [appDelegate.asanasCounter removeObjectForKey:asanaID];
    }else {
        [appDelegate.asanasCounter setObject:newNumber forKey:asanaID];
    }
    // remove recoqnizer
    PIAsanaView *asanaView = [_asanasViews objectAtIndex:tag];
    for (UIPanGestureRecognizer *recognizer in [asanaView gestureRecognizers]) {
        [asanaView removeGestureRecognizer:recognizer];
    }
    [_asanasViews removeObjectAtIndex:tag];
    if ([[_asanasViews lastObject] tag] > tag) { // animation and move asanas
        PIAsanaView *movedView;
        for (int i = tag; i < [_asanasViews count]; i++) {
            movedView = [_asanasViews objectAtIndex:i];
            if (movedView.center.x > aSViewSize/2) {
                [movedView moveTo:CGPointMake(movedView.center.x - aSViewSize, movedView.center.y) duration:0.5
                           option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
            }else {
                [movedView moveTo:CGPointMake(638.0, movedView.center.y - aSViewSize) duration:0.2
                           option:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction];
            }
            movedView.tag -= 1; // and change their tags
        }
        
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ view.alpha = 0.0; }
                     completion:^(BOOL fin) { if (fin && view) [view removeFromSuperview]; }];
    [popController dismissPopoverAnimated:YES];
}



#pragma mark -
#pragma mark Finish 

- (void)saving {
    
    
    // snapshot for sequence
    if ([_asanasViews count] == 0) {
        
        CustomAlert *zeroAsanasAlert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"No asanas on the view", @"")
                                                                  message:NSLocalizedString(@"Please go back and add asanas.", @"")
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                        otherButtonTitles:nil];
        [zeroAsanasAlert show];
        return;
    }
    
    // Google An
    [appDelegate eventTrackingGA:@"Sorting" andAction:@"Save Sequence" andLabel:[NSString stringWithFormat:@"sequence contains %d asanas",[_asanasViews count]]];
    
    
    UIImage *sequenceImage = [contentView imageFromView];
    
    // removing asanas views from the screen
            for (int i = 0; i < [_asanasViews count]; i++) {
            PIAsanaView *view = [_asanasViews objectAtIndex:i];
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{ view.alpha = 0.0; }
                             completion:^(BOOL fin) { if (fin) [view removeFromSuperview];}];
            
        }
    
    [self.delegate performSelector:@selector(saveSequence:) withObject:sequenceImage];
    //dPrint(@"sequence image is %@", sequenceImage);
    // pausa for animation
    // and go back to previous CreatingAsanas controller
    BOOL yesBool = YES;
    NSNumber *yesNumber = [NSNumber numberWithBool:yesBool];
    
    [_asanasViews removeAllObjects];
    
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:yesNumber afterDelay:0.35]; 
}

-(void) viewWillDisappear:(BOOL)animated {
    // passing existing asanas back to previous CreatingAsanas controller if Back button pressed
    for (PIAsanaView *aView in _asanasViews) {
        //remove PanGestureRecognizer
        for (UIPanGestureRecognizer *recognizer in [aView gestureRecognizers]) {
            [aView removeGestureRecognizer:recognizer];
        }
    }
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        sequence = _asanasViews;
        [self.delegate performSelector:@selector(setAddedAsanas:) withObject:_asanasViews];
        //dPrint(@" delegate %@", [self.delegate performSelector:@selector(currentSequenceViews)]);

    }
    [super viewWillDisappear:animated];
}

#pragma mark Adding Notes to AppDelegate array

-(void)addNotes {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Get Notes" andLabel:@"Sorting"];
    
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
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Hide Notes" andLabel:@"Sorting"];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

@end
