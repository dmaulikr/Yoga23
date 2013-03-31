//
//  AsanasViewController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxButton.h"

@class AppDelegate;


@interface AsanasViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    
    __weak IBOutlet UIToolbar               *toolBar;
    __weak IBOutlet UISegmentedControl      *segmentCotrol;
    __weak IBOutlet UINavigationItem        *navigationItem;
    __weak IBOutlet UITableView             *table;
    NSArray                                 *namesArray;
    NSMutableArray                          *setsArray;
    NSMutableArray                          *asanasImages;
    NSMutableDictionary                     *choosedResult;
    unsigned                                loadedImages;
    unsigned                                linesCount;
    AppDelegate                             *appDelegate;
    NSMutableArray                          *asanasKeap;
    int                                     previousSegment;
    int                                     newSegment;
}

@property (nonatomic, strong) NSMutableArray    *selectedAsanas;   // array for result of selection 
@property (nonatomic, strong) NSMutableArray    *sequences;        // array for result of sorting
@property (nonatomic, weak) NSString            *person;                      


@end
