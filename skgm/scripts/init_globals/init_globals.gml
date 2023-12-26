function init_globals() {
	// The root logger
	#macro LOGGER global.logger
	LOGGER = new Logger();
	
	// Sentry
	#macro SENTRY global.sentry
	SENTRY = new Sentry();
	LOGGER.use_sentry(SENTRY);
	
	// Data managers
	#macro DATA global.data
	DATA = {
		password: new Password(),
		deployment_storage: new DeploymentStorage(),
		deployment_manager: new DeploymentManager(),
	}

	// The webserver
	#macro SERVER global.server
}