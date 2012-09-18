//
//  UIView+Animation.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Animation.h"
#import "QuartzCore/QuartzCore.h"

@implementation UIView (Animation)


- (void) moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option {
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.center = CGPointMake(destination.x,destination.y);
                     }
                     completion:nil];
}

- (void) scaleTo:(CGRect)bounds duration:(float)secs {
    [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ self.bounds = bounds; }
                     completion:^(BOOL fin) {  }];
}



- (id) copyWithImageView:(UIImageView*)imageView{
    
    id copiedView = [[UIView alloc] init];
    [copiedView addSubview:imageView];
    
    return copiedView;
}

- (UIImage *) imageFromView {
    
    
    UIGraphicsBeginImageContext(self.frame.size);
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *scaledImage = 
    [UIImage imageWithCGImage:[screenshot CGImage] 
                        scale:1.4 orientation:UIImageOrientationUp];
    return scaledImage;
}

@end
