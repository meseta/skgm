function DeploymentManager() constructor {
	self.__deployment_id = "";
	self.__path = "";
	
	static max_output_lines = 1000;
	
	self.__output_buffer = [];
	self.__timer = undefined;
	self.__monitor = undefined;
	
	self.__listeners = [];
	
	self.healthcheck_client = new HttpClient("", "healthcheck");
	self.healthcheck_failures = 0;
	
	/** Get the currently deployed deployment_id
	 * @return {String}
	 */
	static get_current_id = function() {
		return self.__deployment_id;
	}
	
	/** Get whether the current deployment is open or not
	 * @return {Bool}
	 */
	static is_open = function() {
		return self.__deployment_id != "" && Skshhelper.is_open(self.__deployment_id);
	}
	
	/** Get whether the current deployment is open or not
	 * @return {Bool}
	 */
	static is_crashed = function() {
		return self.__deployment_id != "" && !Skshhelper.is_open(self.__deployment_id);
	}
	
	/** Deploy a thing
	 * @param {String} _deployment The deployment
	 */
	static deploy = function(_deployment_id, _path) {
		var _existing_is_open = self.is_open();
		
		if (_deployment_id == self.__deployment_id && _existing_is_open) {
			// don't need to do anything, as we're already running
			return;
		}
		
		if (_existing_is_open) {
			// close the old one
			Skshhelper.close(self.__deployment_id);	
		}
		
		self.__output_buffer = [];
		
		// start new
		self.__deployment_id = _deployment_id;
		self.__path = _path;
		Skshhelper.open(_path, _deployment_id, DATA.settings.get("display"));
		
		// launch the output collector
		if (!is_undefined(self.__timer) && time_source_exists(self.__timer)) {
			call_cancel(self.__timer);
		}
		self.__timer = call_later(2, time_source_units_frames, method(self, self.__collect_output), true);
		if (!is_undefined(self.__monitor) && time_source_exists(self.__monitor)) {
			call_cancel(self.__monitor);
		}
		self.__monitor = call_later(30, time_source_units_frames, method(self, self.__monitor_deployment), true);
		
		DATA.settings.set("last_deployment", _deployment_id);
	}
	
	/** Restart the current deployment
	 * @return {Bool}
	 */
	static restart = function(_clear_output=true) {
		if (self.__deployment_id != "") {
			Skshhelper.close(self.__deployment_id);
			Skshhelper.open(self.__path, self.__deployment_id, DATA.settings.get("display"));
			
			if (_clear_output) {
				self.__output_buffer = [];
				// clear out the lines
				array_foreach(self.__listeners, function(_listener) {
					if (weak_ref_alive(_listener)) {
						_listener.ref.push_lines([], true);	
					}
				});
			}
		}
	}
	
	/** Get the most recent stdout lines form the deployment
	 * @return {Array<String>}
	 */
	static get_output = function() {
		return self.__output_buffer;
	}
	
	/** Register a listener to receive updates
	 * @param {Struct} _listener A listener
	 */
	static register_listener = function(_listener) {
		array_push(self.__listeners, weak_ref_create(_listener));
	}
	
	/** Collect the stdout into a limited length array
	 * @ignore
	 */
	static __collect_output = function() {
		var _lines = [];
		repeat (10000) { // maximum lines!
			var _line = Skshhelper.read();
			if (_line == "") {
				break;	
			}
			var _filtered_line = string_trim_end(sanitize_tags(_line))
			// filter line
			array_push(self.__output_buffer, _filtered_line);
			array_push(_lines, _filtered_line);
		}

		// push to listeners
		if (array_length(_lines) > 0) {
			for (var _i=array_length(self.__listeners)-1; _i>=0; _i-=1) {
				var _listener = self.__listeners[_i];
				if (weak_ref_alive(_listener)) {
					_listener.ref.push_lines(_lines);	
				}
				else {
					array_delete(self.__listeners, _i, 1);	
				}
			}
		
			// trim history to length
			var _delete_amount = array_length(self.__output_buffer) - self.max_output_lines;
			if (_delete_amount > 0) {
				array_delete(self.__output_buffer, 0, _delete_amount);
			}
		}
	}
	
	
	/** Collect the stdout into a limited length array
	 * @ignore
	 */
	static __monitor_deployment = function() {
		// check if crashed
		if (DATA.settings.get("auto_restart") && self.is_crashed()) {
			var _message = "SKGM: crash detected, restarting";
			array_push(self.__output_buffer, _message);
			
			array_foreach(self.__listeners, function(_listener) {
				if (weak_ref_alive(_listener)) {
					_listener.ref.push_lines([_message]);	
				}
			});
			
			LOGGER.warning(_message);
			self.restart(false);
		}
		
		var _healthcheck_path = DATA.settings.get("healthcheck_path");
		if (_healthcheck_path != "") {
			self.healthcheck_client.get(_healthcheck_path, undefined, 5)
				.chain_callback(function() {
					self.healthcheck_failures = 0;
				})
				.on_error(function(_err) {
					self.healthcheck_failures += 1;
					LOGGER.warning("Healthcheck failed", {count: self.healthcheck_failures, err: _err});
						
					if (self.healthcheck_failures > 5) {
						LOGGER.warning("Healthcheck failed too many times, restarting", {count: self.healthcheck_failures});
						self.restart(false);
					}
				});
		}
	}
}