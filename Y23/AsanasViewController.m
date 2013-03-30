//
//  AsanasViewController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsanasViewController.h"
#import "SelectAsanas.h"
#import "QuartzCore/QuartzCore.h"
#import "NotesModalController.h"
#import "AppDelegate.h"
#import "PIAcanasTableViewCell.h"
#import "CreatingSequences.h"

#define aSViewSize 116
#define aImageSize 112
#define debug NSLog

enum sets {
    kMainSet = 0,
    kExpressSet,
    kLightSet
};

@implementation AsanasViewController



@synthesize selectedAsanas = _selectedAsanas, sequences = _sequences, person = _person;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (!appDelegate) {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    /*
    scrollView = [[UIScrollView alloc]
                  initWithFrame:CGRectMake(0, 16, self.view.frame.size.width, self.view.frame.size.height - 120)];
    [scrollView setDelegate:self];
     */
    setsArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++ ) {
        
        [setsArray addObject:[NSNull null]];
    }
    //self.navigationItem.title = @"Asanas";
    // adding Notes button
    UIBarButtonItem *notesButton                = [[UIBarButtonItem alloc]
                                                   initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(addNotes)];
    

    UIBarButtonItem *nextButton                = [[UIBarButtonItem alloc]
                                                   initWithTitle:@"    Next    " style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(nextButton)];
    
    NSArray *items =  @[nextButton,notesButton];
    self.navigationItem.rightBarButtonItems = items;
    if (!asanasImages) {
        asanasImages = [NSMutableArray array];
    }
    [self createToolBar];
}


