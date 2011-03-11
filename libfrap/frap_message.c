/*
 *  frap_message.c
 *  libfrap
 *
 *  Created by Nat Budin on 3/9/11.
 *  Copyright 2011. All rights reserved.
 *
 */

#include "frap_message.h"
#include <stdlib.h>
#include <string.h>

frap_message *decode_frap_message(char *msg_text) {
	frap_message *msg = malloc(sizeof(frap_message));
	msg->msgType = UNKNOWN;
	msg->sender = NULL;
	msg->data = NULL;
	
	int msg_part = 0;
	char *i = msg_text;
	char *part_start = msg_text;
	
	while (*i != '\0') {
		if (msg_part < 2) {
			if (*i == '|') {
				int msg_type_len = i - part_start;
								
				if (strncmp(part_start, "tr", msg_type_len) == 0) {
					msg->msgType = TRIGGER;
				} else if (strncmp(part_start, "lt", msg_type_len) == 0) {
					msg->msgType = LATENCY_TEST;
				} else if (strncmp(part_start, "id", msg_type_len) == 0) {
					msg->msgType = IDENTITY;
				} else if (strncmp(part_start, "idr", msg_type_len) == 0) {
					msg->msgType = IDENTITY_REQUEST;
				} else if (strncmp(part_start, "up", msg_type_len) == 0) {
					msg->msgType = STATUS_UPDATE;
				} else if (strncmp(part_start, "sr", msg_type_len) == 0) {
					msg->msgType = STATUS_REQUEST;
				}
				
				part_start = i + 1;
				msg_part = 2;
			} else if (msg_part == 0 && *i == ':') {
				int sender_len = i - part_start + 1;
				char *sender = malloc(sender_len * sizeof(char));
				
				strncpy(sender, part_start, i - part_start);
				sender[sender_len - 1] = '\0';
				part_start = i + 1;
				
				msg->sender = sender;
				msg_part = 1;
			}
		}
		i++;
	}
	
	int data_len = i - part_start + 1;
	char *data = malloc(data_len * sizeof(char));
	
	strcpy(data, part_start);
	msg->data = data;
	
	return msg;
}

void free_frap_message(frap_message *msg) {
	if (msg->data != NULL)
		free(msg->data);
	if (msg->sender != NULL)
		free(msg->sender);
	free(msg);
}