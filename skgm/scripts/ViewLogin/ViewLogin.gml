function ViewLogin(): HtmxView() constructor {
	// View setup
	static path = "login";
	static redirect_path = "";
	
	static modal_id = self.auto_id("modal");

	static render = function(_context) {
		var _validation = self.__validate_password(_context.request.get_form("password"));
		
		if (_validation.success == true) {
			// password accepted
			_context.start_session();
			
			// get HX to redirect
			self.hx_redirect(_context, ViewMain.path)
			
			// fallback, use redirect facility inside ViewMain
			_context.data.redirect = ViewMain.path;
		}

		return @'
			<title>Log In</title>
			<article id="'+ self.modal_id +@'" style="text-align: center; margin: 0px auto; max-width: 400px;">
				<header>
					<h1 style="margin-bottom: 0;">Log In</h1>
				</header>
				<form hx-boost="true" hx-target="#'+ self.modal_id +@'" hx-swap="outerHTML" action="/'+ self.path +@'" method="POST">
					<p>'+ (is_string(_validation.message) ?  $"<mark>{_validation.message}</mark>" : "") + @'</p>
					
					'+ (_validation.success != true
						? @'<input type="password" name="password" placeholder="Admin Password" aria-label="Admin password" required>
							<button type="submit">Log in</button>'
						: ""
					) + @'
				</form>
			</article>
		';
	}
		
	static __validate_password = function(_password) {
		if (is_undefined(_password)) {
			return new self.__Validation();	
		}
		if (_password == "") {
			return new self.__Validation(false, "Please enter a password");	
		}
		if (!DATA.password.check_password(_password)) {
			return new self.__Validation(false, "Password was incorrect, please try again");	
		}
		return new self.__Validation(true, $"Successfully logged in, if you're not redirected, click <a href='/{ViewMain.path}'>here</a>");
	}
	
	static __Validation = function(_success=undefined, _message=undefined) constructor {
		self.success = _success;
		self.message = _message;
	}
}
