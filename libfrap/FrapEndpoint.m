//
//  FrapEndpoint.m
//  libfrap
//
//  Created by Nat Budin on 3/9/11.
//  Copyright 2011. All rights reserved.
//

#import "FrapEndpoint.h"
#import "FrapMessages.h"
#include <stdio.h>

@implementation FrapEndpoint
-(FrapEndpoint *)initWithEndpointId:(NSString *)theEndpointId delegate:(id)theDelegate {
	listenSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
	sendSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
	sendLock = [[NSLock alloc] init];
	socketThread = [NSThread currentThread];
	
	endpointId = theEndpointId;
	delegate = theDelegate;
	return self;
}

-(NSString *)endpointId {
	return endpointId;
}
	
-(BOOL)bindSockets:(NSError **)error {
	if (![listenSocket bindToPort:23952 error:error])
		return FALSE;
	
	if (![listenSocket joinMulticastGroup:@"224.23.95.2" error:error])
		return FALSE;
	
	if (![listenSocket enableBroadcast:TRUE error:error])
		return FALSE;
	
	if (![sendSocket connectToHost:@"224.23.95.2" onPort:23952 error:error])
		return FALSE;
	
	if (![sendSocket enableBroadcast:TRUE error:error])
		return FALSE;

	[listenSocket receiveWithTimeout:-1 tag:1];
	
	return TRUE;
}

-(BOOL)onUdpSocket:(AsyncUdpSocket *)socket 
	didReceiveData:(NSMutableData *)data 
		   withTag:(long)tag
		  fromHost:(NSString *)host 
			  port:(UInt16)port {
	
	NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	FrapMessage *msg = [FrapMessage decodeFrapMessage:dataStr];
	[dataStr release];
	
	[self didReceiveFrapMessage:msg];
	
	[socket receiveWithTimeout:-1 tag:1];
	
	return NO;
}

-(void)sendFrapMessage:(FrapMessage *)msg {
	NSData *data = [msg encode];
	
	[sendLock lock];	
	[self performSelector:@selector(sendDataLocked:) onThread:socketThread
			   withObject:data waitUntilDone:YES];
	[sendLock unlock];
	
	if ([delegate respondsToSelector:@selector(didSendFrapMessage:)]) {
		[delegate didSendFrapMessage:msg];
	}
}

-(void)sendDataLocked:(NSData *)data {
	[sendSocket sendData:data withTimeout:5 tag:2];
}

-(void)didReceiveFrapMessage:(FrapMessage *)msg {
	if ([msg isKindOfClass:[FrapIdentityRequestMessage class]]) {
		id reply = [[FrapIdentityMessage alloc] initWithSender:endpointId];
		[self sendFrapMessage:reply];
	}
	
	if ([delegate respondsToSelector:@selector(didReceiveFrapMessage:)]) {
		[delegate didReceiveFrapMessage:msg];
	}
}
	
-(void) dealloc {
	[listenSocket release];
	[sendSocket release];
	[endpointId release];
	[sendLock release];
	[super dealloc];
}
@end
