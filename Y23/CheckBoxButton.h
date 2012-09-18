//
//  CheckBoxButton.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxButton : UIButton {
    BOOL checked;
}

@property (nonatomic, assign) BOOL checked;

-(void)onClicked;

@end

