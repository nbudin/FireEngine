/*
 *  frap_message.h
 *  libfrap
 *
 *  Created by Nat Budin on 3/9/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

typedef enum {
	UNKNOWN,
	TRIGGER,
	LATENCY_TEST,
	IDENTITY,
	IDENTITY_REQUEST,
	STATUS_UPDATE,
	STATUS_REQUEST
} frap_message_type;

typedef struct {
	char *sender;
	frap_message_type msgType;
	char *data;
} frap_message;

frap_message *decode_frap_message(char *msg_text);
void free_frap_message(frap_message *msg);