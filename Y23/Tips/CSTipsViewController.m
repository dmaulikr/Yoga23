//
//  CSTipsViewController.m
//  Y23
//
//  Created by IgorChe on 11/22/13.
//
//

#import "CSTipsViewController.h"
#import "UIImage+ImageEffects.h"

@interface CSTipsViewController ()

@end

@implementation CSTipsViewController

@synthesize contentBGView = _contentBGView, viewDelegate = _viewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSender:(NSString*)sender
{
    self = [super init];
    if (self) {
        parentController = sender;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *originalImage = [UIImage imageNamed:@"t_labelBG"];
    UIEdgeInsets insets = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0);
    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
    t1ImageView.image = stretchableImage;
    t2ImageView.image = stretchableImage;
    t3ImageView.image = stretchableImage;
    
    if ([parentController isEqualToString:@"Personal"]) {
        [t1_View setHidden:YES];
        t2_View.frame = CGRectMake(250.0, -200.0, t2_View.frame.size.width, t2_View.frame.size.height);
        t3_View.frame = CGRectMake(45.0, 1300.0, t3_View.frame.size.width, t3_View.frame.size.height);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([parentController isEqualToString:@"Personal"]) {
        [UIView animateWithDuration:1.2 animations:^{
            t2_View.frame = CGRectMake(250.0, 265.0, t2_View.frame.size.width, t2_View.frame.size.height);
        }];
        
        [UIView animateWithDuration:1.2
                              delay:1.2
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{ t3_View.frame = CGRectMake(45.0, 750.0, t3_View.frame.size.width, t3_View.frame.size.height);}
                         completion:nil];
    }
}

- (void)updateImageView {
    // 1
    UIView *snapshotView = [_viewDelegate.view resizableSnapshotViewFromRect:self.view.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    // 2
    UIGraphicsBeginImageContextWithOptions(_contentBGView.bounds.size, YES, 0.0f);
    BOOL result = [snapshotView drawViewHierarchyInRect:_contentBGView.bounds
                                     afterScreenUpdates:NO];
    
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
     NSLog(@"snapshotImage - %@", snapshotImage);
    // 3
    if (result) {
        UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
        UIImage *blurredImage = [snapshotImage applyBlurWithRadius:4 tintColor:tintColor saturationDeltaFactor:1.8
                                                         maskImage:nil];
        NSLog(@"blurredImage - %@", blurredImage);
        _contentBGView.image = blurredImage;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
