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

@class AppDelegate;

@interface NotesModalController : UIViewController <UITextViewDelegate> {

    AppDelegate     *appDelegate;
}

@property (nonatomic, strong) IBOutlet UITextView *notesTextView;
@property (nonatomic, assign) id <HideNotesViewProtocol> delegate;
@property (strong, nonatomic) NSMutableString *notesText;

-(IBAction)finishEditing;

@end
