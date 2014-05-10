//
//  PreviewViewController.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import <CoreImage/CoreImage.h>
#import "PreviewViewController.h"
#import "NotesModalController.h"
#import "UIImage+Inverting.h"
#import "FFTransAlertView.h"
#import "TechnicsController.h"
#import "AsanasViewController.h"
#import "MainTabbarController.h"


@interface PreviewViewController () <HideNotesViewProtocol> 

@end

@implementation PreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}


#pragma mark Adding Notes to AppDelegate array

-(void)addNotes {
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Get Notes" andLabel:@"Preview"];
    NotesModalController *nmc = [[NotesModalController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:nmc];
    
    // do any setup you need for navController
    navController.modalTransitionStyle =  UIModalTransitionStyleFlipHorizontal;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
    nmc.delegate = self;
    
    
    navController.view.superview.center = self.view.center;
}

-(void)notesDone {
    
    // Google An
    [appDelegate eventTrackingGA:@"Notes" andAction:@"Hide Notes" andLabel:@"Preview"];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - Creating technics list

- (void)createTechnicsList {
    
    if (!technicsList) {
        technicsList = [[NSMutableString alloc] init];
    }else{
        [technicsList setString:@""];
    }
    
    for (id element in technics) {
        if ([element isKindOfClass:[NSString class]]) {
            [technicsList appendString:element];
            [technicsList appendString:@"\n"];
            
        }
        if ([element isKindOfClass:[NSDictionary class]]) {
            NSString *name = [[element allKeys] objectAtIndex:0];
            NSMutableArray *elements = [[element valueForKey:name] mutableCopy];
            [elements removeObjectIdenticalTo:[NSNull null]];
            if ([elements count] > 0) {
                [technicsList appendString:name];
                [technicsList appendString:@" :\n"];
                for (NSString *str in elements) {
                    [technicsList appendString:@"     "];
                    [technicsList appendString:str];
                    [technicsList appendString:@"\n"];
                }
            }
        }
    }
}


#pragma mark - Creating PDF 

- (NSInteger)numberOfSequencesPages {
    int pagesNumber = 1;
    int pageContentHeight = 0;

    for(UIImage* seq in sequences){
        pageContentHeight += seq.size.height + 40;
        if (pageContentHeight > 750) {
            pagesNumber++;
            pageContentHeight = seq.size.height;
        }
    }
    
    return pagesNumber;
}



- (void)drawPageNumber:(NSInteger)pageNum {
    
    UIFont* theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(612, 40);
    
    if (pageNum == 1) {
        // Header withe owner name and currend date
        CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
        NSString *createDate = [NSString stringWithFormat:@"%02d:%02d:%02.0ld", currentDate.day, currentDate.month, currentDate.year];
        NSString *firstname = [[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"firstName"];
        NSString *lastName = [[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"lastName"];
        NSString* textToDraw = [NSString stringWithFormat:@" %@ %@  %@", firstname?firstname:@"",lastName?lastName:@"", createDate];
        
        CGSize headSize = [textToDraw sizeWithFont:[UIFont systemFontOfSize:15]
                                 constrainedToSize:maxSize
                                     lineBreakMode:NSLineBreakByClipping];
        CGRect headRect = CGRectMake(((612.0 - headSize.width) / 2.0),
                                    40 - ((72.0 - headSize.height) / 2.0) ,
                                     headSize.width,
                                     headSize.height);
        
        [textToDraw drawInRect:headRect withFont:[UIFont systemFontOfSize:15]];
    }
    
    NSString* pageString = [NSString stringWithFormat:@"Page %d", pageNum];

    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:NSLineBreakByClipping];
    CGRect stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
                                   720.0 + ((82.0 - pageStringSize.height) / 2.0) ,
                                   pageStringSize.width,
                                   pageStringSize.height);
    
    [pageString drawInRect:stringRect withFont:theFont];
    
}

- (void)drawPageContentImages:(NSMutableArray*)seqImages {
    
    bool done = NO;
    
    CGSize currentPoint = CGSizeMake(40, 55);
    float currentRange = currentPoint.height;
    
    while (done == NO) {
        
        UIImage *currentSeqImage = [seqImages objectAtIndex:0];
        
        // scale to needed size
        currentSeqImage = [currentSeqImage scaleImage:1.3];
        CGRect imageRect = CGRectMake(currentPoint.width, currentRange, currentSeqImage.size.width, currentSeqImage.size.height);
        [seqImages removeObjectAtIndex:0];
        
        // sequence number text
        int numberOfSequence = sequenceNumber - [seqImages count];
        NSString* numberString = [NSString stringWithFormat:@"Sequence number %d", numberOfSequence];
        
        CGSize numberStringSize = [numberString sizeWithFont:[UIFont systemFontOfSize:12]
                                           constrainedToSize:CGSizeMake(200, 40.0)
                                               lineBreakMode:NSLineBreakByClipping];
        CGRect stringRect = CGRectMake(60,
                                       currentRange - 20.0 ,
                                       numberStringSize.width,
                                       numberStringSize.height);
        
        [numberString drawInRect:stringRect withFont:[UIFont systemFontOfSize:12]];
        
        
        // invert color and draw an image on pdf context
        [[currentSeqImage invertImage] drawInRect:imageRect];
        currentRange += (currentSeqImage.size.height + 25);
        
        if ([seqImages count] != 0 ) {
            
            // next image
            
            currentSeqImage = [seqImages objectAtIndex:0];
            if ( 740 - currentRange < currentSeqImage.size.height) {
                
                done = YES;
            }
            
        }else {
            if( 682 - currentRange > 50){
                
                
                CGRect textRect = CGRectMake(40.0, lroundf(currentRange), 532.0, lroundf(682.0 - currentRange));
                dPrint(@"currentRange is %f", currentRange);
                
                currentTextRange = [self renderPageInRect:textRect withTextRange:currentTextRange andFramesetter:textFramesetter];
                
            }
            done = YES; ;   
        }
        
        
        
        
    }
    
    
}

- (CFRange)renderPageInRect:(CGRect)rect withTextRange:(CFRange)currentRange
       andFramesetter:(CTFramesetterRef)framesetter {
    
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Create a path object to enclose the text.
    dPrint(@"rect: %@", NSStringFromCGRect(rect));
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, rect);
    
    // Get the frame that will do the rendering.
    // The currentRange variable specifies only the starting point. The framesetter
    // lays out as much text as will fit into the frame.
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 682.0 + rect.origin.y);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Update the current range based on what was drawn.
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    currentRange.location += currentRange.length;
    currentRange.length = 0;
    CFRelease(frameRef);
    
    return currentRange;
}

