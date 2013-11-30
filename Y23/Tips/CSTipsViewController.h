//
//  CSTipsViewController.h
//  Y23
//
//  Created by IgorChe on 11/22/13.
//
//

#import <UIKit/UIKit.h>

@interface CSTipsViewController : UIViewController {
    
    NSString                    *parentController;
    
    __weak IBOutlet UIImageView *t1ImageView;
    __weak IBOutlet UIImageView *t2ImageView;
    __weak IBOutlet UIImageView *t3ImageView;
    
    __weak IBOutlet UIView      *t1_View;
    __weak IBOutlet UIView      *t2_View;
    __weak IBOutlet UIView      *t3_View;
    
}

@property (nonatomic,weak) IBOutlet UIImageView *contentBGView;
@property (nonatomic,strong) UIViewController   *viewDelegate;


- (id)initWithSender:(NSString*)sender;

@end
