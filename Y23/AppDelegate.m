//
//  AppDelegate.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "Flurry.h"

#define kGoogleAnalyticsKey @"UA-44975470-1"
#define kFlurryAPIKey @"P7R8KNDDJRDFBHYHZQ74"


@implementation AppDelegate

@synthesize window = _window;
@synthesize theNewProgram = _theNewProgram, asanasCatalog = _asanasCatalog, selectedAsanas = _selectedAsanas;
@synthesize asanasCounter = _asanasCounter;
@synthesize unsavedSequence = _unsavedSequence;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 10;
    
    // Optional: set Logger to VERBOSE for dPrint information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsKey];
    // Set the new tracker as the default tracker, globally.
    [GAI sharedInstance].defaultTracker = tracker;
    
    // Flurry
    [Flurry setCrashReportingEnabled:YES];
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:kFlurryAPIKey];
    
    // Staff
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UITabBar appearance] setBackgroundImage:nil];
    self.theNewProgram = [[NSMutableDictionary alloc] init];
    [self.theNewProgram setObject:[NSMutableDictionary dictionaryWithCapacity:4] forKey:@"personal"];
    [self.theNewProgram setObject:[NSMutableArray array] forKey:@"asanas"];
    [self.theNewProgram setObject:[NSMutableArray array] forKey:@"technics"];
    NSMutableString *notesText = [[NSMutableString alloc] initWithString:NSLocalizedString(@"Type notes here..", @"")];
    [self.theNewProgram setObject:notesText forKey:@"notes"];
    _selectedAsanas = [NSMutableDictionary dictionary];
    _asanasCounter = [NSMutableDictionary dictionary];
    _unsavedSequence = [NSMutableArray array];
    
    [self loadAsanasImages];
    
    return YES;
    
}

- (void)loadAsanasImages {
    
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"mainCollection" ofType:@"csv"];
    NSString *csvString = [[NSString stringWithContentsOfFile:file
                                                     encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    stringValues = [csvString componentsSeparatedByString:@","];
    
       
    
    
    
    _asanasCatalog = [[NSMutableDictionary alloc] initWithCapacity:[stringValues count]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    for (NSString *name in stringValues) {
        dispatch_async(queue, ^{
            
            NSString *aName = [NSString stringWithFormat:@"%@",name];
            UIImage *asanaImage = [UIImage imageNamed:aName];
            
                [_asanasCatalog setObject:asanaImage forKey:name];
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
    
    [[GAI sharedInstance] dispatch];
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

#pragma mark GoogleAnalytics

- (void)pageTrackingGA:(NSString*)page {
    
    // GoogleAn
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:page];
    [tracker send:[[GAIDictionaryBuilder createAppView]  build]];
    
    // Flurry page
    NSDictionary *pageParams = @{@"pageName":page};
    [Flurry logEvent:@"Page opened" withParameters:pageParams];
    
}

- (void)eventTrackingGA:(NSString*)event andAction:(NSString*)action andLabel:(NSString*)label {
    
    // GoogleAn
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:event     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label          // Event label
                                                           value:nil] build]];    // Event value
    
    // Flurry event
    NSDictionary *articleParams = @{@"action":action?action:@"nil",
                                    @"label":label?label:@"nil"};
    [Flurry logEvent:event withParameters:articleParams];
}

- (void)saveToUserDefaults:(id)object forKey:(NSString*)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (id)retrieveFromUserDefaults:(NSString*)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id object = [defaults objectForKey:key];
    
    return object;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

@end
