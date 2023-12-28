/// Feather ignore GM2017

/** Initialize the website */
function init_site(){
	SERVER = new HttpServer(real(DATA.settings.get("port")), LOGGER);
	SERVER.logger.set_level(Logger.INFO);
	LOGGER.info("Starting SKGM", {version: GM_version})

	// static file host
	SERVER.add_file_server("static/*", "static");
	SERVER.add_sprite_server("images/{image_name}.png", "image_name");

	// add views
	SERVER.add_renders_by_tag("http_view");
	
	// websocket
	SERVER.add_render(WebsocketDashboardLogs, true);
}
