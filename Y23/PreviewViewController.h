//
//  PreviewViewController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"


@interface PreviewViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
@protected
    AppDelegate *appDelegate;
    UIWebView *presentWebView;
    NSString *tempFileName;             // PDF File name
    NSMutableArray *sequences;          // AppDelegate sequences images array
    NSMutableArray *technics;           // AppDelegate technics array
    NSMutableString *technicsList;      // list of chosen technics
    int sequenceNumber;
    float startTextRectY;
    CFRange currentTextRange;
    CTFramesetterRef textFramesetter;  // text range and framesetter
    
    MFMailComposeViewController *email;

    
}




- (void)createPDFforPreview;
- (void)showWebViewWithURL:(NSURL *)url;
- (NSInteger)numberOfSequencesPages;
- (void)drawPageContentImages:(NSMutableArray*)seqImages;
- (void)sendingProgrammToEmile;
- (void)createTechnicsList;
- (CFRange)renderPageInRect:(CGRect)rect withTextRange:(CFRange)currentRange
             andFramesetter:(CTFramesetterRef)framesetter;

@end
