//
//  UIView+SetUserInteraction.m
//  Y23
//
//  Created by IgorChe on 9/28/13.
//
//

#import "UIView+SetUserInteraction.h"

@implementation UIView (SetUserInteraction)


-(void)setRecursiveUserInteraction:(BOOL)value{
    self.userInteractionEnabled =   value;
    for (UIView *view in [self subviews]) {
        [view setRecursiveUserInteraction:value];
    }
}

@end