- (void)createPDFforPreview {
    
    CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
    NSString *createDate = [NSString stringWithFormat:@"%02d:%02d:%02.0ld", currentDate.day, currentDate.month, currentDate.year];
    NSString *firstname = [[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"firstName"];
    if ([firstname length] < 1) firstname = @"Disciple";
    NSString *lastName = [[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"lastName"];
    if (!lastName) lastName = @"";
    shortFileNAme = [NSString stringWithFormat:@"%@_%@_%@Y23.PDF", firstname, lastName, createDate]; //  pdf file name

    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    
    tempFileName = [path stringByAppendingPathComponent:shortFileNAme]; // full pdf file name in bundle
    
    dPrint(@"path is %@", tempFileName);
    
    
    // Prepare common text assamble
    NSMutableString *commonText = technicsList;
    
    NSString *notes = [appDelegate.theNewProgram objectForKey:@"notes"];
    if (![notes isEqualToString:NSLocalizedString(@"Type notes here..", @"")] && !notes.length < 2) {
        [commonText appendString:@"\n\n\n"];
        [commonText appendString:@" NOTES: \n\n"];
        [commonText appendString:[appDelegate.theNewProgram objectForKey:@"notes"]];
    }
    
    dPrint(@"commonText is %@", commonText);
    
    // create mutable for seting font
    CFMutableAttributedStringRef currentText = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    // Prepare the text using a Core Text Framesetter
    if (commonText != nil)
        CFAttributedStringReplaceString (currentText, CFRangeMake(0, 0), (CFStringRef)commonText);
    
    //    create font
    CTFontRef font = CTFontCreateWithName(CFSTR("TimesNewRomanPSMT"), 18, NULL);
    
    //    set font attribute
    CFAttributedStringSetAttribute(currentText, CFRangeMake(0, CFAttributedStringGetLength(currentText)), kCTFontAttributeName, font);
    
    //    release font
    CFRelease(font);
    
    if (currentText) {
         textFramesetter = CTFramesetterCreateWithAttributedString(currentText);
        
        if (textFramesetter) {
            currentTextRange = CFRangeMake(0, 0);
        }
    }
    
    
    

    
    
    // Create the PDF context using the default page size of 612 x 792.
    
    UIGraphicsBeginPDFContextToFile(tempFileName, CGRectZero, nil);
    
    NSInteger currentPage = 0;
    BOOL done = NO;
    
    NSMutableArray *neededSequences = [[NSMutableArray alloc] initWithArray:sequences copyItems:YES];
    sequenceNumber = [neededSequences count];
    
    
    
    //dPrint(@"neededSequences is %@", neededSequences);
    do {
        
        // Draw a page number at the bottom of each page
        
        if ([neededSequences count] != 0) {
            
            // Mark the beginning of a new page.
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0.0, 0.0, 612.0, 792.0), nil);
            
            currentPage++;
            [self drawPageNumber:currentPage];
            
            [self drawPageContentImages:neededSequences];
            
        }else {done = YES;}
        
    }while (done == NO);
    
    
    
    bool textDone = NO;
    
    do {
        if (currentTextRange.location != CFAttributedStringGetLength((CFAttributedStringRef)currentText)) {
            
            // Mark the beginning of a new page.
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 50.0, 612.0, 742.0), nil);
            
            currentPage++;
            [self drawPageNumber:currentPage];
            
            // Render the current page and update the current range to
            // point to the beginning of the next page.
                
            CGRect textRect = CGRectMake(40.0, 55.0, 532.0, 682.0);
            
            currentTextRange = [self renderPageInRect:textRect withTextRange:currentTextRange andFramesetter:textFramesetter];
            
            // If we're at the end of the text, exit the loop.
            if (currentTextRange.location == CFAttributedStringGetLength((CFAttributedStringRef)currentText)) textDone = YES;
            
            // If we're at the end of the text, exit the loop.
        } else {textDone = YES;}
        
    }while (textDone == NO);
    

    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    // Release the framesetter.
    CFRelease(textFramesetter);
    // Release the attributed string.
    CFRelease(currentText);
    
    NSURL *url = [NSURL fileURLWithPath:tempFileName];
    [self showWebViewWithURL:url];
}

