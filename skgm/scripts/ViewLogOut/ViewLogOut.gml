function ViewLogOut(): HtmxView() constructor {
	// View setup
	static path = "log-out";
	static redirect_path = "";

	static render = function(_context) {
		if (_context.has_session()) {
			_context.logger.info("Logged out", {session_id: _context.session.session_id});
			_context.close_session();
		}
		
		return @'
			<title>Log Out</title>
			<article style="text-align: center; margin: 0px auto; max-width: 400px;">
				<header>
					<h1 style="margin-bottom: 0;">You have been logged out</h1>
				</header>
				<p>You have been logged out. <a href="/'+ ViewLogIn.path + @'">click here to log in</a>.</p>
			</article>
		';
	}
}
