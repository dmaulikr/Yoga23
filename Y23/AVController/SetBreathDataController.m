//
//  SetBreathDataController.m
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//

#import "SetBreathDataController.h"
#import "PIAsanaView.h"
#import "AppDelegate.h"

#define kInspiratoryDurationComponent  0
#define kInspiratoryPausaComponent  1
#define kExpirationDurationComponent  2
#define kExpirationPausaComponent  3



@interface SetBreathDataController ()

@end

@implementation SetBreathDataController

@synthesize leftPicker = _leftPicker, rightPicker = _rightPicker, delegate = _delegate;
@synthesize theAsana = _theView;
@synthesize done = _done, deleteAsanaFromSequence =  _deleteAsanaFromSequence;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidUnload {
    
    self.leftPicker = nil;
    self.rightPicker = nil;

    self.done = nil;
    self.deleteAsanaFromSequence = nil;    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_done setTitle:NSLocalizedString(@"Done", @"") forState:UIControlStateNormal];
    breathingLabel.text = NSLocalizedString(@"Breathing:", @"");
    loopsLabel.text = NSLocalizedString(@"Loops", @"");
    inhaleLabel.text = NSLocalizedString(@"Inhale", @"");
    pausa1.text = NSLocalizedString(@"Pause", @"");
    exhaleLabel.text = NSLocalizedString(@"Exhale", @"");
    pausa2.text = NSLocalizedString(@"Pause", @"");



    
    CGSize popSize = CGSizeMake(400, 400); // size of view in popover
    self.contentSizeForViewInPopover = popSize;
    self.title = NSLocalizedString(@"Asana managing", @"");
    
    // set up UIPickers
    self.leftPicker.delegate = self;
    self.leftPicker.showsSelectionIndicator = YES;

    
    self.rightPicker.delegate = self;
    self.rightPicker.showsSelectionIndicator = YES;
    
    if (!lPickerValues) {
        lPickerValues = [[NSMutableArray alloc] initWithCapacity:35];
    }
    if (!rPicker0Values) {
        rPicker0Values = [[NSMutableArray alloc] initWithCapacity:35];
    }
    if (!rPicker1Values) {
        rPicker1Values = [[NSMutableArray alloc] initWithCapacity:10];
    }
    if (!rPicker2Values) {
        rPicker2Values = [[NSMutableArray alloc] initWithCapacity:35];
    }
    if (!rPicker3Values) {
        rPicker3Values = [[NSMutableArray alloc] initWithCapacity:10];
    }

    for (int i = 1; i <=35; i++) {
        
        NSString *aNumber = [NSString stringWithFormat:@"%d", i];
        [lPickerValues addObject:aNumber];
        [rPicker0Values addObject:aNumber];
        [rPicker2Values addObject:aNumber];
    }
    
    for (int i = 0; i <=9; i++) {
        
        NSString *aNumber = [NSString stringWithFormat:@"%d", i];
        [rPicker1Values addObject:aNumber];
        [rPicker3Values addObject:aNumber];
    }
  
    [self.done addTarget:_delegate action:@selector(dismissPopover) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [appDelegate pageTrackingGA:@"Sorting Popover"];
}



#pragma mark - 
#pragma mark buttons methodes

- (IBAction)removungAsanaFromSequence {
    
}

- (IBAction)breathSettingsDone {
    
    
}



#pragma mark - 
#pragma mark UIPickerView delegate methodes

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *value;
    if (pickerView == self.leftPicker){
        value = [lPickerValues objectAtIndex:row];
    }else if(pickerView == self.rightPicker){
        switch (component) {
            case kInspiratoryDurationComponent:
                value = [rPicker0Values objectAtIndex:row];
                break;
            case kInspiratoryPausaComponent:
                value = [rPicker1Values objectAtIndex:row];
                break;
            case kExpirationDurationComponent:
                value = [rPicker2Values objectAtIndex:row];
                break;
            case kExpirationPausaComponent:
                value = [rPicker3Values objectAtIndex:row];
                break;
        }
    }
    return value;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    if(!result){result = [[NSMutableArray alloc] initWithArray:self.theAsana.labelsValues];}
    if (pickerView == self.leftPicker) {
        if(!loopsCount){loopsCount = [[NSString alloc] init];}
        NSInteger index= [self.leftPicker selectedRowInComponent:0];
        loopsCount = [lPickerValues objectAtIndex:index];
        [result replaceObjectAtIndex:0 withObject:loopsCount];
    }else {
        if(component == kInspiratoryDurationComponent) {
            if(!inhaleTime){inhaleTime = [[NSString alloc] init];}
            NSInteger index= [self.rightPicker selectedRowInComponent:kInspiratoryDurationComponent];
            inhaleTime = [rPicker0Values objectAtIndex:index];
            [result replaceObjectAtIndex:1 withObject:inhaleTime];
        }else if(component == kInspiratoryPausaComponent) {
            if(!inhalePausa){inhalePausa = [[NSString alloc] init];}
            NSInteger index= [self.rightPicker selectedRowInComponent:kInspiratoryPausaComponent];
            inhalePausa = [rPicker1Values objectAtIndex:index];
            [result replaceObjectAtIndex:2 withObject:inhalePausa];
        }else if(component == kExpirationDurationComponent) {
            if(!exhaleTime){exhaleTime = [[NSString alloc] init];}
            NSInteger index= [self.rightPicker selectedRowInComponent:kExpirationDurationComponent];
            exhaleTime = [rPicker2Values objectAtIndex:index];
            [result replaceObjectAtIndex:3 withObject:exhaleTime];
        }else if(component == kExpirationPausaComponent) {
            if(!exhalePausa){exhalePausa = [[NSString alloc] init];}
            NSInteger index= [self.rightPicker selectedRowInComponent:kExpirationPausaComponent];
            exhalePausa = [rPicker3Values objectAtIndex:index];
            [result replaceObjectAtIndex:4 withObject:exhalePausa];
        }
    }
    
  
    [self.theAsana setBrithingLoop:result];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSUInteger n = 1;
    if (pickerView == self.rightPicker) {
        n = 4; 
    }
    return n;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger rows = 0;
    if (pickerView == self.leftPicker){
        rows = [lPickerValues count];
    }else if(pickerView == self.rightPicker){
        switch (component) {
            case kInspiratoryDurationComponent:
                rows = [rPicker0Values count];
                break;
            case kInspiratoryPausaComponent:
                rows = [rPicker1Values count];
                break;
            case kExpirationDurationComponent:
                rows = [rPicker2Values count];
                break;
            case kExpirationPausaComponent:
                rows = [rPicker3Values count];
                break;
        }
    }
    return rows;
}

- (void)resetPickerView {
    
}


#pragma mark - View lifecycle

- (void) removeTheAsana {
    
    [appDelegate eventTrackingGA:@"Sorting Popover" andAction:@"Remove button pressed" andLabel:nil];
    
    [self.delegate performSelector:@selector(removeAsanaView:) withObject:self.theAsana];
}

-(void)viewWillAppear:(BOOL)animated
{
        CGSize currentSetSizeForPopover = self.contentSizeForViewInPopover;
        CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width - 1.0f, currentSetSizeForPopover.height - 1.0f);
        self.contentSizeForViewInPopover = fakeMomentarySize;
        self.contentSizeForViewInPopover = currentSetSizeForPopover;

	// self.contentSizeForViewInPopover = CGSizeMake(400,400);     // size popover to what you wish, this may change yet aggain?
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
