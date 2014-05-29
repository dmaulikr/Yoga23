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
    UIEdgeInsets insets = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0);
    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];

    // temporary
    if ([parentController isEqualToString:@"Personal"]) {
        t2ImageView.image = stretchableImage;
        t3ImageView.image = stretchableImage;
    }
    if ([parentController isEqualToString:@"Asanas"]) {
        t1ImageView.image = stretchableImage;
    }
    if ([parentController isEqualToString:@"Technics"]) {
        t4ImageView.image = stretchableImage;
    }
    
    if ([parentController isEqualToString:@"Dashboard"]) {
        t5ImageView.image = stretchableImage;
    }


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UITapGestureRecognizer *tgrFullScreen = [[UITapGestureRecognizer alloc] initWithTarget:_viewDelegate action:@selector(removeTips)];
    UIView *aView = [[UIView alloc] initWithFrame:self.view.bounds];
    [aView addGestureRecognizer:tgrFullScreen];
    [self.view addSubview:aView];
    
    tgrFullScreen.delegate = self;
  
    if ([parentController isEqualToString:@"Personal"]) [self personalTips];
    
    if ([parentController isEqualToString:@"Asanas"]) [self asanasTips];
    
    if ([parentController isEqualToString:@"Technics"]) [self technicsTips];
    
    if ([parentController isEqualToString:@"Dashboard"]) [self dashboardTips];
}

- (void)personalTips {
    
    [t2_View setHidden:NO];
    [t3_View setHidden:NO];
    
    float degrees1 = 225; //the value in degrees
    tp1_topArrow.transform = CGAffineTransformMakeRotation(degrees1 * M_PI/180);
    float degrees2 = 50; //the value in degrees
    tp2_downArrow.transform = CGAffineTransformMakeRotation(degrees2 * M_PI/180);
    
    t2_View.frame = CGRectMake(45.0, 255.0, t2_View.frame.size.width, t2_View.frame.size.height);
    t2_View.alpha = 0.0;
    t3_View.frame = CGRectMake(45.0, 750.0, t3_View.frame.size.width, t3_View.frame.size.height);
    t3_View.alpha = 0.0;
    [UIView animateWithDuration:1.2 animations:^{
        t2_View.alpha = 0.8;
        t3_View.alpha = 0.8;
    }];
    
    
    
    [UIView animateWithDuration:1.2
                          delay:1.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{ tp1_containerView.frame = CGRectMake(tp1_containerView.frame.origin.x + 130.0, tp1_containerView.frame.origin.y, tp1_containerView.frame.size.width, tp1_containerView.frame.size.height);}
                     completion:nil];
    
    //        [UIView animateWithDuration:0.6
    //                              delay:1.0
    //                            options:UIViewAnimationOptionCurveEaseInOut
    //                         animations:^{ }
    //                         completion:nil];
    
    [UIView animateWithDuration:0.3
                          delay:2.8
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{ tp2_containerView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){if (finished)tp2_containerView.alpha = 0.8;
                     }];
    


}

- (void)asanasTips {
    
    asanasTipHeader.text = NSLocalizedString(@"The asanas workflow contains 3 steps:", @"");
    asanasTipsLabel.text = NSLocalizedString(@"Asanas tips text", @"");

    t1_View.alpha = 0.0;
    [t1_View setHidden:NO];
    [UIView animateWithDuration:1.2 animations:^{
        t1_View.alpha = 0.8;
    }];
    
    
}


- (void)technicsTips {
    
    techniksTipsLabel.text = NSLocalizedString(@"Select technics for add to a program", @"");

    t4_View.alpha = 0.0;
    [t4_View setHidden:NO];
    [UIView animateWithDuration:1.2 animations:^{
        t4_View.alpha = 0.8;
    }];
}

- (void)dashboardTips {
    
    dashboardTipsLabel.text = NSLocalizedString(@"Here is Dashboard. It's a view for working with swings of the pendulum", @"");
    
    t5_View.alpha = 0.0;
    [t5_View setHidden:NO];
    [UIView animateWithDuration:1.2 animations:^{
        t5_View.alpha = 0.8;
    }];
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
    // NSLog(@"snapshotImage - %@", snapshotImage);
    // 3
    if (result) {
        UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
        UIImage *blurredImage = [snapshotImage applyBlurWithRadius:4 tintColor:tintColor saturationDeltaFactor:1.8
                                                         maskImage:nil];
       // NSLog(@"blurredImage - %@", blurredImage);
        _contentBGView.image = blurredImage;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
