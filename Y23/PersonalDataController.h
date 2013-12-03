//
//  PersonalDataController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSTipsViewController.h"

@class AppDelegate;

@interface PersonalDataController : UIViewController  <UITextFieldDelegate, UITextViewDelegate,RemoveTipViewsProtocol> {
    
    AppDelegate             *appDelegate;
    __weak IBOutlet UIView  *guideView;
    CSTipsViewController    *tpvc;
}

@property (assign, nonatomic) IBOutlet UITextField *firstName;
@property (assign, nonatomic) IBOutlet UITextField *lastName;
@property (assign, nonatomic) IBOutlet UITextField *eMail;
@property (assign, nonatomic) IBOutlet UITextView *notes;
@property (assign, nonatomic) NSMutableDictionary *personalData;

- (void)removeTips;

@end
