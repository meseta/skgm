function ViewDashboard(): HtmxView() constructor {
	// View setup
	static path = "dashboard";
	static redirect_path = "main";
	
	static render = function(_context) {
		var _render = @'
			<title>Dashboard</title>
			<h1>Dashboard</h1>
			
			<article>
				<header>
					<h2 style="margin-bottom: 0;">Current Deployment</h2>
				</header>
				<p style="text-align: center;" class="secondary">
		';
		
		var _current_id = DATA.deployments.get_current_id();
		var _deployment = DATA.deployments.get(_current_id);
		
		if (!is_undefined(_deployment)) {
			_render += @'
					<strong>'+ _deployment.name +@'</strong><br /> Creation date: <span class="secondary">'+ date_datetime_string(_deployment.created) +@'</span>
			';
			
		}
		else {
			_render += @'<em>There is no active deployment</em>.';
		}
		_render += @'
				</p>
				<footer style="text-align: right;">
					<a href="/'+ ViewDeploy.path +@'" hx-boost="true" hx-target="#' + ViewMain.content_id +@'" role="button" class="outline">Manage Deployments</a>
				</footer>
			</article>
		';
				
		return _render;
	};
}