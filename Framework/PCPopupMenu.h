//  Customizable pop up menu class.
//  Takes objects and functions to call and lists them by the given name.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define POPUP_MENU_WIDTH	60
#define POPUP_MENU_HEIGHT	60

@interface PCPopupMenu : UIView
{
	NSMutableArray *menuItems;
	UIImageView *backGroundImageView;
	NSMutableArray *drawnItems;

	BOOL hideOnFire;
	BOOL dieOnFire;
}

@property (nonatomic, getter = shouldHideOnFire) BOOL hideOnFire;
@property (nonatomic, getter = shouldDieOnFire) BOOL dieOnFire;
@property (readonly) CGPoint origin;

// Custom initializer. Always use this. The frame should be given with respect to the view this
// menu will be displayed in. The height is determined by the number of menu items.
- (id) initWithOrigin:(CGPoint)origin;

// Add an item to this menu.
- (void) addMenuItem:(NSString*)name delegate:(id) delegate selector:(SEL) selector context:(id)context;
- (void) removeMenuItemNamed:(NSString*)name;
- (void) removeItemWithContext:(id) con;

// Called once, when ready to display. This renders the menu. 
- (void) showInView:(UIView*)view;

// Helpers for turning display on and off.
- (void) show;
- (void) hide;

- (void) removeAllMenuItems;

@end
