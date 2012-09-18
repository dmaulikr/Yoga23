//
//  TechnicDetails.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxButton.h"

@interface TechnicDetails : UIViewController {
    NSString *technicName;
    NSArray *elementsNames;
    NSUInteger elementIndex;
    NSMutableArray *selectedElements;
}


- (id)initWithName:(NSString *)name elements:(NSArray *)elements tag:(int) tag;
- (void)addProgramSubItem:(CheckBoxButton *)sender;

@end
