/* $Id$ */
/* 
 * Copyright (C) 2008-2011 Teluu Inc. (http://www.teluu.com)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>

#include "bp2p_ice_api.h"

/*
 * And here's the main()
 */
static struct ev_timer send_timer;

static void on_recv_pkt(void * pkt, int size, struct sockaddr* src, struct sockaddr* dest) 
{
    unsigned short dst_port = -1;
    char *dst_addr = NULL;
    unsigned short src_port = -1;
    char *src_addr = NULL;    
    struct sockaddr_in *sin = (struct sockaddr_in *)dest;
    dst_port = ntohs(sin->sin_port); 
    dst_addr = inet_ntoa(sin->sin_addr);
    
    struct sockaddr_in *sin_src = (struct sockaddr_in *)src;
    src_port = ntohs(sin_src->sin_port);
    src_addr = inet_ntoa(sin_src->sin_addr);

    printf ("%s, recv %d bytes from[%s:%d --> %s:%d]\n", __FILE__, size, src_addr, src_port, dst_addr, dst_port);
}

static void do_send(struct ev_loop *loop, struct ev_timer *w, int revents)
{
    char *msg = "[from client]......\n";
    bp2p_ice_send(msg, strlen(msg) + 1);
}

int main(int argc, char *argv[])
{
    ice_cfg_t ice_cfg = {0};
    ice_cfg.loop = EV_DEFAULT;
    ice_cfg.role = ICE_ROLE_CLIENT;
    sprintf (ice_cfg.my_channel, "%d", time(NULL));
    strcpy (ice_cfg.peer_channel, "peer-topic");
    ice_cfg.signalling_srv = "43.128.22.4";
    ice_cfg.stun_srv = "43.128.22.4";
    ice_cfg.turn_srv = "43.128.22.4";
    ice_cfg.turn_username = "yyq";
    ice_cfg.turn_password = "yyq";
    ice_cfg.turn_fingerprint = 1;
    ice_cfg.cb_on_rx_pkt = on_recv_pkt;

    bp2p_ice_init (&ice_cfg);

    ev_timer_init(&send_timer, do_send, 0.1, 0.0);
    ev_timer_set(&send_timer, 1, 1.0);
    ev_timer_start(ice_cfg.loop, &send_timer);

    

    ev_run(ice_cfg.loop, 0);
    
//    bp2p_ice_start(&ice_cfg);
//    while (1) {
//        bp2p_ice_send("[from client] ....\n", 0);
//        sleep (1);
//    }
    return 0;
}
