//
//  NotesModalController.h
//  Y23
//
//  Created by Igor_Che on 11/12/12.
//
//

@protocol HideNotesViewProtocol <NSObject>

- (void)notesDone;

@end

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NotesModalController : UIViewController <UITextViewDelegate> {

}

@property (nonatomic, strong) IBOutlet UITextView *notesTextView;
@property (nonatomic, assign) id <HideNotesViewProtocol> delegate;
@property (strong, nonatomic) NSMutableString *notesText;

-(IBAction)finishEditing;

@end
