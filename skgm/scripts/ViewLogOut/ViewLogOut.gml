function ViewLogOut(): HtmxView() constructor {
	// View setup
	static path = "log-out";
	static redirect_path = "";

	static render = function(_context) {
		_context.close_session();
		
		return @'
			<title>Log Out</title>
			<article style="text-align: center; margin: 0px auto; max-width: 400px;">
				<header>
					<h1 style="margin-bottom: 0;">You have been logged out</h1>
				</header>
				<p>You have been logged out. <a href="/'+ ViewLogin.path + @'">click here to log in</a>.</p>
			</article>
		';
	}
}
