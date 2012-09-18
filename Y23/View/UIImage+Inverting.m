//
//  UIImage+Inverting.m
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//

#import "UIImage+Inverting.h"

@implementation UIImage (Inverting)

-(UIImage*)invertImage {
    
    
    UIGraphicsBeginImageContext(self.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height));
    UIImage *invertedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return invertedImage;
}

- (UIImage*)scaleImage:(float)scale {
    
    UIImage *scaledImage = [UIImage imageWithCGImage:[self CGImage]
                                               scale:scale orientation:UIImageOrientationUp];
    
    return scaledImage;
}
@end
