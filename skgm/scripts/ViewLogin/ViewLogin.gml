function ViewLogin(): HttpServerRenderBase() constructor {
	// View setup
	static path = "login";
	static redirect_path = "";
	
	/** Handle function for processing a request
	 * @param {Struct.HttpServerRequestContext} _context The incoming request contex
	 */
	static handler = function(_context) {
		if (_context.request.method == "POST") {
			if (_context.request.get_form("password") == "123123") {
				_context.start_session(7*24*3600);
				// redirect to main
				throw new ExceptionHttpServerInternalRedirect(self.redirect_path);
			}
		}
		
		_context.push_render_stack(method(self, self.render));
		throw new ExceptionHttpServerInternalRedirect(self.redirect_path);
	};
	
	static render = function(_context) {
		var _error_message = "";
		if (_context.request.has_form("password") && !_context.has_session()) {
			_error_message = "<p><mark>Invalid password, please try again</mark></p>";
		}
		return @'
			<div class="grid">
				<div></div>
				<form action="/login" method="POST">
					<article style="text-align: center; margin-top: 0; margin-bottom: 0;">
						<header>
							<h1 style="margin-bottom: 0;">Login</h1>
						</header>
						'+ _error_message +@'
						<input type="password" id="password" name="password" placeholder="Admin Password" required>
						<button type="submit">Log in</button>
					</article>
				</form>
				<div></div>
			</div>
		';
	};
}
