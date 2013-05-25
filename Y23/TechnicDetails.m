//
//  TechnicDetails.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TechnicDetails.h"
#import "AppDelegate.h"
#import "NotesModalController.h"

@class Technics;


@implementation TechnicDetails



- (id)initWithName:(NSString *)name elements:(NSArray *)elements tag:(int)tag
{
    self = [super init];
    if (self) {
        technicName = name;
        elementsNames = elements;
        elementIndex = tag;
    
    }
    return self;
    NSLog(@"name is %@, elements are %@", technicName, elementsNames);
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
    self.navigationItem.title = technicName;
    
    // adding "Notes" button
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:notesButton, nil];
    
    // view for content
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (70 + 70*[elementsNames count]))];
    contentView.backgroundColor = [UIColor clearColor];
    
    int x = 0; //  width coordinate
    int y = -20; // first height coordinate    
    int elementTag = 0; // tag for identification
    
    for (NSString *element in elementsNames) {

            y = y + 70; // line view y coordinate
            
            
            // setup line view with text, checkbox and Go-button if required :
            CGRect viewFrame = CGRectMake( x, y, 768, 50 );
            CGRect labelFrame = CGRectMake( 80, 20, 550, 30 );
            CGRect checkBoxFrame = CGRectMake( 620, 16, 40, 40 );
            
            UIView *cellView= [[UIView alloc] initWithFrame:viewFrame];
            cellView.backgroundColor = [UIColor clearColor];
            cellView.tag = elementTag;
            CheckBoxButton *checkBox = [[CheckBoxButton alloc] initWithFrame:checkBoxFrame];
            [checkBox setImage:[UIImage imageNamed:@"WhiteCBox.png"] 
                      forState:UIControlStateNormal];
            checkBox.tag = elementTag;
            [checkBox addTarget:self action:@selector(addProgramSubItem:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            // setup line label:
            UILabel *labelString = [[UILabel alloc] initWithFrame:labelFrame];
            labelString.textColor = [UIColor whiteColor];
            labelString.font = [UIFont fontWithName:@"Chalkduster" size:22.0];
            labelString.backgroundColor = [UIColor clearColor];
            
            labelString.text = element;
            [cellView addSubview:labelString];
            [cellView addSubview:checkBox];
            [contentView addSubview:cellView];
            
            elementTag++;
    
    }
    
    AppDelegate *appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray *programTechnics = [appDelegate.theNewProgram objectForKey:@"technics"];
    
    if ([programTechnics objectAtIndex:elementIndex] == [NSNull null]) {
        
        // create array for nested items in technic and add null-elements
        selectedElements = [NSMutableArray arrayWithCapacity:[elementsNames count]]; 
        
        for (NSInteger i = 0; i < [elementsNames count]; ++i)
        {
            [selectedElements addObject:[NSNull null]];
        }
        
        
        // create an element with name for technics list
        NSMutableDictionary *technic = [NSMutableDictionary dictionaryWithObject:selectedElements forKey:technicName]; 
        
        // add the element to tecnics list 
        [programTechnics replaceObjectAtIndex:elementIndex withObject:technic];
        
    }else{
        // set checkbox to Checked if the element already selected
        NSMutableDictionary *technic = [programTechnics objectAtIndex:elementIndex];
        selectedElements = [technic objectForKey:technicName];
        for (id item in selectedElements) {
            if (item != [NSNull null]) {
                
                NSUInteger index = [selectedElements indexOfObjectIdenticalTo:item];
                UIView *lineView = [[contentView subviews] objectAtIndex:index];
                CheckBoxButton *chBox = [[lineView subviews] objectAtIndex:1];
                [chBox setChecked:YES];
                }
            }
        }
    
    // create a scrollview if needed
    if ([elementsNames count] > 11) {
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:
                                CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        
        scroll.contentSize = CGSizeMake(contentView.frame.size.width,(contentView.frame.size.height + 350));
        //scroll.pagingEnabled = YES;
        [scroll addSubview:contentView];
        [self.view addSubview:scroll];
        
    }else{
        
        [self.view addSubview:contentView];
        
        
        
    }

}

- (void)addProgramSubItem:(CheckBoxButton *) sender {
    
    [sender onClicked];
    if (sender.checked) {
        
        [selectedElements replaceObjectAtIndex:sender.tag withObject:[elementsNames objectAtIndex:sender.tag]];
    }else{
        
        [selectedElements replaceObjectAtIndex:sender.tag withObject:[NSNull null]];
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




- (void) viewWillDisappear {
    
   }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}


@end
