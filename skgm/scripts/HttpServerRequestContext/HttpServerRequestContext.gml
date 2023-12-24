/** An HTTP request context that is passed to the handlers to view
 * @param {Struct.HttpRequest} _request The incoming request
 * @param {Struct.HttpResponse} _response The response going back out
 * @param {Struct.Logger} _logger logger to use
 */
function HttpServerRequestContext(_request, _response=undefined, _logger=undefined) constructor {
	static session_storage = {};
	static session_cookie_name = "htgm-session";
	
	self.request = _request;
	self.response = _response;
	self.session = undefined;
	self.session_id = undefined;
	
	_logger ??= LOGGER;
	self.logger = _logger.bind({request_time: HttpServer.rfc_date_now() });
	
	// check of session cookie
	if (self.request.has_cookie(self.session_cookie_name)) {
		var _session_id = self.request.get_cookie(self.session_cookie_name);
		self.session = self.session_storage[$ string(_session_id)];
	}
	
	/* @ignore */ self.__render_stack = [];
	
	/** Checks if there is a render stack
	 * @return {Bool}
	 */
	static has_render_stack = function() {
		return array_length(self.__render_stack) > 0;
	};
	
	/** Gets the top-most 
	 * @return {Function}
	 */
	static pop_render_stack = function() {
		return array_pop(self.__render_stack);
	};
	
	/** Pushes a renderer to the stack
	 * @param {Function} _render Render function to push
	 */
	static push_render_stack = function(_render) {
		array_push(self.__render_stack, _render);
	};
	
	/** Whether we have an active session
	 * @return {Bool}
	 */
	static has_session = function() {
		return !is_undefined(self.session) && self.session.is_valid();
	}
	
	/** Starts a new session
	 * @param {Real} _expires_seconds How long the session lasts, in seconds
	 */
	static start_session = function(_expires_seconds=24*3600) {
		var _session_id = self.__uuid4();
		self.session = new HttpServerLoginSession(_session_id, _expires_seconds);
		self.session_storage[$ _session_id] = self.session;
		self.__set_session_cookie(_session_id, _expires_seconds);
		self.logger.info("Session started", {session_id: _session_id});
	}
	
	/** Extends the session
	 * @param {Real} _expires_seconds How long the session lasts, in seconds
	 */
	static extend_session = function(_expires_seconds=24*3600) {
		if (is_undefined(self.session)) {
			throw new ExceptionHttpInternal("Session invalid");
		}
		self.session.extend(_expires_seconds);
		self.__set_session_cookie(self.session.session_id, _expires_seconds);
		self.logger.info("Session extended", {session_id: self.session.session_id});
	}
	
	static __set_session_cookie = function(_session_id, _max_age) {
		self.response.set_cookie(self.session_cookie_name, self.session.session_id, {max_age: _max_age, same_site: "Strict", http_only: true});
	}
	
	/** Generates a UUID4 */
	static __uuid4 = function() {
		static _sequence = 0;
		_sequence += 1; // sequence avoids getting the same number twice
		
		var _uuid = md5_string_utf8($"{date_current_datetime()}:{get_timer()}:{_sequence}");
		_uuid = string_set_byte_at(_uuid, 13, ord("4"));
		_uuid = string_set_byte_at(_uuid, 17, ord(choose("8", "9", "a", "b")));
		_uuid = string_insert("-", string_insert("-", string_insert("-", string_insert("-", _uuid, 9), 14), 19), 24);
		return _uuid;
	}
}
