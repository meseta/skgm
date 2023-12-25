function ViewSetPassword(): HtmxView() constructor {
	// View setup
	static path = "set-password";
	static redirect_path = "";
	static no_session_redirect_path = ViewNotLoggedIn.path;
	
	static modal_id = self.auto_id("modal");
	
	static handler = function(_context) {
		// only redirect if we have a password
		if (!_context.has_session() && DATA.password.has_password()) {
			if (self.is_hx_request(_context)) {
				_context.response.set_header("HX-Replace-Url", self.no_session_redirect_path);
			}
			else {
				_context.response.set_header("HX-Location", self.no_session_redirect_path);
			}
			throw new ExceptionHttpServerInternalRedirect(self.no_session_redirect_path);
		}
		
		if (!self.is_hx_request(_context) &&  _context.request.path != self.redirect_path) {
			_context.push_render_stack(method(self, self.render));
			throw new ExceptionHttpServerInternalRedirect(self.redirect_path);
		}
		
		_context.response.send_html(self.render(_context));
	};
	
	static render = function(_context) {
		var _validation = self.__validate_passwords(_context.request.get_form("password"), _context.request.get_form("password_confirm"));
		
		if (_validation.success == true) {
			// password accepted
			DATA.password.set_password(_context.request.get_form("password"));
		}
		
		return @'
			<title>Set Password</title>
			<article id="'+ self.modal_id +@'" style="text-align: center; margin: 0px auto; max-width: 400px;">
				<header>
					<h1 style="margin-bottom: 0;">Set Admin Password</h1>
				</header>
				<form hx-boost="true" hx-target="#'+ self.modal_id +@'" hx-swap="outerHTML" action="/'+ self.path +@'" method="POST">
					<p>'+ (is_string(_validation.message) ?  $"<mark>{_validation.message}</mark>" : "") + @'</p>
					
					'+ (_validation.success != true
						? @'<input type="password" name="password" placeholder="Admin Password" aria-label="Admin Password" required>
							<input type="password" name="password_confirm" placeholder="Confirm Password" aria-labe="Confirm Password" required>
							<button type="submit">Set Admin Password</button>'
						: @'<a href="/'+ViewLogin.path+@'">Click here to log in</a>'
					) + @'
				</form>
			</article>
		';
	};
	
	static __validate_passwords = function(_password, _password_confirm) {
		if (is_undefined(_password) || is_undefined(_password_confirm)) {
			return new self.__Validation();	
		}
		if (_password == "" || _password_confirm == "") {
			return new self.__Validation(false, "Please enter a password and confirmation");	
		}
		if (_password != _password_confirm) {
			return new self.__Validation(false, "Password were not the same, please try again");	
		}
		return new self.__Validation(true, $"Successfully changed password");
	}
	
	static __Validation = function(_success=undefined, _message=undefined) constructor {
		self.success = _success;
		self.message = _message;
	}
}
