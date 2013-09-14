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
#define debug NSLog

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
                                                   initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(addNotes)];
    

    UIBarButtonItem *nextButton                = [[UIBarButtonItem alloc]
                                                   initWithTitle:@"    Next    " style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(nextButton)];
    
    UIBarButtonItem *clearButton                = [[UIBarButtonItem alloc]
                                                  initWithTitle:@" Clear All " style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(clearAllButton)];
    
    UIBarButtonItem *fixed1                     = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                   target:nil action:nil];
     [fixed1 setWidth:45.0f];
    
    NSArray *items =  @[nextButton,notesButton,fixed1,clearButton];
    self.navigationItem.rightBarButtonItems = items;
    if (!asanasImages) {
        asanasImages = [NSMutableArray array];
        asanasKeys = [NSMutableArray array];
    }
    [self createToolBar];
    [self fetchAsanas:kMainSet];
}


-(void)nextButton {
    
    
    // to ceate sequences 
    if ([appDelegate.selectedAsanas count] < 10) {
        
        if ([appDelegate.selectedAsanas count] == 0) {
            // warning massage here
            CustomAlert *noAsanas = [[CustomAlert alloc] initWithTitle:@"No asanas selected.."
                                                               message:@"You have not selected any asana!"
                                                              delegate:nil cancelButtonTitle:@"Ok"
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
    
    if ([appDelegate.selectedAsanas count] > 0) {
    
    CustomAlert *clearAllAlert = [[CustomAlert alloc]
                                  initWithTitle:@"Warning"
                                  message:@"All choosed asanas will be cleaned\n(Saved sequences are remain)"
                                  delegate:self cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Clear"
                                  , nil];
    clearAllAlert.tag = 0;
    [clearAllAlert show];
    }else {
        CustomAlert *clearAllAlert = [[CustomAlert alloc]
                                      initWithTitle:nil
                                      message:@"Nothing to remove"
                                      delegate:self cancelButtonTitle:@"Ok"
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
    segmentCotrol.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentCotrol.backgroundColor = [UIColor clearColor];
    [segmentCotrol setSelectedSegmentIndex:0];
    
    toolBar.frame = CGRectMake(0, 64, 768, 44);
    [self.navigationController.view addSubview:toolBar];
    
    
}

- (void)segmentControlPressed {
    
    if ([appDelegate.selectedAsanas count] > 0) {
        
        CustomAlert *changeSetAlert = [[CustomAlert alloc]
                                       initWithTitle:@"You select a different set of asanas"
                                       message:@"All choosed asanas will be cleaned\n(Saved sequences are remain)"
                                       delegate:self cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Go"
                                       , nil];
        changeSetAlert.tag = 1;
        [changeSetAlert show];
        
    }else {
    
        [self fetchAsanas:segmentCotrol.selectedSegmentIndex];
    }
    

}


- (void)fetchAsanas:(int)sender {
    
    loadedImages = 0;
    NSString*   namesFile = nil;
    int         setNumber = sender;
    
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
    //debug(@"namesArray is %@ setsArray is %@",namesArray, setsArray);
    // number of cells
    int imagesCount = [namesArray count];
    // define line count for each 6 asanas
    linesCount = imagesCount / 6;
    if (imagesCount%6 != 0) {
        linesCount ++;
    }
    
    if ([asanasImages count] != 0) [asanasImages removeAllObjects];
    if ([asanasKeys count] != 0) [asanasImages removeAllObjects];
    
    // debug(@"namesArray is %@ setsArray is ",namesArray);
    for (NSString *imageName in namesArray) {
        //debug(@"imageName is %@  ",imageName);
        [asanasImages addObject:[[appDelegate asanasCatalog] objectForKey:imageName]];
        [asanasKeys addObject:imageName];
    }
#ifdef DEBUG
    
    //debug(@"lineCount is %d", linesCount);
    // debug(@"namesArray is %@ nameFile is %@",namesArray, namesFile);
    
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

    if ([asanasImages count] != 0) {
        
        // set cell images
        int lineIndex = indexPath.row;
        int i = 1;
        int  imageIndex;
        
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
                
                if ([appDelegate.selectedAsanas objectForKey:[NSString stringWithFormat:@"%d",oneCellButton.tag]]) {
                    
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
    //debug(@"image is %@ tag is %@", image,imageKey);
    if (image) {
        
        [[pressedButton layer] setBorderColor:[UIColor lightGrayColor].CGColor];
        [appDelegate.selectedAsanas removeObjectForKey:asanaNumber];
        
        
    }else {
        //debug(@"[asanasImages objectAtIndex:(pressedButton.tag - 1)] is %@", [asanasImages objectAtIndex:(pressedButton.tag - 1)]);
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [toolBar setHidden:NO];
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
