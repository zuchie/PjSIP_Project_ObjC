//
//  pjsua_app.h
//  SipTest
//
//  Created by Zhe Cui on 1/8/18.
//  Copyright © 2018 Zhe Cui. All rights reserved.
//

#ifndef pjsua_app_h
#define pjsua_app_h

#include <stdio.h>
#include "pjsua_app_common.h"
//#include "pjsua_app_config.h"
#import <pjsua-lib/pjsua.h>

/**
 * Interface for user application to use pjsua with CLI/menu based UI.
 */

//#include "pjsua_app_common.h"

//PJ_BEGIN_DECL

/**
 * This structure contains the configuration of application.
 */
typedef struct pjsua_app_cfg_t
{
    /**
     * The number of runtime arguments passed to the application.
     */
    int       argc;
    
    /**
     * The array of arguments string passed to the application.
     */
    char    **argv;
    
    /**
     * Tell app that CLI (and pjsua) is (re)started.
     * msg will contain start error message such as ìTelnet to X:Yî,
     * ìfailed to start pjsua libî, ìport busyî..
     */
    void (*on_started)(pj_status_t status, const char* title);
    
    /**
     * Tell app that library request to stopped/restart.
     * GUI app needs to use a timer mechanism to wait before invoking the
     * cleanup procedure.
     */
    void (*on_stopped)(pj_bool_t restart, int argc, char** argv);
    
    /**
     * This will enable application to supply customize configuration other than
     * the basic configuration provided by pjsua.
     */
    void (*on_config_init)(pjsua_app_config *cfg);
} pjsua_app_cfg_t;

/**
 * This will initiate the pjsua and the user interface (CLI/menu UI) based on
 * the provided configuration.
 */
pj_status_t pjsua_app_init(const pjsua_app_cfg_t *app_cfg);

/**
 * This will run the CLI/menu based UI.
 * wait_telnet_cli is used for CLI based UI. It will tell the library to block
 * or wait until user invoke the "shutdown"/"restart" command. GUI based app
 * should define this param as PJ_FALSE.
 */
pj_status_t pjsua_app_run(pj_bool_t wait_telnet_cli);

/**
 * This will destroy/cleanup the application library.
 */
//pj_status_t pjsua_app_destroy();

//PJ_END_DECL

#endif /* pjsua_app_h */
