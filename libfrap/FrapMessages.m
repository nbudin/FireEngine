//
//  FrapMessage.m
//  libfrap
//
//  Created by Nat Budin on 3/9/11.
//  Copyright 2011. All rights reserved.
//

#import "FrapMessages.h"
#import "JSON.h"

@implementation FrapMessage
+(id)decodeFrapMessage:(NSString *)msgText {
	NSString *theSender = nil;
	NSString *msgType = nil;
	NSString *data = nil;
	
	NSUInteger msgPart = 0;
	NSUInteger partStart = 0;
	NSUInteger msgLength = [msgText length];
	NSUInteger i = 0;
	
	while (i < msgLength) {
		if (msgPart < 2) {
			unichar c = [msgText characterAtIndex:i];
			if (c == '|') {
				NSRange partRange = NSMakeRange(partStart, i - partStart);
				msgType = [msgText substringWithRange:partRange];
				
				partStart = i + 1;
				msgPart = 2;
			} else if (msgPart == 0 && c == ':') {
				NSRange senderRange = NSMakeRange(partStart, i - partStart);
				theSender = [msgText substringWithRange:senderRange];

				partStart = i + 1;
				msgPart = 1;
			}
		}
		i++;
	}
	
	data = [msgText substringFromIndex:partStart];
	
	id msg = nil;
	if ([msgType compare:@"tr"] == 0) {
		msg = [[FrapTriggerMessage alloc] initWithSender:theSender data:data];
	} else if ([msgType compare:@"lt"] == 0) {
		msg = [[FrapLatencyTestMessage alloc] initWithSender:theSender];
	} else if ([msgType compare:@"id"] == 0) {
		msg = [[FrapIdentityMessage alloc] initWithSender:theSender];
	} else if ([msgType compare:@"idr"] == 0) {
		msg = [[FrapIdentityRequestMessage alloc] initWithSender:theSender];
	} else if ([msgType compare:@"up"] == 0) {
		msg = [[FrapStatusUpdateMessage alloc] initWithSender:theSender data:data];
	} else if ([msgType compare:@"sr"] == 0) {
		msg = [[FrapStatusRequestMessage alloc] initWithSender:theSender data:data];
	}
	
	[msg autorelease];
	return msg;
}

-(FrapMessage *)initWithSender:(NSString *)theSender {
	sender = theSender;
	[sender retain];
	
	return self;
}

-(NSData *)encode {
	return nil;
}

-(NSString *)sender {
	return sender;
}

-(NSData *)encodeFromData:(NSString *)data withMsgTypeCode:(NSString *)typeCode {
	NSUInteger fullMsgLength = [typeCode length] + 1 + [data length];
	if (sender != nil) {
		fullMsgLength += [sender length] + 1;
	}

	NSMutableString *fullMsg = [NSMutableString stringWithCapacity:fullMsgLength];
	
	if (sender != nil) {
		[fullMsg setString:sender];
		[fullMsg appendString:@":"];
	} else {
		[fullMsg setString:@""];
	}
	
	[fullMsg appendString:typeCode];
	[fullMsg appendString:@"|"];
	[fullMsg appendString:data];
	
	NSData *encoded = [fullMsg dataUsingEncoding:NSASCIIStringEncoding];
	return encoded;
}

-(NSString *)descriptionWithText:(NSString *)text {
	NSUInteger descriptionLength = [text length];
	if (sender != nil)
		descriptionLength += 6 + [sender length];
	
	NSMutableString *desc = [[NSMutableString alloc] initWithCapacity:descriptionLength];
	[desc setString:text];
	
	if (sender != nil) {
		[desc appendString:@" from "];
		[desc appendString:sender];
	}
	
	[desc autorelease];
	return desc;
}

-(void) dealloc {
	[sender release];
	
	[super dealloc];
}
@end

@implementation FrapTriggerMessage
-(FrapTriggerMessage *)initWithSender:(NSString *)theSender data:(NSString *)data {
	[super initWithSender:theSender];

	NSRange separatorRange = [data rangeOfString:@"|"];
	
	eventId = [data substringToIndex:separatorRange.location];
	NSUInteger argsStart = separatorRange.location + separatorRange.length;
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	args = [parser objectWithString:[data substringFromIndex:argsStart]];
	
	[parser release];
	
	return self;
}

-(NSMutableDictionary *)args {
	return args;
}

-(NSString *)eventId {
	return eventId;
}

-(NSData *)encode {
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	NSString *argsString = [writer stringWithObject:args];
	[writer release];
	
	NSUInteger dataLength = [eventId length] + 1 + [argsString length];
	NSMutableString *data = [NSMutableString stringWithCapacity:dataLength];
	[data setString:eventId];
	[data appendString:@"|"];
	[data appendString:argsString];
	
	return [super encodeFromData:data withMsgTypeCode:@"tr"];
}

-(NSString *)description {
	NSUInteger textLen = 14 + [eventId length];
	NSMutableString *text = [[NSMutableString alloc] initWithCapacity:textLen];
	[text setString:@"Trigger event "];
	[text appendString:eventId];
	
	[text autorelease];
	return [super descriptionWithText:text];
}

-(void)dealloc {
	[args release];
	[eventId release];
	
	[super dealloc];
}
@end

@implementation FrapLatencyTestMessage
-(id)initWithSender:(NSString *)theSender {
	[super initWithSender:theSender];
	started = [NSDate date];
	return self;
}

-(NSDate *)started {
	return started;
}

-(NSData *)encode {
	return [super encodeFromData:@"" withMsgTypeCode:@"lt"];
}

-(NSString *)description {
	return [super descriptionWithText:@"Latency test"];
}

-(void)dealloc {
	[started release];
	[super dealloc];
}
@end

@implementation FrapIdentityMessage
-(id)initWithSender:(NSString *)theSender {
	return [super initWithSender:theSender];
}

-(NSData *)encode {
	return [super encodeFromData:@"" withMsgTypeCode:@"id"];
}

-(NSString *)description {
	return [super descriptionWithText:@"Identity"];
}
@end

@implementation FrapIdentityRequestMessage
-(id)initWithSender:(NSString *)theSender {
	return [super initWithSender:theSender];
}

-(NSData *)encode {
	return [super encodeFromData:@"" withMsgTypeCode:@"idr"];
}

-(NSString *)description {
	return [super descriptionWithText:@"Identity request"];
}
@end


@implementation FrapStatusUpdateMessage
-(id)initWithSender:(NSString *)theSender data:(NSString *)data {
	[super initWithSender:theSender];
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	objects = [parser objectWithString:data];
	
	[parser release];
	[data release];
	
	return self;
}

-(NSMutableDictionary *)objects {
	return objects;
}

-(NSData *)encode {
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	NSString *data = [writer stringWithObject:objects];
	[writer release];
	
	return [super encodeFromData:data withMsgTypeCode:@"up"];
}

-(NSString *)description {
	return [super descriptionWithText:@"Status update"];
}

-(void)dealloc {
	[objects release];
	[super dealloc];
}
@end

@implementation FrapStatusRequestMessage
-(id)initWithSender:(NSString *)theSender data:(NSString *)data {
	[super initWithSender:theSender];
	objectIds = [data componentsSeparatedByString:@"|"];
	return self;
}

-(NSArray *)objectIds {
	return objectIds;
}

-(NSData *)encode {
	NSString *data = [objectIds componentsJoinedByString:@"|"];
	return [super encodeFromData:data withMsgTypeCode:@"sr"];
}

-(NSString *)description {
	return [super descriptionWithText:@"Status request"];
}

-(void)dealloc {
	[objectIds release];
	[super dealloc];
}
@end