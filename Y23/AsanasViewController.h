//
//  AsanasViewController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxButton.h"

@interface AsanasViewController : UIViewController {
    NSArray *levelsButtons;
}

@property (nonatomic, strong) NSMutableArray *selectedAsanas;      // array for result of selection 
@property (nonatomic, strong) NSMutableArray *sequences;           // array for result of sorting
@property (nonatomic, weak) NSString *person;                      
@property (nonatomic, strong) IBOutlet CheckBoxButton *main;       // three checkboxes for selection
@property (nonatomic, strong) IBOutlet CheckBoxButton *express;
@property (nonatomic, strong) IBOutlet CheckBoxButton *byLevel1;
@property (nonatomic, strong) IBOutlet CheckBoxButton *byLevel2;
@property (nonatomic, strong) IBOutlet CheckBoxButton *byLevel3;
@property (nonatomic, strong) IBOutlet CheckBoxButton *byLevel4;
@property (nonatomic, strong) IBOutlet CheckBoxButton *byLevel5;
@property (nonatomic, strong) IBOutlet CheckBoxButton *byLevel6;
@property (nonatomic, strong) IBOutlet CheckBoxButton *byLevel7;
@property (nonatomic, strong) IBOutlet UIButton *goMain;           // three buttons-arrows for transition to selection
@property (nonatomic, strong) IBOutlet UIButton *goExpress;
@property (nonatomic, strong) IBOutlet UIButton *goByLevel;

- (IBAction) selectedList: (CheckBoxButton*) sender;
-(void)addNotes;

@end
