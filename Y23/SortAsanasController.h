//
//  SortAsanasController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol AsanasSortAndSave <NSObject>

- (void)saveSequence:(UIImage*)seqImage;
- (void)setAddedAsanas:(NSMutableArray*)views;

@end

#import <UIKit/UIKit.h>
#import "SetBreathDataController.h"

@protocol ModalViewControllerDelegate <NSObject>

- (void)didDismissModalView;

@end

@class AppDelegate;

@interface SortAsanasController : UIViewController <UIGestureRecognizerDelegate, UIPopoverControllerDelegate,DismissPopoverProtocol> {
    @public
    NSMutableArray          *sequence;
    @private
    NSUInteger              asanasCount;
    CGPoint                 currLocation;
    UIView                  *contentView;
    UIPopoverController     *popController;
    SetBreathDataController *popoverContent;
    
    AppDelegate             *appDelegate;
    
   
}

@property (nonatomic, assign) id <AsanasSortAndSave>    delegate;
@property (nonatomic, strong) NSMutableArray            *asanasViews;


- (id)initWithSequence:(NSMutableArray*)currentSequence;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void) removeAsanaView:(UIView *)view;
- (void) inputBreathData:(UIButton*)sender;


@end
