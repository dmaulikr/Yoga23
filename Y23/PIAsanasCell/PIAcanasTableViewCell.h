//
//  PIAcanasTableViewCell.h
//  Y23
//
//  Created by IgorChe on 3/30/13.
//
//

@protocol TapOnAsanaProtocol <NSObject>

- (void)asanaButtonPressed:(id)sender;

@end

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface PIAcanasTableViewCell : UITableViewCell {
    
    NSArray     *cellButtons;
    AppDelegate *appDelegate;
}

@property(nonatomic,strong)IBOutlet UIButton          *asanaButton1;
@property(nonatomic,strong)IBOutlet UIButton          *asanaButton2;
@property(nonatomic,strong)IBOutlet UIButton          *asanaButton3;
@property(nonatomic,strong)IBOutlet UIButton          *asanaButton4;
@property(nonatomic,strong)IBOutlet UIButton          *asanaButton5;
@property(nonatomic,strong)IBOutlet UIButton          *asanaButton6;
@property(nonatomic,strong)NSArray                    *cellAsanas;
    

+ (PIAcanasTableViewCell *)cellFromNibNamed:(NSString *)nibName;
+ (NSString *)reuseIdentifier;
- (void)setupButtonsImages:(NSArray*)array range:(int)range delegate:(id)delegate;


@end
