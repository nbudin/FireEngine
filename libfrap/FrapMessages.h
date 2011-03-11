//
//  FrapMessage.h
//  libfrap
//
//  Created by Nat Budin on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrapMessage : NSObject {
	NSString *sender;
}

+(id)decodeFrapMessage:(NSString *)msgText;
-(FrapMessage *)initWithSender:(NSString *) theSender;
-(NSString *)sender;
-(NSData *)encode;
-(NSData *)encodeFromData:(NSString *)data withMsgTypeCode:(NSString *)typeCode;
-(NSString *)descriptionWithText:(NSString *)text;
@end

@interface FrapTriggerMessage : FrapMessage {
	NSString *eventId;
	NSMutableDictionary *args;
}

-(id)initWithSender:(NSString *)theSender data:(NSString *)data;
-(NSString *)eventId;
-(NSMutableDictionary *)args;
-(NSData *)encode;
-(NSString *)description;
@end

@interface FrapLatencyTestMessage : FrapMessage {
	NSDate *started;
}
-(id)initWithSender:(NSString *)theSender;
-(NSDate *)started;
-(NSData *)encode;
-(NSString *)description;
@end

@interface FrapIdentityMessage : FrapMessage {
}
-(id)initWithSender:(NSString *)theSender;
-(NSData *)encode;
-(NSString *)description;
@end

@interface FrapIdentityRequestMessage : FrapMessage {
}
-(id)initWithSender:(NSString *)theSender;
-(NSData *)encode;
-(NSString *)description;
@end

@interface FrapStatusRequestMessage : FrapMessage {
	NSArray *objectIds;
}
-(id)initWithSender:(NSString *)theSender data:(NSString *)data;
-(NSArray *)objectIds;
-(NSData *)encode;
-(NSString *)description;
@end

@interface FrapStatusUpdateMessage : FrapMessage {
	NSMutableDictionary *objects;
}
-(id)initWithSender:(NSString *)theSender data:(NSString *)data;
-(NSMutableDictionary *)objects;
-(NSData *)encode;
-(NSString *)description;
@end