//
//  FrapSpyViewController.h
//  libfrap
//
//  Created by Nat Budin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrapEndpoint.h"

@interface FrapSpyViewController : UIViewController {
	FrapEndpoint *endpoint;
	NSMutableString *logText;
	IBOutlet UITextView *frapLog;
}

@property (nonatomic, retain) IBOutlet UITextView *frapLog;

@end
