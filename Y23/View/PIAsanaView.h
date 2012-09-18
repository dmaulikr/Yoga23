//
//  PIAsanaView.h
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//

#import <UIKit/UIKit.h>

@interface PIAsanaView : UIView {
    
    NSString *loopsCount;
    NSString *inhaleTime;
    NSString *inhalePausa;
    NSString *exhaleTime;
    NSString *exhalePausa;
}

@property (nonatomic, strong) IBOutlet UILabel *leftNumber;
@property (nonatomic, strong) IBOutlet UILabel *rightNumber;
@property (nonatomic, strong) NSArray *labelsValues;

- (void)setBrithingLoop:(NSArray*)setLoop;

@end