#pragma mark - Sending PDF file email methodes

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            // Google An
            [appDelegate eventTrackingGA:@"Preview" andAction:@"Send programm" andLabel:@"Cancel"];
            NSLog(@"cancelled");
            break;
        case MFMailComposeResultSaved:
            // Google An
            [appDelegate eventTrackingGA:@"Preview" andAction:@"Send programm" andLabel:@"Saved"];
            [self afterSendingAlert];
            break;
        case MFMailComposeResultSent:
            [appDelegate eventTrackingGA:@"Preview" andAction:@"Send programm" andLabel:@"Sent"];
            [self afterSendingAlert];
            break;
        case MFMailComposeResultFailed: {
            CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"Error sending email!",@"Error sending email!")
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Bummer",@"Bummer")
                                                  otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendingProgrammToEmile {
    
    // Google An
    [appDelegate eventTrackingGA:@"Preview" andAction:@"Send programm" andLabel:@"Button"];
    
    
    email = [[MFMailComposeViewController alloc] init];
    email.mailComposeDelegate = self;
    
    // Subject
    [email setSubject:@"Yoga 23 training"];
    
    if ([[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"eMail"]) {
        [email setToRecipients:@[[[appDelegate.theNewProgram objectForKey:@"personal"] objectForKey:@"eMail"]]];
    }
    
    
    // Optional Attachments
    NSData *pdfData = [NSData dataWithContentsOfFile:tempFileName];
    [email addAttachmentData:pdfData mimeType:@"application/pdf" fileName:shortFileNAme];
    
    // Body
    [email setMessageBody:@"This is the body" isHTML:NO];
    
    // Present it
    [self presentViewController:email animated:YES completion:nil];
}

- (void)afterSendingAlert {
    UIAlertView *requestForClearAlert = [[UIAlertView alloc] initWithTitle:@"Purge it?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Clear", nil];
    requestForClearAlert.tag = 10;
    [requestForClearAlert show];
}

- (void)clearAll {
    // Google An
    [appDelegate eventTrackingGA:@"Clear programm" andAction:@"Clear after sending " andLabel:nil];
    
    MainTabbarController *mtc = (MainTabbarController*)self.tabBarController;
    mtc.asanasCleaning      = YES;
    mtc.technicsCleaning    = YES;
    Technics *techController = (Technics*)[[[[mtc viewControllers] objectAtIndex:2] viewControllers] objectAtIndex:0] ;
    techController.clearing = YES;
   
    [[appDelegate.theNewProgram objectForKey:@"personal"]  removeAllObjects];
    [[appDelegate.theNewProgram objectForKey:@"asanas"]  removeAllObjects];
    [[appDelegate.theNewProgram objectForKey:@"technics"]  removeAllObjects];
    [appDelegate.selectedAsanas removeAllObjects];
    [appDelegate.asanasCounter removeAllObjects];
    NSMutableString *notesText = [[NSMutableString alloc] initWithString:NSLocalizedString(@"Type notes here..", @"")];
    [appDelegate.theNewProgram setObject:notesText forKey:@"notes"];
    [appDelegate.unsavedSequence removeAllObjects];
    
}

#pragma mark - UIAlertView Delegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 10) {
        switch (buttonIndex) {
            case 0:
                [presentWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
                self.tabBarController.selectedIndex = 0;
                break;
            case 1:
                [self clearAll];
                [presentWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
                self.tabBarController.selectedIndex = 0;
                break;
                
            default:
                break;
        }
    }else if (alertView.tag == 20){
        NSLog(@"self.tabBarController.selectedIndex = 1");
        self.tabBarController.selectedIndex = 1;
    }

        
}

#pragma mark - View LifeCicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!appDelegate) {
        appDelegate= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    
    UIBarButtonItem *sendItem            = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendingProgrammToEmile)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:sendItem, nil];
    
    if(!presentWebView){
        // 
        CGRect frame = CGRectMake(55, 35, 658, 850);
        presentWebView = [[UIWebView alloc] initWithFrame:frame];
        presentWebView.backgroundColor = [UIColor lightGrayColor];
    }
    [self.view addSubview:presentWebView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)showWebViewWithURL:(NSURL *)url {
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [presentWebView loadRequest:requestObj];
}




