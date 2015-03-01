//
//  AsanasViewController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsanasViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "NotesModalController.h"
#import "AppDelegate.h"
#import "PIAcanasTableViewCell.h"
#import "CreatingSequences.h"
#import "FFTransAlertView.h"

#define aSViewSize 116
#define aImageSize 112


enum sets {
    kMainSet = 0,
    kExpressSet,
    kLightSet
};

@interface AsanasViewController () <HideNotesViewProtocol>

@end

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
                                                   initWithTitle:NSLocalizedString(@"Notes", @"") style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(addNotes)];
    

    UIBarButtonItem *nextButton                = [[UIBarButtonItem alloc]
                                                   initWithTitle:NSLocalizedString(@"Next", @"") style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(nextButton)];

    
    UIBarButtonItem *clearButton                = [[UIBarButtonItem alloc]
                                                   initWithTitle:NSLocalizedString(@"Clear Selected", @"") style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(clearAllButton)];
    
    UIBarButtonItem *fixed1                     = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                   target:nil action:nil];
    [fixed1 setWidth:47.0f];
    
    UIBarButtonItem *fixed2                     = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                   target:nil action:nil];
     [fixed2 setWidth:35.0f];
    
    NSArray *items =  @[nextButton,fixed1,notesButton,fixed2,clearButton];
    self.navigationItem.rightBarButtonItems = items;
    if (!asanasImages) {
        asanasImages = [NSMutableArray array];
        asanasKeys = [NSMutableArray array];
    }
    [self createToolBar];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(36.0, 44.0, 730.0, 863.0)];
    table.backgroundColor = [UIColor clearColor];
    table.separatorColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([appDelegate.selectedAsanas count] < 1) {
        [self fetchAsanas:kMainSet];
    }
    [toolBar setHidden:NO];
}


-(void)nextButton {
    
    // Google An
    [appDelegate eventTrackingGA:@"Asanas Main" andAction:@"To Create Seq" andLabel:@"Next Button"];
    
    
    // to ceate sequences 
    if ([appDelegate.selectedAsanas count] < 10) {
        
        if ([appDelegate.selectedAsanas count] == 0) {
            // warning massage here
            CustomAlert *noAsanas = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"No asanas selected..", @"")
                                                               message:NSLocalizedString(@"Tap to select asanas you need.", @"")
                                                              delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                                     otherButtonTitles:nil];
            [noAsanas show];
            return;
        }else {
            
            // one more warning massage
        }
    }
    [toolBar setHidden:YES];
    CreatingSequences *cs = [[CreatingSequences alloc] init];
    
    // sorting elements as image No.
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag"
    //                                                               ascending:YES] ;
    //NSArray *sortedArray = [asanasHeap sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    //cs -> allAsanas = [NSMutableArray arrayWithArray:sortedArray];
    [self.navigationController pushViewController:cs animated:YES];
}

- (void)clearAllButton {
    
    // Google An
    [appDelegate eventTrackingGA:@"Asanas Main" andAction:@"Clear" andLabel:@"Clear Selected"];
    
    if ([appDelegate.selectedAsanas count] > 0) {
    
    CustomAlert *clearAllAlert = [[CustomAlert alloc]
                                  initWithTitle:NSLocalizedString(@"Attention", @"")
                                  message:NSLocalizedString(@"All chosen asanas will be cleaned\n(Saved sequences are remain)", @"")
                                  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                  otherButtonTitles:NSLocalizedString(@"Clear", @"")
                                  , nil];
    clearAllAlert.tag = 0;
    [clearAllAlert show];
    }else {
        CustomAlert *clearAllAlert = [[CustomAlert alloc]
                                      initWithTitle:nil
                                      message:NSLocalizedString(@"Nothing to remove", @"")
                                      delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                      otherButtonTitles:nil
                                      , nil];
        clearAllAlert.tag = 0;
        [clearAllAlert show];
    }
}





