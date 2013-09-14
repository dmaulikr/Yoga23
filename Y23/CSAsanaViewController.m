//
//  CSAsanaViewController.m
//  Y23
//
//  Created by IgorChe on 6/1/13.
//
//

#import "CSAsanaViewController.h"

@interface CSAsanaViewController ()

@end

@implementation CSAsanaViewController

@synthesize bgImageView  = _bgImageView;
@synthesize button       = _button;
@synthesize countView  = _counterView;
@synthesize countLabel = _counterLabel;
@synthesize asanaKey     = _asanaKey;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
