function ViewMain(): HtmxView() constructor {
	// View setup
	static path = "main";
	static redirect_path  = "";
	
	static render = function(_context) {
		return "logged in";
	};
}
