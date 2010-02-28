//
//  NewGameFlowControl.h
//  Phone-Crawl
//
//  Created by Austin Kelley on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCBaseViewController.h"

@interface NewGameFlowControl : PCBaseViewController <UITextFieldDelegate>
{
	int state;
	IBOutlet UILabel *mainTextLabel;
	
	IBOutlet UITextField *nameSelect;
	IBOutlet UIButton *okayButton;
	
	IBOutlet UIView *dialogueView;
	
	IBOutlet UIButton *topLeft;
	IBOutlet UIButton *topRight;
	IBOutlet UIButton *bottomLeft;
	IBOutlet UIButton *bottomRight;

	
	NSString *nameField;
	NSString *iconField;
}

- (void) begin;

- (IBAction) nextState;

- (IBAction) topLeftButton;
- (IBAction) topRightButton;
- (IBAction) bottomLeftButton;
- (IBAction) bottomRightButton;

@end

@protocol NewGameFlowDelegate

- (void) newCharacterWithName:(NSString*)name andIcon:(NSString*)icon;

@end


