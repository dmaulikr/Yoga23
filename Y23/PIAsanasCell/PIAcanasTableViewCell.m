    //
//  PIAcanasTableViewCell.m
//  Y23
//
//  Created by IgorChe on 3/30/13.
//
//

#import "PIAcanasTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

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


- (void)setupButtonsImages:(NSArray*)array range:(int)range delegate:(id)delegate {
    
    if (!appDelegate) {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    _cellAsanas = @[_asanaButton1,_asanaButton2,_asanaButton3,_asanaButton4,_asanaButton5,_asanaButton6];
    for (int i = 0; i < [array count]; i++) {
        
        UIButton *button = [_cellAsanas objectAtIndex:i];
        UIImage *image = [array objectAtIndex:i];
        
        if (image) {
            
            [button setImage:image forState:UIControlStateNormal];
            [button setTag:(range + i)];
            [button addTarget:delegate action:@selector(asanaButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [[button layer] setBorderWidth:1.0f];
            
            if ([appDelegate.selectedAsanas objectForKey:[NSString stringWithFormat:@"%d",(range + i)]]) {
                
                [[button layer] setBorderColor:[UIColor redColor].CGColor];
                
            }else {
                
                [[button layer] setBorderColor:[UIColor lightGrayColor].CGColor];
            }
            
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
