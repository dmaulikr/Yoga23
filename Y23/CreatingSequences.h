//
//  CreatingSequences.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortAsanasController.h"
#import "AppDelegate.h"


@interface CreatingSequences : UIViewController <ModalViewControllerDelegate,AsanasSortAndSave> {
    
@public
    NSMutableArray *allAsanas;    
@protected
    AppDelegate             *appDelegate;
    NSUInteger              asanasCount; // count of all asanas
    NSMutableArray          *sequences; // all sequences
    UIScrollView            *seqScrollView;
    UIView                  *seqContentView;
    UIView                  *saveSequence;
    SortAsanasController    *sortController;
    NSMutableArray          *addedAsanas; // curent choosed asanas
    BOOL                    saved; // for saving event
    UIImage                 *counterBG;
    NSMutableArray          *trackedObjects; // all View Objects wiyh asanas buttons and views
    NSMutableArray          *controllersContainer;
}

@property (nonatomic, strong) NSMutableArray *currentSequenceViews; // current sequence



-(UIScrollView *)addScrollView;
-(void)checkAsanaForSequence:(id)sender; // adding asana to sequence array
-(void)toSorting;
-(void)didDismissModalView;
-(void)saveSequence:(UIImage *)currentSequence;
-(void)addNotes;

@end
