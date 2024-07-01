init_globals();

// Are we running in the IDE?
if (parameter_count() == 3 && parameter_string(1) == "-game") {
	// For local development in IDEA, just start and pop open webserver
	
	// Wait a frame to make sure we're in a room
	call_later(1, time_source_units_frames, function() {
		// Load up all the pages
		init_site();
		SERVER.start();
		
		url_open($"http://localhost:{SERVER.port}/");
	});
}
else {
	// When deployed...
	
	// slow everything down
	game_set_speed(10, gamespeed_fps);

	// turn off drawing
	draw_enable_drawevent(false);
	
	// don't ask to send sentry errors
	SENTRY.set_option("ask_to_send", false);
	SENTRY.set_option("ask_to_send_report", false);
	SENTRY.set_option("show_popup", false);
	
	// Use Sentry's error handler
	exception_unhandled_handler(global.sentry.get_exception_handler());
	
	// Wait 2 second to ensure previous process was closed,
	// and to make sure we're going to be inside the room when this happens
	call_later(2, time_source_units_seconds, function() {
		// Load up all the pages
		init_site();
		
		// Allow CDN to cache
		SERVER.set_default_cache_control("public, max-age=1800");
		SERVER.start();
		
		// send backup reports
		SENTRY.send_all_backed_up_reports();
		
		// start any old deployments
		if (DATA.settings.get("auto_start")) {
			var _deployment_id = DATA.settings.get("last_deployment");
			if (_deployment_id != "") {
				LOGGER.info("Auto starting deployment", {deployment_id: _deployment_id});
				 var _path = DATA.deployment_storage.get_path(_deployment_id);
				DATA.deployment_manager.deploy(_deployment_id, _path);
			}
		}
	});

}