-(void)nextButton{
    
    // to ceate sequences 
    if ([asanasKeap count] < 10) {
        
        if ([asanasKeap count] == 1) {
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
    
    CreatingSequences *cs = [[CreatingSequences alloc] init];
    
    // sorting elements as image No.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag"
                                                                   ascending:YES] ;
    NSArray *sortedArray = [asanasKeap sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    cs -> allAsanas = [NSMutableArray arrayWithArray:sortedArray];
    [self.navigationController pushViewController:cs animated:YES];
}



- (void)createToolBar {
    
    [segmentCotrol addTarget:self action:@selector(fetchAsanas:) forControlEvents:UIControlEventValueChanged];
    
    segmentCotrol.selectedSegmentIndex = kMainSet;
    segmentCotrol.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentCotrol.backgroundColor = [UIColor clearColor];
    [segmentCotrol setSelectedSegmentIndex:0];
    [self fetchAsanas:segmentCotrol];
    toolBar.frame = CGRectMake(0, 64, 768, 44);
    [self.navigationController.view addSubview:toolBar];
    
    
}


- (void)fetchAsanas:(UISegmentedControl*)sender {
    
    loadedImages = 0;
    NSString*   namesFile = nil;
    int         setNumber = sender.selectedSegmentIndex;
    
    switch (setNumber) {
        case kMainSet:
            namesFile = @"mainCollection";
            break;
        case kExpressSet:
            namesFile = @"express";
            break;
        case kLightSet:
            namesFile = @"light";
            break;
    }
    if ([[setsArray objectAtIndex:setNumber] isEqual:[NSNull null]]) {
        NSString *file = [[NSBundle mainBundle] pathForResource:namesFile ofType:@"csv"];
        NSString *csvString = [[NSString stringWithContentsOfFile:file
                                                         encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [setsArray insertObject:[csvString componentsSeparatedByString:@","] atIndex:setNumber];
    }
    
    namesArray = [setsArray objectAtIndex:setNumber];
    
    // number of cells
    int imagesCount = [namesArray count];
    // define line count for each 6 asanas
    linesCount = imagesCount / 6;
    if (imagesCount%6 != 0) {
        linesCount ++;
    }
    
    if ([asanasImages count] != 0) {
        
        [asanasImages removeAllObjects];
    }
    for (NSString *imageName in namesArray) {
        
        [asanasImages addObject:[[appDelegate asanasCatalog] objectForKey:imageName]];
        
    }
#ifdef DEBUG
    
    debug(@"lineCount is %d", linesCount);
    // debug(@"namesArray is %@ nameFile is %@",namesArray, namesFile);
    
#endif
    // NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:[namesArray count]];
    
 
    [table reloadData];
}










-(void)addScrollViewContent {
    
    for (UIView *subview in scrollView.subviews) {
        [subview removeFromSuperview];
    }
    scrollView.contentOffset = CGPointMake(0,0);
    int imagesCount = [namesArray count];
    //asanasViews = [[NSMutableArray alloc] initWithCapacity:10];
    choosedResult = [[NSMutableSet alloc] initWithCapacity:10];
    
    unsigned lineCount; // define line count for each 6 asanas
    lineCount = imagesCount / 6;
    if (imagesCount%6 != 0) {
        lineCount ++;
    }
    
#ifdef DEBUG
    
    debug(@"lineCount is %d", lineCount);
    
#endif
    
    
    CGRect contentFrame = CGRectMake(36, 28, 748, (lineCount*aSViewSize));
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    scrollView.contentSize = CGSizeMake(contentView.frame.size.width,contentView.frame.size.height);
    NSUInteger c = 0; // c is number of images
    for ( int i = 0; i < lineCount*aSViewSize; i+= aSViewSize) {
        
        for (unsigned a = 0; a <= aSViewSize*5; a += aSViewSize) {
            
            CGRect asanaFrame = CGRectMake( a, i, aImageSize, aImageSize );
            CGRect buttonFrame = CGRectMake( 1, 1, aImageSize, aImageSize );
            
            if (c < imagesCount) {
                
                UIView *asanaView = [[UIView alloc] initWithFrame:asanaFrame];
                UIButton *asanaButton = [[UIButton alloc] initWithFrame:buttonFrame];
                asanaButton.tag = c;
                buttonLayer = [asanaButton layer];
                [buttonLayer setMasksToBounds:YES];
                [buttonLayer setCornerRadius:0.0];
                [buttonLayer setBorderWidth:1.0];
                [buttonLayer setBorderColor:[[UIColor grayColor] CGColor]];
                [asanaButton addTarget:self action:@selector(checkAsana:) forControlEvents:UIControlEventTouchUpInside];
                [asanaView addSubview:asanaButton];
                // activity indicator for image loading time
                UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                activityView.frame = CGRectMake( 21, 21, 70, 70 );
                [asanaView addSubview:activityView];
                [activityView startAnimating];
                //[asanasViews addObject:asanaView]; // add asana view in self array
                [contentView addSubview:asanaView];
            }
            c++;
            
        }
        
        
    }
    [scrollView addSubview:contentView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
       [self loadImageAsynchFrom:0 upTo:48];
    });
    
}

#pragma mark - Asanas view loaded images, adding end checked

- (void) loadImageAsynchFrom:(unsigned)first upTo:(unsigned)last {
    
    unsigned rest;
    
    rest = (last - first)%6;
    last -= rest;
    
    for (NSInteger a = first ; a < last ; a += 6) {
        
        
        for (NSUInteger i = a  ; i < (a + 6) ; i++) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                NSUInteger fileNumber = [[namesArray objectAtIndex:i] integerValue];
                NSString *fileName = [NSString stringWithFormat:@"%d", fileNumber];
                UIImage *asana = nil;
                if (![[appDelegate.asanasCatalog objectForKey:fileName] isEqual:[NSNull null]]) {
                    asana = [appDelegate.asanasCatalog objectForKey:fileName];
                }else {
                    asana = [UIImage imageNamed:fileName];
                }
                
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self addAsanaImage:asana withViewTag:i imageViewTag:fileNumber];
                });
            });
        }
        [NSThread sleepForTimeInterval:0.08]; // delay for animation
    }
    if (rest) {
        for (NSUInteger i = last  ; i < (last + rest) ; i++) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            
            dispatch_async(queue, ^{
                NSUInteger fileNumber = [[namesArray objectAtIndex:i] integerValue];
                NSString *fileName = [NSString stringWithFormat:@"%d", fileNumber];
                UIImage *asana = nil;
                if (![[appDelegate.asanasCatalog objectForKey:fileName] isEqual:[NSNull null]]) {
                    asana = [appDelegate.asanasCatalog objectForKey:fileName];
                }else {
                    asana = [UIImage imageNamed:fileName];
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self addAsanaImage:asana withViewTag:i imageViewTag:fileNumber];
                });
            });
        }
    }
    
}

