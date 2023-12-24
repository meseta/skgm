function init_globals() {
	// The root logger
	#macro LOGGER global.logger
	LOGGER = new Logger();
	
	// Sentry
	#macro SENTRY global.sentry
	SENTRY = new Sentry();
	LOGGER.use_sentry(SENTRY);

	// The webserver
	#macro SERVER global.server
}