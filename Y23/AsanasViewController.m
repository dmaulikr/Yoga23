//
//  AsanasViewController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsanasViewController.h"
#import "SelectAsanas.h"
#import "NotesModalController.h"

@implementation AsanasViewController

@synthesize selectedAsanas = _selectedAsanas, sequences = _sequences, person = _person;
@synthesize main = _main, express = _express, byLevel1 = _byLevel1, byLevel2 = _byLevel2, byLevel3 = _byLevel3,
byLevel4 = _byLevel4, byLevel5 = _byLevel5, byLevel6 = _byLevel6, byLevel7 = _byLevel7;
@synthesize goMain = _goMain, goExpress = _goExpress, goByLevel = _goByLevel;

- (IBAction) selectedList: (CheckBoxButton*) sender {
    
    [sender onClicked]; // change state of checkbox
       // set one and deactivated another checkboxes
    if (sender.checked) {             
        if (sender == self.main) {
            [self.express setEnabled:NO];
            for (int i = 0; i < 7; i++) {
                [[levelsButtons objectAtIndex:i] setEnabled:NO];
            }
            [self.goMain setEnabled:YES];
            return;
        }
        if (sender == self.express) {
            [self.main setEnabled:NO];
            for (int i = 0; i < 7; i++) {
                [[levelsButtons objectAtIndex:i] setEnabled:NO];
            }
            [self.goExpress setEnabled:YES];
            return;
        }
        else {
            [self.main setEnabled:NO];
            [self.express setEnabled:NO];
            [self.goByLevel setEnabled:YES];
            return;
        }
    }
        // unset one and activated another checkboxes
    if (!sender.checked) {
        if (sender == self.main) {
            [self.express setEnabled:YES];
            for (int i = 0; i < 7; i++) {
                [[levelsButtons objectAtIndex:i] setEnabled:YES];
            }
            [self.goMain setEnabled:NO];
            return;
        }
        if (sender == self.express) {
            [self.main setEnabled:YES];
            for (int i = 0; i < 7; i++) {
                [[levelsButtons objectAtIndex:i] setEnabled:YES];
            }
            [self.goExpress setEnabled:NO];
            return;
        }
        else {
            int levels = 0; // verifying each "by levels"
            for (int i = 0; i < 7; i++) {
                if ([[levelsButtons objectAtIndex:i] checked] == YES){
                    return;
                }else {
                    levels++;
                    if (levels == 7) { 
                        [self.main setEnabled:YES];
                        [self.express setEnabled:YES];
                        [self.goByLevel setEnabled:NO];
                    }
                    
                }
            }
            
            return;
        }
    }
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
        for (int i = 0; i < 7; i++) {
            if ([[levelsButtons objectAtIndex:i] checked] == YES){
                int n = i;
                NSString *fileName = [NSString stringWithFormat:@"level_%d", ++n];
                NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:@"csv"];
                NSString *csvString = [[NSString stringWithContentsOfFile:file 
                                                                 encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                NSArray *stringValues = [csvString componentsSeparatedByString:@","];
                NSMutableArray *levelImages = [NSMutableArray arrayWithCapacity:[stringValues count]];
                for (NSString *strValue in stringValues) {
                    
                    NSNumber *numValue = [NSNumber numberWithInt:[strValue intValue]];
                    [levelImages addObject:numValue];
                }
                
                [imagesSet addObjectsFromArray:levelImages];
            }
            NSSortDescriptor * myDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
            NSArray *images = [imagesSet allObjects];
            images = [images sortedArrayUsingDescriptors:[NSArray arrayWithObjects:myDescriptor, nil]];
            sa.imagesNames = images;

        }
        
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
    [self presentModalViewController:navController animated:YES];
    nmc.delegate = self;
    
    
    navController.view.superview.center = self.view.center;
    
}

-(void)notesDone {
    [self dismissModalViewControllerAnimated:YES];
    NSLog(@"dismiss modalController");
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    levelsButtons = [NSArray arrayWithObjects:self.byLevel1, self.byLevel2, self.byLevel3,
                         self.byLevel4, self.byLevel5, self.byLevel6, self.byLevel7, nil];
    
    [self.goMain setEnabled:NO];
    [self.goExpress setEnabled:NO];
    [self.goByLevel setEnabled:NO];
    
    //self.navigationItem.title = @"Asanas";
    // adding Notes button
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:notesButton, nil];
}

- (void)viewDidUnload
{
    self.byLevel1 = nil;
    self.byLevel2 = nil;
    self.byLevel3 = nil;
    self.byLevel4 = nil;
    self.byLevel5 = nil;
    self.byLevel6 = nil;
    self.byLevel7 = nil;
    self.main = nil;
    self.express = nil;
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
