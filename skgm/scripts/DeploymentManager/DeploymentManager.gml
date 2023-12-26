function DeploymentManager() constructor {
	self.__deployment_id = "";
	self.__path = "";
	
	static max_output_lines = 1000;
	
	self.__output_buffer = [];
	self.__timer = undefined;
	
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
			Skshhelper.close(self.__current);	
		}
		
		self.__output_buffer = [];
		
		// start new
		self.__deployment_id = _deployment_id;
		self.__path = _path;
		Skshhelper.open(_path, _deployment_id);
		
		// launch the output collector
		if (!is_undefined(self.__timer) && time_source_exists(self.__timer)) {
			call_cancel(self.__timer);
		}
		self.__timer = call_later(1, time_source_units_frames, method(self, self.__collect_output), true);
	}
	
	/** Restart the current deployment
	 * @return {Bool}
	 */
	static restart = function() {
		if (self.__deployment_id != "") {
			Skshhelper.close(self.__deployment_id);
			Skshhelper.open(self.__path, self.__deployment_id);
			self.__output_buffer = [];
		}
	}
	
	/** Get the most recent stdout lines form the deployment
	 * @return {Array<String>}
	 */
	static get_output = function() {
		return self.__output_buffer;	
	}
	
	/** Collect the stdout into a limited length array
	 * @ignore
	 */
	static __collect_output = function() {
		repeat (10000) { // maximum lines!
			var _line = Skshhelper.read();
			if (_line == "") {
				break;	
			}
			var _filtered_line = string_trim_end(string_replace_all(string_replace_all(_line, "<", "&lt;"), ">", "&gt;"))
			// filter line
			array_push(self.__output_buffer, _filtered_line);
		}
		
		// trim history to length
		var _delete_amount = array_length(self.__output_buffer) - self.max_output_lines;
		if (_delete_amount > 0) {
			array_delete(self.__output_buffer, 0, _delete_amount);
		}
	}
}