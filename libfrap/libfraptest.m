/*
 *  libfraptest.c
 *  libfrap
 *
 *  Created by Nat Budin on 3/9/11.
 *  Copyright 2011. All rights reserved.
 *
 */

#import "FrapEndpoint.h"
#include <stdio.h>

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSError *error = nil;
	int returnCode = 0;
	
	FrapEndpoint *endpoint = [[FrapEndpoint alloc] initWithEndpointId:@"libfraptest"];
	if ([endpoint startListening:&error]) {
		CFRunLoopRun();
	} else {
		printf("Error starting listener: %s\n", [[error localizedDescription] UTF8String]);
		returnCode = [error code];
	}
	
	[endpoint release];
	[pool drain];
	
	return returnCode;
}