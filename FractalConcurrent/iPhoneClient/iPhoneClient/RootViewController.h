//
//  RootViewController.h
//  iPhoneClient
//
//  Created by Apple User on 3/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <NSNetServiceDelegate, NSNetServiceBrowserDelegate>
{
    NSNetServiceBrowser*	browser_;
	NSMutableArray*			services_;	
}


@end
