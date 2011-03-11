//
//  FrapEndpoint.h
//  libfrap
//
//  Created by Nat Budin on 3/9/11.
//  Copyright 2011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
#import "FrapMessages.h"

@interface FrapEndpoint : NSObject {
	AsyncUdpSocket *listenSocket;
	AsyncUdpSocket *sendSocket;
	NSThread *socketThread;
	NSString *endpointId;
	NSLock *sendLock;
	id delegate;
}

-(FrapEndpoint *)initWithEndpointId:(NSString *)endpointId delegate:(id)theDelegate;
-(BOOL)bindSockets:(NSError **)error;
-(NSString *)endpointId;
-(void)sendFrapMessage:(FrapMessage *)msg;

-(void)didReceiveFrapMessage:(FrapMessage *)msg;

-(BOOL)onUdpSocket:(AsyncUdpSocket *)socket 
	didReceiveData:(NSMutableData *)data
		   withTag:(long)tag
		  fromHost:(NSString *)host
			  port:(UInt16)port;

-(void)sendDataLocked:(NSData *)data;

@end