- (void)createToolBar {
    
    [segmentCotrol addTarget:self action:@selector(segmentControlPressed) forControlEvents:UIControlEventValueChanged];
    
    segmentCotrol.selectedSegmentIndex = kMainSet;
    previousSegment = kMainSet;
    segmentCotrol.backgroundColor = [UIColor clearColor];
    [segmentCotrol setSelectedSegmentIndex:0];
    
    toolBar.frame = CGRectMake(0, 64, 768, 44);
    [self.navigationController.view addSubview:toolBar];
    
    
}

- (void)segmentControlPressed {
    
    if ([appDelegate.selectedAsanas count] > 0) {
        
        CustomAlert *changeSetAlert = [[CustomAlert alloc]
                                       initWithTitle:NSLocalizedString(@"You select a different set of asanas", @"")
                                       message:NSLocalizedString(@"All chosen asanas will be cleaned\n(Saved sequences are remain)", @"")
                                       delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                       otherButtonTitles:NSLocalizedString(@"Go", @"")
                                       , nil];
        changeSetAlert.tag = 1;
        [changeSetAlert show];
        
    }else {
    
        [self fetchAsanas:segmentCotrol.selectedSegmentIndex];
    }
    

}


- (void)fetchAsanas:(NSInteger)sender {
    
    loadedImages = 0;
    NSString*   namesFile = nil;
    NSInteger   setNumber = sender;
    
    switch (setNumber) {
        case kMainSet:
            // Google An
            [appDelegate eventTrackingGA:@"Asanas Main" andAction:@"MainCollection" andLabel:@"Load collection"];
            namesFile = @"mainCollection";
            break;
        case kExpressSet:
            // Google An
            [appDelegate eventTrackingGA:@"Asanas Main" andAction:@"Express" andLabel:@"Load collection"];
            namesFile = @"express";
            break;
        case kLightSet:
            // Google An
            [appDelegate eventTrackingGA:@"Asanas Main" andAction:@"Light" andLabel:@"Load collection"];
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
    //dPrint(@"namesArray is %@ setsArray is %@",namesArray, setsArray);
    // number of cells
    NSInteger imagesCount = [namesArray count];
    // define line count for each 6 asanas
    linesCount = imagesCount / 6;
    if (imagesCount%6 != 0) {
        linesCount ++;
    }
    
    if ([asanasImages count] != 0) [asanasImages removeAllObjects];
    if ([asanasKeys count] != 0) [asanasImages removeAllObjects];
    
    // dPrint(@"namesArray is %@ setsArray is ",namesArray);
    for (NSString *imageName in namesArray) {
        //dPrint(@"imageName is %@  ",imageName);
        [asanasImages addObject:[[appDelegate asanasCatalog] objectForKey:imageName]];
        [asanasKeys addObject:imageName];
    }
#ifdef dPrint
    
    //dPrint(@"lineCount is %d", linesCount);
    // dPrint(@"namesArray is %@ nameFile is %@",namesArray, namesFile);
    
#endif
    // NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:[namesArray count]];
    
 
    [table reloadData];
}

#pragma mark UIAlertView delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 0 && buttonIndex == 1) {
        
        [appDelegate.selectedAsanas removeAllObjects];
        [appDelegate.asanasCounter removeAllObjects];
        [table reloadData];
    }
    
    if (alertView.tag == 1 && buttonIndex == 1) {
        
        [appDelegate.selectedAsanas removeAllObjects];
        [self fetchAsanas:segmentCotrol.selectedSegmentIndex];
        previousSegment = segmentCotrol.selectedSegmentIndex;
        
    }else {
        
        segmentCotrol.selectedSegmentIndex = previousSegment;
    }
}





#pragma mark Adding Notes to AppDelegate array

-(void)addNotes {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Get Notes" andLabel:@"Asanas Main"];
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}



