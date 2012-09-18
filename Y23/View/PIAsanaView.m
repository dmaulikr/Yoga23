//
//  PIAsanaView.m
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//

#import "PIAsanaView.h"

#define debug NSLog


@implementation PIAsanaView

@synthesize leftNumber = _leftNumber, rightNumber = _rightNumber, labelsValues = _labelsValues;



-(id)init{
    if ((self = [super init])){
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"PIAsanaView" owner:self options:nil] objectAtIndex:0]];
        if (!inhaleTime) {
            inhaleTime = @"  ";
        }
        if (!inhalePausa) {
            inhalePausa = @" ";
        }
        if (!exhaleTime) {
            exhaleTime = @"  ";
        }
        if (!exhalePausa) {
            exhalePausa = @" ";
        }
        _labelsValues = [NSArray arrayWithObjects:@"_", inhaleTime, inhalePausa, exhaleTime, exhalePausa, nil];
    }
    return self;
}



- (void)setBrithingLoop:(NSArray*)loop {
    
    NSString *resultString = [NSString stringWithFormat:@"%@_%@  %@_%@",inhaleTime, inhalePausa, exhaleTime, exhalePausa];
    _leftNumber.text = [loop objectAtIndex:0];
    inhaleTime = [loop objectAtIndex:1];

    if ([inhaleTime length] == 1) {
        inhaleTime = [NSString stringWithFormat:@" %@", inhaleTime];
    }
    resultString = [resultString stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:inhaleTime];
    inhalePausa = [loop objectAtIndex:2];
    resultString = [resultString stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:inhalePausa];

    exhaleTime = [loop objectAtIndex:3];
    if ([exhaleTime length] == 1) {
        exhaleTime = [NSString stringWithFormat:@" %@", exhaleTime];
    }
    resultString = [resultString stringByReplacingCharactersInRange:NSMakeRange(6, 2) withString:exhaleTime];
    exhalePausa = [loop objectAtIndex:4];
    resultString = [resultString stringByReplacingCharactersInRange:NSMakeRange(9, 1) withString:exhalePausa];
    _rightNumber.text = resultString;
    
    self.labelsValues = [NSArray arrayWithObjects:_leftNumber.text, inhaleTime, inhalePausa, exhaleTime, exhalePausa, nil];
}

- (void)viewDidUnLoad
{
    self.leftNumber = nil;
    self.rightNumber = nil;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
