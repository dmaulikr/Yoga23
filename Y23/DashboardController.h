//
//  DashboardController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTipsViewController.h"

@class AppDelegate;

@interface DashboardController : UIViewController <RemoveTipViewsProtocol> {
    
    AppDelegate             *appDelegate;
    CSTipsViewController    *tpvc;
}

@property (nonatomic, weak) NSString *person;

- (void)removeTips;

@end