#pragma mark UITableView & UITableViewDataSource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 116;
}

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
    
    static NSString *CellIdentifier = @"asanasCell";
    
    PIAcanasTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
         cell = (PIAcanasTableViewCell *)[PIAcanasTableViewCell cellFromNibNamed:@"PIAsanasTableViewCell"];
        
       
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([asanasImages count] != 0) {
        
        // set cell images
        NSInteger lineIndex = indexPath.row;
        int i = 1;
        NSInteger  imageIndex;
        
        while (i <= 6)
        {
            imageIndex = (lineIndex * 6 + i);
            UIImage *image = nil;
            if ([asanasImages count] >= imageIndex) {
                
                image = [asanasImages objectAtIndex:(imageIndex - 1)];
                UIButton *oneCellButton = nil;
                
                switch (i) {
                    case 1:
                        oneCellButton = cell.asanaButton1;
                        break;
                    case 2:
                        oneCellButton = cell.asanaButton2;
                        break;
                    case 3:
                        oneCellButton = cell.asanaButton3;
                        break;
                    case 4:
                        oneCellButton = cell.asanaButton4;
                        break;
                    case 5:
                        oneCellButton = cell.asanaButton5;
                        break;
                    case 6:
                        oneCellButton = cell.asanaButton6;
                        break;
                }
                
                [oneCellButton addTarget:self action:@selector(asanaButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [oneCellButton setImage:image forState:UIControlStateNormal];
                oneCellButton.tag = indexPath.row * 6 + i;
                [[oneCellButton layer] setBorderWidth:1.0f];
                
                if ([appDelegate.selectedAsanas objectForKey:[NSString stringWithFormat:@"%d",(int)oneCellButton.tag]]) {
                    
                    [[oneCellButton layer] setBorderColor:[UIColor redColor].CGColor];
                    
                }else {
                    
                    [[oneCellButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
                }
            }

            i++;
        }
        // set images, target and selector to cell button
        
        
    }

    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)asanaButtonPressed:(id)sender {
    
    
    
    UIButton *pressedButton = (UIButton*)sender;
    NSString *asanaNumber = [asanasKeys objectAtIndex:(pressedButton.tag - 1)];
    UIImage *image = [appDelegate.selectedAsanas objectForKey:asanaNumber];
    //dPrint(@"image is %@ tag is %@", image,imageKey);
    if (image) {
        // Google An
        [appDelegate eventTrackingGA:@"Asanas Main" andAction:@"Asana Unchecked" andLabel:[NSString stringWithFormat:@"Asana number is %d",(int)pressedButton.tag]];
        [[pressedButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [appDelegate.selectedAsanas removeObjectForKey:asanaNumber];
        
        
    }else {
        // Google An
        [appDelegate eventTrackingGA:@"Asanas Main" andAction:@"Asana checked" andLabel:[NSString stringWithFormat:@"Asana number is %d",(int)pressedButton.tag]];
        //dPrint(@"[asanasImages objectAtIndex:(pressedButton.tag - 1)] is %@", [asanasImages objectAtIndex:(pressedButton.tag - 1)]);
        [appDelegate.selectedAsanas setObject:[asanasImages objectAtIndex:(pressedButton.tag - 1)] forKey:asanaNumber];
        [[pressedButton layer] setBorderColor:[UIColor redColor].CGColor];
    }
    
    
    
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



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [appDelegate pageTrackingGA:@"Asanas MainView"];
    // if first launch
    if (![appDelegate retrieveFromUserDefaults:@"AsanasScreen_FirstTime"]) {
        [appDelegate saveToUserDefaults:@"NO" forKey:@"AsanasScreen_FirstTime"];
        tpvc = [[CSTipsViewController alloc] initWithSender:@"Asanas"];
        tpvc.viewDelegate = self;
        tpvc.view.frame = CGRectMake(0.0,0.0,768.0,1000.0);
        [self.view addSubview:tpvc.view];
    }
    
//    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
//        //NSLog(@"bar item - %@, width - %f", item,item.width);
//    }
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


- (void)removeTips {
    [tpvc.view removeFromSuperview];
    tpvc = nil;
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
