function WebsocketDashboardLogsSession(): HttpServerWebsocketSessionBase() constructor {
	/** Function that will be called when websocket connects 
	 * @param {Struct.HttpServerWebsocket} _websocket The websocket in question
	 */
	static on_connect = function(_websocket) {
		self.websocket = _websocket;
		
		// send the current buffer, and register myself
		self.push_lines(DATA.deployment_manager.get_output(), true);
		DATA.deployment_manager.register_listener(self);
	};
	
	static push_lines = function(_lines, _first=false) {
		self.websocket.send_data_string(@'<pre id="'+ViewDashboard.output_log_id+@'" hx-swap-oob="'+(_first?"outerHTML":"beforeend")+@'">'+string_join_ext("\n", _lines)+"\n"+@'</pre>');
	}
}
