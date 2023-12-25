function ViewDashboard(): HtmxView() constructor {
	// View setup
	static path = "dashboard";
	static redirect_path = "main";
	
	static render = function(_context) {
		return @'
			<title>Dashboard</title>
			<h1>Dashboard</h1>
		';
	};
}