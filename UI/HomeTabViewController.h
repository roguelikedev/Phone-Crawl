//
//  HomeTabViewController.h
//  Phone-Crawl
//
//  Created by Austin Kelley on 1/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeTabViewController : UIViewController
{
	UITabBarController *mainTabController;
}

@property (nonatomic, retain) UITabBarController *mainTabController;

@end
