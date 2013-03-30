//
//  PIAcanasTableViewCell.h
//  Y23
//
//  Created by IgorChe on 3/30/13.
//
//

#import <UIKit/UIKit.h>

@interface PIAcanasTableViewCell : UITableViewCell {
    
    NSArray     *cellButtons;
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
- (void)setupButtonsImages:(NSArray*)array;


@end
