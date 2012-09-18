//
//  UIView+Animation.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option;
- (void) scaleTo:(CGRect)bounds duration:(float)secs;
- (id) copyWithImageView:(UIImageView*)imageView;
- (UIImage *) imageFromView;

@end
