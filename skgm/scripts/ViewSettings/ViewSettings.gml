function ViewSettings(): HtmxView() constructor {
	// View setup
	static path = "settings";
	static redirect_path = "main";
	static no_session_redirect_path = "not-logged-in";
	static should_cache = false;
	
	static modal_id = self.auto_id("modal");
	
	static render = function(_context) {
		var _message = undefined;
		if (_context.request.method == "POST") {
			if (is_string(_context.request.get_form("settings"))) {
				var _auto_restart = !!_context.request.get_form("auto_restert");
				DATA.settings.set("auto_restart", _auto_restart);
				var _auto_start = !!_context.request.get_form("auto_start");
				DATA.settings.set("auto_start", _auto_start);
				_context.logger.info("Settings saved", {auto_start: _auto_start, auto_restart: _auto_restart});
				_message = "Settings saved";
			}
			if (is_string(_context.request.get_form("sentry"))) {
				var _dsn = strip_quotes(HttpServer.url_decode(_context.request.get_form("sentry")));
				_context.logger.info("Setting Sentry DSN", {dsn: _dsn})
				try {
					SENTRY.set_dsn(_dsn);
					DATA.settings.set("sentry_dsn", _dsn);
					_message = "DSN updated";
					_context.logger.info("DSN successfully updated", {dsn: _dsn})
				}
				catch (_err) {
					_message = $"Invalid DSN format, please try again: {_err}";	
					_context.logger.exception(_err)
				}
			}
			else if (is_string(_context.request.get_form("website_name"))) {
				var _website_name = strip_quotes(sanitize_tags(HttpServer.url_decode(_context.request.get_form("website_name"))));
				_context.logger.info("Setting Website name", {website_name: _website_name})
				DATA.settings.set("website_name", _website_name);
				_message = "Website name updated, please refresh to see it fully";
			}
		}
		
		var _render = @'
			<title>SKGM Settings</title>
		';
		
		if (!is_undefined(_message)) {
			_render += $"<p><mark>{sanitize_tags(_message)}</mark></p>";
		}
		
		_render += @'
			<form hx-boost="true" hx-target="#'+ ViewMain.content_id +@'" action="/'+ self.path +@'" method="POST">
			<article>
				<header>
					<h1 style="margin-bottom: 0;">Deployment Settings</h1>
				</header>
				
				<p>
					<input type="checkbox" name="auto_start" id="auto_start" '+ (DATA.settings.get("auto_start") ? "checked" : "") +@'>
					<label for="auto_start">Auto Start deployment on SKGM startup</label>
				</p>
				<p>
					<input type="checkbox" name="auto_restart" id="auto_restart" '+ (DATA.settings.get("auto_restart") ? "checked" : "") +@'>
					<label for="auto_restart">Auto Restart deployment if crashed</label>
				</p>
				
				<footer style="text-align: right;">
					<input type="hidden" name="settings" value="true">
					<button style="display: inline; width: auto;" type="submit">Update</button>
				</footer>
			</article>
			</form>
			
			<form hx-boost="true" hx-target="#'+ ViewMain.content_id +@'" action="/'+ self.path +@'" method="POST">
			<article>
				<header>
					<h1 style="margin-bottom: 0;">Set Sentry DSN</h1>
				</header>
				
				<p>
					Set a Sentry DSN to moniter this installation of SKGM
				</p>
				
				<input type="text" name="sentry" placeholder="Sentry DSN, e.g. https:///xxx@yyy.ingest.sentry.io/zzz" aria-label="Sentry DSN" value="'+ DATA.settings.get("sentry_dsn") +@'" required>
				
				<footer style="text-align: right;">
					<button style="display: inline; width: auto;" type="submit">Set Sentry DSN</button>
				</footer>
			</article>
			</form>
			
			<form hx-boost="true" hx-target="#'+ ViewMain.content_id +@'" action="/'+ self.path +@'" method="POST">
			<article>
				<header>
					<h1 style="margin-bottom: 0;">Set Website Name</h1>
				</header>
				
				<p>
					Set a name for this installation of SKGM
				</p>
				
				<input type="text" name="website_name" placeholder="Website Name" aria-label="Website Name" value="'+ DATA.settings.get("website_name") +@'" required>
				
				<footer style="text-align: right;">
					<button style="display: inline; width: auto;" type="submit">Set Website Name</button>
				</footer>
			</article>
			</form>
		';
		
		return _render;
	};
}
