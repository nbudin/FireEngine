    //
//  FrapSpyViewController.m
//  libfrap
//
//  Created by Nat Budin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FrapSpyViewController.h"


@implementation FrapSpyViewController

@synthesize frapLog;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSError *error = nil;
	
    [super viewDidLoad];
	
	logText = [[NSMutableString alloc] init];
	[logText setString:@""];
	[frapLog setText:logText];
	[frapLog setNeedsDisplay];
	
	endpoint = [[FrapEndpoint alloc] initWithEndpointId:@"FRAPSpy" delegate:self];
	if (![endpoint bindSockets:&error]) {
		UIAlertView *alert;
		alert = [[UIAlertView alloc] initWithTitle:@"Error starting FRAP" 
										   message:[error localizedDescription]
										  delegate:nil 
								 cancelButtonTitle:@"So sorry..." 
								 otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(void)didReceiveFrapMessage:(FrapMessage *)msg {
	[logText appendString:@"Received: "];
	[logText appendString:[msg description]];
	[logText appendString:@"\n"];
	
	[frapLog setText:logText];
	[frapLog setNeedsDisplay];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[logText dealloc];
    [super dealloc];
}


@end
