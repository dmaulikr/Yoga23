//
//  AppDelegate.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize theNewProgram = _theNewProgram, asanasCatalog = _asanasCatalog;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBackgroundImage:nil];
    self.theNewProgram = [[NSMutableDictionary alloc] init];
    [self.theNewProgram setObject:[NSMutableDictionary dictionaryWithCapacity:4] forKey:@"personal"];
    [self.theNewProgram setObject:[NSMutableArray array] forKey:@"asanas"];
    [self.theNewProgram setObject:[NSMutableArray array] forKey:@"technics"];
    NSMutableString *notesText = [[NSMutableString alloc] initWithString:@"Here notes"];
    [self.theNewProgram setObject:notesText forKey:@"notes"];
    
    [self loadAsanasImages];
    
    return YES;
    
}

- (void)loadAsanasImages {
    
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"mainCollection" ofType:@"csv"];
    NSString *csvString = [[NSString stringWithContentsOfFile:file
                                                     encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *stringValues = [csvString componentsSeparatedByString:@","];
    _asanasCatalog = [[NSMutableDictionary alloc] initWithCapacity:[stringValues count]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    
    for (NSString *name in stringValues) {
        dispatch_async(queue, ^{
            
            UIImage *asanaImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@",name, @"png"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_asanasCatalog setObject:asanaImage forKey:name];
            });
        });
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

@end
