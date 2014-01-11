//
//  CSTipsViewController.h
//  Y23
//
//  Created by IgorChe on 11/22/13.
//
//

@protocol RemoveTipViewsProtocol <NSObject>

@required

- (void)removeTips;

@end

#import <UIKit/UIKit.h>

@interface CSTipsViewController : UIViewController <UIGestureRecognizerDelegate>{
    
    NSString                    *parentController;
    
    __weak IBOutlet UIImageView     *t1ImageView;
    __weak IBOutlet UIImageView     *t2ImageView;
    __weak IBOutlet UIImageView     *t3ImageView;
    __weak IBOutlet UIImageView     *t4ImageView;
    __weak IBOutlet UIImageView     *t5ImageView;
    
    __weak IBOutlet UIView          *t1_View;
    __weak IBOutlet UIView          *t2_View;
    __weak IBOutlet UIView          *t3_View;
    __weak IBOutlet UIView          *t4_View;
    __weak IBOutlet UIView          *t5_View;
    
    __weak IBOutlet UIImageView     *tp1_topArrow;
    __weak IBOutlet UIView          *tp1_containerView;
    
    __weak IBOutlet UIImageView     *tp2_downArrow;
    __weak IBOutlet UIView          *tp2_containerView;
    
    __weak IBOutlet UILabel         *asanasTipsLabel;
    __weak IBOutlet UILabel         *techniksTipsLabel;
    __weak IBOutlet UILabel         *dashboardTipsLabels;
}

@property (nonatomic,weak) IBOutlet UIImageView                         *contentBGView;
@property (nonatomic,strong) UIViewController <RemoveTipViewsProtocol>  *viewDelegate;


- (id)initWithSender:(NSString*)sender;

@end
