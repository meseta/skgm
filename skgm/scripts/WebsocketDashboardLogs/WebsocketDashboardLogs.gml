function WebsocketDashboardLogs(): HttpServerRenderBase() constructor {
	static path = "dashboard-logs"
	
	/** Handle function for processing a websocket connection
	 * Must return a websocket session struct, or undefined to reject the connection
	 * @return {Struct.HttpServerWebsocketSessionBase}
	 */
	static handler = function(_context) {
		if (!_context.has_session()) {
			return undefined;
		}
		
		return new WebsocketDashboardLogsSession();
	}
}