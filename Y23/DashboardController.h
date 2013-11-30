//
//  DashboardController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface DashboardController : UIViewController {
    
    AppDelegate     *appDelegate;
}

@property (nonatomic, weak) NSString *person;

@end
