//
//  AppDelegate.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *theNewProgram;
@property (strong, nonatomic) __block NSMutableDictionary *asanasCatalog;
@property (strong, nonatomic)  NSMutableDictionary *selectedAsanas;
@property (strong, nonatomic)  NSMutableDictionary *asanasCounter;
@property (strong, nonatomic)  NSMutableArray *unsavedSequence;

- (void)pageTrackingGA:(NSString*)page;
- (void)eventTrackingGA:(NSString*)event andAction:(NSString*)action andLabel:(NSString*)label;
- (void)saveToUserDefaults:(id)object forKey:(NSString*)key;
- (id)retrieveFromUserDefaults:(NSString*)key;

@end
