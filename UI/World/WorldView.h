#import <UIKit/UIKit.h>
#import "PCBaseViewController.h"

@protocol WorldViewDelegate;

typedef enum {
	displayStatHealth,
	displayStatShield,
	displayStatMana,
} displayStatType;


@interface WorldView : PCBaseViewController
{
	// updated by Engine
	IBOutlet UIImageView *mapImageView;
	IBOutlet UIImageView *miniMapImageView;

	IBOutlet UIView *healthBar;
	IBOutlet UIView *shieldBar;
	IBOutlet UIView	*manaBar;
	NSArray *displayBarArray;

	IBOutlet UILabel *healthLabel;
	IBOutlet UILabel *shieldLabel;
	IBOutlet UILabel *manaLabel;
	NSArray *displayLabelArray;

	IBOutlet UILabel *actionResult;
	
	IBOutlet UIView *loadingDungeonView;
	IBOutlet UIActivityIndicatorView *spinner;
	
	UIImageView *highlight;
}

- (void) setDelegate:(id<WorldViewDelegate>) delegate;

@property (nonatomic, retain) IBOutlet UIImageView *mapImageView;
@property (nonatomic, retain) IBOutlet UIImageView *miniMapImageView;
@property (nonatomic, retain) IBOutlet UIView *healthBar;
@property (nonatomic, retain) IBOutlet UIView *shieldBar;
@property (nonatomic, retain) IBOutlet UIView *manaBar;
@property (nonatomic, retain) IBOutlet UILabel *actionResult;
@property (nonatomic, retain) UIImageView *highlight;

- (void) setDisplay:(displayStatType) display withAmount:(float) amount ofMax:(float) max;

- (void) showDungeonLoading;
- (void) hideDungeonLoading;

@end

#pragma mark -
#pragma mark WorldViewDelegate

@protocol WorldViewDelegate <NSObject>

// all points are in pixels.
- (void) worldView:(WorldView*) worldView touchedAt:(CGPoint)point;
- (void) worldView:(WorldView*) worldView selectedAt:(CGPoint)point;
- (void) worldViewDidLoad:(WorldView*) worldView;

@end
