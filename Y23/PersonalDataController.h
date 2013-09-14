//
//  PersonalDataController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface PersonalDataController : UIViewController  <UITextFieldDelegate, UITextViewDelegate> {
    
    AppDelegate         *appDelegate;
}

@property (assign, nonatomic) IBOutlet UITextField *firstName;
@property (assign, nonatomic) IBOutlet UITextField *lastName;
@property (assign, nonatomic) IBOutlet UITextField *eMail;
@property (assign, nonatomic) IBOutlet UITextView *notes;
@property (assign, nonatomic) NSMutableDictionary *personalData;

@end
