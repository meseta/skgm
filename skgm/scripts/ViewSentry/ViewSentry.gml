function ViewSentry(): HtmxView() constructor {
	// View setup
	static path = "sentry";
	static redirect_path = "main";
	static no_session_redirect_path = "not-logged-in";
	static should_cache = false;
	
	static modal_id = self.auto_id("modal");
	
	static render = function(_context) {
		var _message = undefined;
		if (_context.request.method == "POST") {
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
		
		var _render = @'
			<title>Sentry</title>
		';
		
		if (!is_undefined(_message)) {
			_render += $"<p><mark>{sanitize_tags(_message)}</mark></p>";
		}
		
		_render += @'
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
		';
		
		return _render;
	};
}
