//
//  SelectAsanasController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectAsanas.h"
#import "QuartzCore/QuartzCore.h"
#import "CreatingSequences.h"
#import "NotesModalController.h"


#define aSViewSize 116
#define aImageSize 112
#define debug NSLog



@implementation SelectAsanas

@synthesize imagesNames = _imagesNames;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // adding "Notes" and "To sequences" button
    UIBarButtonItem *notesButton         = [[UIBarButtonItem alloc]
                                            initWithTitle:@"Notes" style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addNotes)];
    
    UIBarButtonItem *doneButton          = [[UIBarButtonItem alloc] 
                                            initWithTitle:@"To sequences" style:UIBarButtonItemStylePlain
                                            target:self action:@selector(createSequences)];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:doneButton, notesButton, nil];
    
  
    
    [self.view addSubview:[self addScrollView]];
    
    loadedImages = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self loadImageAsynchFrom:0 upTo:48];
    });
    
}

-(UIScrollView *)addScrollView {
    
    imagesCount = [self.imagesNames count];
    asanasViews = [[NSMutableArray alloc] initWithCapacity:10];
    choiceResult = [[NSMutableSet alloc] initWithCapacity:10];
    
    unsigned lineCount; // define line count for each 6 asanas
    lineCount = imagesCount / 6;
    if (imagesCount%6 != 0) {
        lineCount ++;
    }
    debug(@"lineCount is %d", lineCount);
    
    
    CGRect scrollFrame = CGRectMake(0, 16, self.view.frame.size.width, self.view.frame.size.height - 119 );
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    CGRect contentFrame = CGRectMake(36, 0, 748, (lineCount*aSViewSize));
    UIView *contentView = [[UIView alloc] initWithFrame:contentFrame];
    scrollView.contentSize = CGSizeMake(contentView.frame.size.width,contentView.frame.size.height);
    [scrollView setDelegate:self];
    
    NSUInteger c = 0; // c is number of images    
    for ( int i = 0; i < lineCount*aSViewSize; i+= aSViewSize) {
        
        for (unsigned a = 0; a <= aSViewSize*5; a += aSViewSize) {
            
            CGRect asanaFrame = CGRectMake( a, i, aImageSize, aImageSize );
            CGRect buttonFrame = CGRectMake( 1, 1, aImageSize, aImageSize );
            
            if (c < imagesCount) {
                
                UIView *asanaView = [[UIView alloc] initWithFrame:asanaFrame];
                UIButton *asanaButton = [[UIButton alloc] initWithFrame:buttonFrame];
                asanaView.tag = [[self.imagesNames objectAtIndex:c] intValue];
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
                [asanasViews addObject:asanaView]; // add asana view in self array
                
                [contentView addSubview:asanaView];
            }
            c++;
            
        }
        
        
    }
    [scrollView addSubview:contentView];
    return scrollView;
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
                NSUInteger fileNumber = [[self.imagesNames objectAtIndex:i] integerValue];
                NSString *fileName = [NSString stringWithFormat:@"%d", fileNumber];
                fileName = [fileName stringByAppendingString:@".png"];
                UIImage *asana = [UIImage imageNamed:fileName];
                
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
                NSUInteger fileNumber = [[self.imagesNames objectAtIndex:i] integerValue];
                NSString *fileName = [NSString stringWithFormat:@"%d", fileNumber];
                fileName = [fileName stringByAppendingString:@".png"];
                UIImage *asana = [UIImage imageNamed:fileName];
                
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
    [[[[asanasViews objectAtIndex:tag] subviews] objectAtIndex:1] stopAnimating];
    aView.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ aView.alpha = 1.0; }
                     completion:^(BOOL fin) {/* if (fin) [myView removeFromSuperview]; */}];
    
    if (![[[asanasViews objectAtIndex:tag] subviews] count] < 3) {
         [[asanasViews objectAtIndex:tag] addSubview:aView];
    }
    
    loadedImages += 1;
   
}



- (void)checkAsana:(UIButton *)sender {
    
    UIImageView *asanaImageView = [[[asanasViews objectAtIndex:sender.tag] subviews] objectAtIndex:2]; 
//    debug(@"asanasView atObjectIndex 1 is %@", asanaImageView);
//    debug(@"asana nuber is %d", asanaImageView.tag);
    
    // add or uncheck asana 
    if (![choiceResult containsObject:asanaImageView]) {
        [choiceResult addObject:asanaImageView];
        buttonLayer = [sender layer];
        [buttonLayer setBorderWidth:2.0];
        [buttonLayer setBorderColor:[[UIColor redColor] CGColor]];
    }
    else {
        [choiceResult removeObject:asanaImageView];
        buttonLayer = [sender layer];
        [buttonLayer setBorderWidth:1.0];
        [buttonLayer setBorderColor:[[UIColor grayColor] CGColor]];
    }
}

#pragma mark - To next view (Sequences) : button and ViewController




- (void)createSequences {
    
    if ([choiceResult count] < 10) {
        
        if ([choiceResult count] == 0) {
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
    NSArray *sortedArray = [choiceResult sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    cs -> allAsanas = [NSMutableArray arrayWithArray:sortedArray];
    [self.navigationController pushViewController:cs animated:YES];
    
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
#pragma mark -
#pragma mark UIScrollViewDelegate mehods 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    debug(@"contentOffset is %@",  NSStringFromCGPoint(*targetContentOffset));
    
    unsigned gap;
    unsigned offset = (unsigned) targetContentOffset->y ;
    debug(@"offset is %d",  offset);
    debug(@"offse1 is %d",  (offset - 100)%116);
    debug(@"offset2 is %d",  (offset - offset%116)/116);

    gap = (offset - offset%116)/116 * 6;
  debug(@"countet image for loading is %d",  gap);
    gap += 54;
    if (gap > imagesCount) {gap = imagesCount;}
    if (gap > loadedImages) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self loadImageAsynchFrom:loadedImages upTo:gap];
        });      

    } 
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
