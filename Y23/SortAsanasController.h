//
//  SortAsanasController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetBreathDataController.h"

@protocol ModalViewControllerDelegate <NSObject>

- (void)didDismissModalView;

@end

@interface SortAsanasController : UIViewController <UIGestureRecognizerDelegate, UIPopoverControllerDelegate> {
    @public
    NSMutableArray *sequence;
    @private
    NSUInteger asanasCount;
    CGPoint currLocation;
    UIView *contentView;
    UIPopoverController *popController;
    SetBreathDataController *popoverContent;
    
   
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSMutableArray *asanasViews;


- (id)initWithSequence:(NSMutableArray*)currentSequence;
- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
- (void) removeAsanaView:(UIView *)view;
- (void) inputBreathData:(UIButton*)sender;


@end
