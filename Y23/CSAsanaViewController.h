//
//  CSAsanaViewController.h
//  Y23
//
//  Created by IgorChe on 6/1/13.
//
//

#import <UIKit/UIKit.h>

@interface CSAsanaViewController : UIViewController {
    

 }

@property (nonatomic,weak) IBOutlet UIImageView     *bgImageView;
@property (nonatomic,weak) IBOutlet UIButton        *button;
@property (nonatomic,weak) IBOutlet UIView          *countView;
@property (nonatomic,weak) IBOutlet UILabel         *countLabel;
@property (nonatomic,weak)  NSString                *asanaKey;

@end
