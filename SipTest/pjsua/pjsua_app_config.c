//
//  pjsua_app_config.c
//  SipTest
//
//  Created by Zhe Cui on 1/8/18.
//  Copyright © 2018 Zhe Cui. All rights reserved.
//

#include "pjsua_app_common.h"
//#include "pjsua_app_config.h"

//void default_config(void);

///* Set default config. */
//void default_config()
//{
//    char tmp[80];
//    unsigned i;
//    pjsua_app_config *cfg = &app_config;
//
//    pjsua_config_default(&cfg->cfg);
//    pj_ansi_sprintf(tmp, "PJSUA v%s %s", pj_get_version(),
//                    pj_get_sys_info()->info.ptr);
//    pj_strdup2_with_null(app_config.pool, &cfg->cfg.user_agent, tmp);
//
//    pjsua_logging_config_default(&cfg->log_cfg);
//    pjsua_media_config_default(&cfg->media_cfg);
//    pjsua_transport_config_default(&cfg->udp_cfg);
//    cfg->udp_cfg.port = 5060;
//    pjsua_transport_config_default(&cfg->rtp_cfg);
//    cfg->rtp_cfg.port = 4000;
//    cfg->redir_op = PJSIP_REDIRECT_ACCEPT_REPLACE;
//    cfg->duration = PJSUA_APP_NO_LIMIT_DURATION;
//    cfg->wav_id = PJSUA_INVALID_ID;
//    cfg->rec_id = PJSUA_INVALID_ID;
//    cfg->wav_port = PJSUA_INVALID_ID;
//    cfg->rec_port = PJSUA_INVALID_ID;
//    cfg->mic_level = cfg->speaker_level = 1.0;
//    cfg->capture_dev = PJSUA_INVALID_ID;
//    cfg->playback_dev = PJSUA_INVALID_ID;
//    cfg->capture_lat = PJMEDIA_SND_DEFAULT_REC_LATENCY;
//    cfg->playback_lat = PJMEDIA_SND_DEFAULT_PLAY_LATENCY;
//    cfg->ringback_slot = PJSUA_INVALID_ID;
//    cfg->ring_slot = PJSUA_INVALID_ID;
//
//    for (i=0; i<PJ_ARRAY_SIZE(cfg->acc_cfg); ++i) {
//        pjsua_acc_config_default(&cfg->acc_cfg[i]);
//        // Pete, added for test, do not retry registration.
//        cfg->acc_cfg[i].reg_retry_interval = 0;
//    }
//
////    for (i=0; i<PJ_ARRAY_SIZE(cfg->buddy_cfg); ++i)
////        pjsua_buddy_config_default(&cfg->buddy_cfg[i]);
//
//    cfg->vid.vcapture_dev = PJMEDIA_VID_DEFAULT_CAPTURE_DEV;
//    cfg->vid.vrender_dev = PJMEDIA_VID_DEFAULT_RENDER_DEV;
//    cfg->aud_cnt = 1;
//
//    cfg->avi_def_idx = PJSUA_INVALID_ID;
//
////    cfg->use_cli = PJ_FALSE;
////    cfg->cli_cfg.cli_fe = CLI_FE_CONSOLE;
////    cfg->cli_cfg.telnet_cfg.port = 0;
//
//    // Pete, added for test
//    cfg->use_tls = PJ_TRUE;
//    cfg->cfg.outbound_proxy_cnt = 1;
//    cfg->cfg.outbound_proxy[0] = pj_str("sips:siptest.butterflymx.com:5061");
//    cfg->udp_cfg.port = 5061;
//}

