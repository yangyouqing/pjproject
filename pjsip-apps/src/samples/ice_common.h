/**
 * Copyright (c) 2020 Paul-Louis Ageneau
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#ifndef JUICE_ICE_COMMON_H
#define JUICE_ICE_COMMON_H

#ifdef __cplusplus
extern "C" {
#endif

#if 0
#define TURN_SERVER_HOST "stun.ageneau.net"
#define TURN_USERNAME "juice_test"
#define TURN_PASSWORD "28245150316902"
#else 
#define TURN_SERVER_HOST "43.128.22.4"
#define TURN_USERNAME "yyq"
#define TURN_PASSWORD "yyq"
#endif

#define MQTT_SERVER_HOST "43.128.22.4"
#define MQTT_SERVER_PORT "1883"


#define JUICE_MQTT_MSG_MAX_SIZE   2048

#define JUICE_MQTT_MSG_TYPE_CONNECT_REQ  1
#define JUICE_MQTT_MSG_TYPE_CONNECT_RESP 2
#define JUICE_MQTT_MSG_TYPE_CANDIDATE_GATHER_DONE 3
#define JUICE_MQTT_MSG_TYPE_SDP 4
#define JUICE_MQTT_MSG_TYPE_CANDIDATE 5

#define JUICE_MQTT_TOPIC_ICE_PEER "ice-peer/did-pjnath234233432"
#define JUICE_MQTT_TOPIC_ICE_CLIENT "ice-client/pjnath12321"


int open_nb_socket(const char* addr, const char* port);

int make_publish_msg(char* buf, int max_buf_size, int msg_type, const char* msg);

#ifdef __cplusplus
}
#endif

#endif
