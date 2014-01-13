//
//  SetBreathDataController.h
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//



#import <UIKit/UIKit.h>
#import "PIAsanaView.h"

@protocol DismissPopoverProtocol <NSObject>

- (void)dismissPopover;
- (void)removeAsanaView:(PIAsanaView*)asana;

@end


@class AppDelegate;

@interface SetBreathDataController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    AppDelegate     *appDelegate;
    
    // values for pickers rows
    NSMutableArray  *lPickerValues;
    NSMutableArray  *rPicker0Values;
    NSMutableArray  *rPicker1Values;
    NSMutableArray  *rPicker2Values;
    NSMutableArray  *rPicker3Values;
    
    // var for result of pick
    NSString        *loopsCount;
    NSString        *inhaleTime;
    NSString        *inhalePausa;
    NSString        *exhaleTime;
    NSString        *exhalePausa;
    // 
    NSMutableArray *result;
    __weak IBOutlet UILabel *breathingLabel;
    __weak IBOutlet UILabel *loopsLabel;
    __weak IBOutlet UILabel *inhaleLabel;
    __weak IBOutlet UILabel *pausa1;
    __weak IBOutlet UILabel *exhaleLabel;
    __weak IBOutlet UILabel *pausa2;
}

@property (nonatomic, strong) IBOutlet UIPickerView         *leftPicker;
@property (nonatomic, strong) IBOutlet UIPickerView         *rightPicker;
@property (nonatomic, weak) id <DismissPopoverProtocol>     delegate; // sort view controller
@property (nonatomic, weak) PIAsanaView                     *theAsana; // the view in sequence
@property (nonatomic, strong) IBOutlet UIButton             *done;
@property (nonatomic, strong) IBOutlet UIButton             *deleteAsanaFromSequence;

- (IBAction)removungAsanaFromSequence;
- (IBAction)breathSettingsDone;
- (void)removeTheAsana;


@end
