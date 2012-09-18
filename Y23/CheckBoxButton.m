//
//  CheckBoxButton.m
//  Y23
//
//  Created by Igor Cherny on 11/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckBoxButton.h"

@implementation CheckBoxButton

@dynamic checked;


  // getter for checked

-(BOOL) checked {
	return checked;
}

 // setter for checked

-(void) setChecked:(BOOL) a{
    
	checked = a;
	
	// set image
	if(checked){
		[self setImage:[UIImage imageNamed:@"WhiteCBoxV.png"] 
              forState:UIControlStateNormal];
	}else{
        [self setImage:[UIImage imageNamed:@"WhiteCBox.png"] 
              forState:UIControlStateNormal];	
	}	
}



-(void) onClicked {
	self.checked = !checked;	
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
