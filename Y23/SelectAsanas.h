//
//  SelectAsanasController.h
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAsanas : UIViewController <UIScrollViewDelegate> {
    NSMutableArray *asanasViews;
    NSMutableSet *choiceResult;
    NSUInteger imagesCount;
    CALayer * buttonLayer;
    unsigned loadedImages;
}

@property (nonatomic, strong) NSArray *imagesNames;

-(UIScrollView *)addScrollView;
-(void) checkAsana:(UIButton *)sender;
-(void) loadImageAsynchFrom:(unsigned)first upTo:(unsigned)last;

@end
