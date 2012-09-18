//
//  Technics.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxButton.h"
#import "TechnicDetails.h"

@interface Technics : UIViewController {
    
    NSArray *allTechnics;
}

@property (nonatomic, weak) NSMutableArray *selectedTechnics;
@property (nonatomic, weak) NSString *person;

- (void)addProgramItem:(CheckBoxButton*)sender ;
- (void)goTechnicDetails:(UIButton*)sender;

@end
