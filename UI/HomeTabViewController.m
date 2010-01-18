//
//  HomeTabViewController.m
//  Phone-Crawl
//
//  Created by Austin Kelley on 1/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomeTabViewController.h"

//Individual View Classes
#import "CharacterView.h"
#import "InventoryView.h"
#import "OptionsView.h"
#import "WorldView.h"

#define NUMBER_OF_TABS 4

@interface HomeTabViewController (Private)

- (UIViewController*) newWorldViewController;
- (UIViewController*) newCharacterViewController;
- (UIViewController*) newInventoryViewController;
- (UIViewController*) newOptionsViewController;

@end


@implementation HomeTabViewController

@synthesize mainTabController;


#pragma mark -
#pragma mark Life Cycle

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}*/

-(void) loadView
{
	mainTabController = [[UITabBarController alloc] init];
	
	NSMutableArray *tabs = [[[NSMutableArray alloc] initWithCapacity:NUMBER_OF_TABS] autorelease];
	[tabs addObject:[self newWorldViewController]];
	[tabs addObject:[self newCharacterViewController]];
	[tabs addObject:[self newInventoryViewController]];
	[tabs addObject:[self newOptionsViewController]];
	
	[mainTabController setViewControllers:tabs];
	
	self.view = mainTabController.view;
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark New Tab View Controllers

- (UIViewController*) newWorldViewController
{
	WorldView *wView = [[[WorldView alloc] init] autorelease];
	//wView.tabBarItem.image = 
	wView.title = @"World";
	return wView;
}

- (UIViewController*) newCharacterViewController
{
	CharacterView *cView = [[[CharacterView alloc] init] autorelease];
	//
	cView.title = @"Character";
	return cView;
}

- (UIViewController*) newInventoryViewController
{
	InventoryView *iView = [[[InventoryView alloc] init] autorelease];
	//
	iView.title = @"Inventory";
	return iView;
}

- (UIViewController*) newOptionsViewController
{
	OptionsView *oView = [[[OptionsView alloc] init] autorelease];
	UINavigationController *navCont = [[[UINavigationController alloc] initWithRootViewController:oView] autorelease];
	//
	navCont.title = @"Options";
	return navCont;
}


#pragma mark -
#pragma mark UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	
}



@end