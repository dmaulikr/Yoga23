//
//  PIAcanasTableViewCell.m
//  Y23
//
//  Created by IgorChe on 3/30/13.
//
//

#import "PIAcanasTableViewCell.h"

@implementation PIAcanasTableViewCell : UITableViewCell

@synthesize asanaButton1 = _asanaButton1,asanaButton2 = _asanaButton2;
@synthesize asanaButton3 = _asanaButton3,asanaButton4 = _asanaButton4;
@synthesize asanaButton5 = _asanaButton5,asanaButton6 = _asanaButton6;
@synthesize cellAsanas = _cellAsanas;


+ (PIAcanasTableViewCell *)cellFromNibNamed:(NSString *)nibName {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PIAcanasTableViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PIAcanasTableViewCell class]]) {
            customCell = (PIAcanasTableViewCell *)nibItem;
            break; // we have a winner
        }
    }
    

    return customCell;
}


+ (NSString *)reuseIdentifier {
    
    return NSStringFromClass(self);
}

- (NSString *)reuseIdentifier {
    
    return [[self class] reuseIdentifier];
}


- (void)setupButtonsImages:(NSArray*)array {
    
    _cellAsanas = @[_asanaButton1,_asanaButton2,_asanaButton3,_asanaButton4,_asanaButton5,_asanaButton6];
    NSLog(@"images array is %@", array);
    for (int i = 0; i < [array count]; i++) {
        
        UIButton *button = [_cellAsanas objectAtIndex:i];
        [button setImage:[array objectAtIndex:i] forState:UIControlStateNormal];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