- (void)viewWillAppear:(BOOL)animated {
    
    sequences = [appDelegate.theNewProgram objectForKey:@"asanas"];
    technics = [appDelegate.theNewProgram objectForKey:@"technics"];
    
    //dPrint(@" technics is %@", [appDelegate.theNewProgram objectForKey:@"technics"]);
    
    [self createTechnicsList]; // creating technics text for PDF 
        
    if ([sequences count] == 0) {
        // warning massage here
        CustomAlert *noAsanas = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"No saved sequences ..", @"")
                                                           message:NSLocalizedString(@"Please create at least one asanas sequence", @"")
                                                          delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                                 otherButtonTitles:nil];
        noAsanas.delegate = self;
        noAsanas.tag = 20;
        [noAsanas show];
        
//    }else if ([technicsList length] < 1) {
//        // warning massage here
//        UIAlertView *noTechnics = [[UIAlertView alloc] initWithTitle:@"No saved technics .."
//                                                           message:@"You have not chosen technics!" 
//                                                          delegate:nil cancelButtonTitle:@"Ok" 
//                                                 otherButtonTitles:nil];
//        [noTechnics show];
//        
    }else {
        // set current date
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd/MM/YY HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        [[appDelegate.theNewProgram objectForKey:@"personal"] setObject:dateString forKey:@"createDate"];
        [self createPDFforPreview];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [appDelegate pageTrackingGA:@"Preview"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:tempFileName error:nil];

    // listing all files in Documents directory
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    
    NSArray *directoryContent = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    for (int count = 0; count < (int)[directoryContent count]; count++)
    {
        //dPrint(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
         [fileManager removeItemAtPath:[directoryContent objectAtIndex:count] error:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
