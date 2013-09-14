//
//  MainTabbarController.m
//  Y23
//
//  Created by IgorChe on 6/15/13.
//
//

#import "MainTabbarController.h"

@interface MainTabbarController () <UITabBarControllerDelegate>

@end

@implementation MainTabbarController

@synthesize asanasCleaning = _asanasCleaning;
@synthesize technicsCleaning = _technicsCleaning;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
	// Do any additional setup after loading the view.
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nc = (UINavigationController*) viewController;
    
    NSLog(@"selected %d nc - %@",tabBarController.selectedIndex,nc);
    
    if (tabBarController.selectedIndex == 1 && _asanasCleaning) {
        _asanasCleaning = NO;
        [nc popToRootViewControllerAnimated:NO];
    }else if (tabBarController.selectedIndex == 2 && _technicsCleaning) {
        _technicsCleaning = NO;
        [nc popToRootViewControllerAnimated:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
