//
//  AppDelegate.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@import UIKit;


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
