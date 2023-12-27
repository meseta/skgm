function ViewNotLoggedIn(): HtmxView() constructor {
	// View setup
	static path = "not-logged-in";
	static redirect_path = "";
	static should_cache = false;

	static render = function(_context) {
		return @'
			<title>Not Logged In</title>
			<article style="text-align: center; margin: 0px auto; max-width: 400px;">
				<header>
					<h1 style="margin-bottom: 0;">You are not logged in</h1>
				</header>
				<p>You must be logged in to view this page. <a href="/'+ ViewLogIn.path + @'">click here to log in</a>.</p>
			</article>
		';
	}
}
