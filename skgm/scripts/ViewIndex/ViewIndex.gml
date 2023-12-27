function ViewIndex(): HttpServerRenderBase() constructor {
	// View setup
	static path = "";
	
	// Static properties
	static content_id = self.auto_id("content");

	// Rendering dynamic routes
	static render_route = function(_context) {
		var _render = _context.pop_render_stack();
		if (is_method(_render)) {
			return _render(_context);
		}
		else {
			if (_context.has_session()) {
				return ViewMain.render(_context);	
			}
			else if (!DATA.password.has_password()) {
				return ViewSetPassword.render(_context);
			}
			else {
				return ViewLogIn.render(_context);
			}
		}
	};
	
	static render = function(_context) {
		static _navigation = new ComponentNavigation();
		static _footer = new ComponentFooter();
		
		// Explicitly don't cache this, as we have dynamic content
		_context.response.set_should_cache(false);
		
		return Chain.concurrent_struct({
			route: self.render_route(_context),
			navigation: _navigation.render(_context),
			footer: _footer.render(_context),
			context: _context,
		}).chain_callback(function(_rendered) {
			// try to figure out title from our content
			var _title = self.__find_title(_rendered.route)
			
			/// Feather ignore once GM1009
			return @'
				<!DOCTYPE html>
				<html data-theme="light" lang="en"style="height: 100%">
				<head>
					<meta charset="utf-8">
					<title>'+ (_title ?? "ServerKit GameMaker") +@'</title>
					<link rel="icon" type="image/png" href="/images/sFavicon.png">
					<meta name="viewport" content="width=device-width, initial-scale=1">
					<link rel="stylesheet" href="/static/pico/pico.min.css">
					<link rel="stylesheet" href="/static/pico/theme.css">
					
					<script src="/static/htmx/htmx.min.js"></script>
					<script src="/static/htmx/ext_ws.min.js"></script>
				a
					'+ (struct_exists(_rendered.context.data, "redirect") ? $"<meta http-equiv='Refresh' content='0; URL={_rendered.context.data.redirect}' />" : "") +@'
					
					<meta name="description" content="An open source control panel to allow easy updating and administration of GameMaker servers." />
					<meta name="theme-color" content="#76428a" />

					<meta property="og:type" content="website" />
					<meta property="og:title" content="ServerKit GameMaker" />
					<meta property="og:description" content="An open source control panel to allow easy updating and administration of GameMaker servers."
					<meta property="og:image" content="https://skgm.meseta.dev/static/opengraph.png" />

					<meta property="twitter:card" content="summary_large_image" />
					<meta property="twitter:title" content="ServerKit GameMaker" />
					<meta property="twitter:description" content="An open source control panel to allow easy updating and administration of GameMaker servers." />
					<meta property="twitter:image" content="https://sk.meseta.dev/static/opengraph.png" />
				</head>
				<body style="min-height: 100%; background-image: linear-gradient(180deg, transparent, #00000019); background-attachment: fixed;">
					'+ _rendered.navigation +@'
					<main class="container" id="'+self.content_id+@'">
						'+ _rendered.route +@'
					</main>
					'+ _rendered.footer +@'
				</body>
				</html>
		'});
	};
		
	static __find_title = function(_html) {
		var _pos_start = string_pos("<title>", _html);
		if (_pos_start < 1) {
			return undefined;
		}
		
		var _pos_end = string_pos("</title>", _html);
		if (_pos_start < 1) {
			return undefined;
		}
		
		return string_copy(_html, _pos_start+7, _pos_end-_pos_start-7);
	};
}