- (void)addAsanaImage:(UIImage *)image withViewTag:(NSUInteger)tag imageViewTag:(NSUInteger)fileNumber {
    
    UIImageView *aView = [[UIImageView alloc] initWithImage:image];
    aView.tag = fileNumber; // in tag value pass image number
    aView.frame = CGRectMake(1, 1, aImageSize, aImageSize);
    //[[[[asanasViews objectAtIndex:tag] subviews] objectAtIndex:1] stopAnimating];
    aView.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ aView.alpha = 1.0; }
                     completion:^(BOOL fin) {/* if (fin) [myView removeFromSuperview]; */}];
    
    //if (![[[asanasViews objectAtIndex:tag] subviews] count] < 3) {
   //     [[asanasViews objectAtIndex:tag] addSubview:aView];
  //  }
    
    loadedImages += 1;
}

#pragma mark -
#pragma mark UIScrollViewDelegate mehods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    unsigned gap;
    unsigned offset = (unsigned) targetContentOffset->y ;
    gap = (offset - offset%116)/116 * 6;
    
#ifdef DEBUG
    
    debug(@"contentOffset is %@",  NSStringFromCGPoint(*targetContentOffset));
    debug(@"offset is %d",  offset);
    debug(@"offse1 is %d",  (offset - 100)%116);
    debug(@"offset2 is %d",  (offset - offset%116)/116);
    debug(@"countet image for loading is %d",  gap);
    
#endif
    gap += 54;
    if (gap > [namesArray count]) {gap = [namesArray count];}
    if (gap > loadedImages) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self loadImageAsynchFrom:loadedImages upTo:gap];
        });
        
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}



- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Main"]) {
        
        SelectAsanas *sa = (SelectAsanas *) [segue destinationViewController];
        sa.navigationItem.title = @"Main Collection";
        
        NSString *file = [[NSBundle mainBundle] pathForResource:@"mainCollection" ofType:@"csv"];
        NSString *csvString = [[NSString stringWithContentsOfFile:file
                                                         encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *stringValues = [csvString componentsSeparatedByString:@","];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[stringValues count]];
        for (NSString *strValue in stringValues) {
            
            NSNumber *numValue = [NSNumber numberWithInt:[strValue intValue]];
            [images addObject:numValue];
        }
        NSLog(@"images: %@", images);
        
        sa.imagesNames = images;
        
    }
    
    if ([[segue identifier] isEqualToString:@"Express" ]) {
        
        SelectAsanas *sa = [segue destinationViewController];
        sa.navigationItem.title = @"Express Collection";
        
        NSString *file = [[NSBundle mainBundle] pathForResource:@"express" ofType:@"csv"];
        NSString *csvString = [[NSString stringWithContentsOfFile:file
                                                         encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *stringValues = [csvString componentsSeparatedByString:@","];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[stringValues count]];
        for (NSString *strValue in stringValues) {
            
            NSNumber *numValue = [NSNumber numberWithInt:[strValue intValue]];
            [images addObject:numValue];
        }
        NSLog(@"images: %@", images);
        
        sa.imagesNames = images;
        
        
    }
    if ([[segue identifier] isEqualToString:@"ByLevel"]) {
        SelectAsanas *sa = [segue destinationViewController];
        sa.navigationItem.title = @"Collection by level";
        
        NSMutableSet *imagesSet = [[NSMutableSet alloc] init]; // create NSSet - avoid repetition images
        
        NSSortDescriptor * myDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
        NSArray *images = [imagesSet allObjects];
        images = [images sortedArrayUsingDescriptors:[NSArray arrayWithObjects:myDescriptor, nil]];
        sa.imagesNames = images;
        
        
        
    }
    if ([[segue identifier] isEqualToString:@"notesModalController"]) {
        
    }
    
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



#pragma mark UITableView & UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return linesCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIAcanasTableViewCell *cell = (PIAcanasTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[PIAcanasTableViewCell reuseIdentifier]];

    
    if (cell == nil)
    {
        cell = (PIAcanasTableViewCell *)[PIAcanasTableViewCell cellFromNibNamed:@"PIAsanasTableViewCell"];
    }

    if ([asanasImages count] != 0) {
        
        // set cell images
        NSMutableArray *lineImages = [NSMutableArray array];
        int lineIndex = indexPath.row;
        int i = 0;
        
        while (i <= 5)
        {
            int imageIndex = (lineIndex * 6 + i);
            NSLog(@"imageIndex is %d", imageIndex);
            UIImage *image = [asanasImages objectAtIndex:imageIndex];
            if (image) {
                [lineImages addObject:image];
            }
            
            i++;
        }
        
        
        [cell setupButtonsImages:lineImages];
        
    }
    
       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
