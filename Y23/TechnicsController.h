//
//  Technics.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@import UIKit;

#import "CheckBoxButton.h"
#import "TechnicDetails.h"
#import "CSTipsViewController.h"
#import "CSTipsViewController.h"


@class AppDelegate;

@interface Technics : UIViewController <RemoveTipViewsProtocol,RemoveTipViewsProtocol> {
    
    AppDelegate             *appDelegate;
    CSTipsViewController    *tpvc;
    
    NSArray                 *allTechnics;
    UIView                  *contentView;
    
}

@property (nonatomic, weak) NSMutableArray  *selectedTechnics;
@property (nonatomic, weak) NSString        *person;
@property (nonatomic, assign)BOOL           clearing;

- (void)addProgramItem:(CheckBoxButton*)sender ;
- (void)goTechnicDetails:(UIButton*)sender;
- (void)removeTips;

@end
