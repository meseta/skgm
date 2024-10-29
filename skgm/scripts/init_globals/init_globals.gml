function init_globals() {
	// The root logger
	#macro LOGGER global.logger
	LOGGER = new Logger();
	
	// Data managers
	#macro DATA global.data
	DATA = {
		password: new Password(),
		deployment_storage: new DeploymentStorage(),
		deployment_manager: new DeploymentManager(),
		settings: new Settings(),
	}

	// Sentry
	#macro SENTRY global.sentry
	SENTRY = new Sentry(DATA.settings.get("sentry_dsn"));
	SENTRY.set_app_version(GM_version);
	LOGGER.use_sentry(SENTRY);

	// The webserver
	#macro SERVER global.server
}