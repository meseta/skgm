function ViewDashboard(): HtmxView() constructor {
	// View setup
	static path = "dashboard";
	static redirect_path = "main";
	static no_session_redirect_path = "not-logged-in";
	static should_cache = false;
	
	static render = function(_context) {
		if (_context.request.get_query("action") == "restart") {
			self.hx_replace_url(_context, self.path);
			DATA.deployment_manager.restart();
		}
			
		var _render = @'
			<title>Dashboard</title>
			<h1>Dashboard</h1>
			
			<article>
				<header>
					<h2 style="margin-bottom: 0;">Current Deployment</h2>
				</header>
		';
		
		var _current_id = DATA.deployment_manager.get_current_id();
		var _deployment = DATA.deployment_storage.get(_current_id);
		
		if (!is_undefined(_deployment)) {
			var _output = DATA.deployment_manager.get_output();
			_render += @'
				<p style="text-align: center;" class="secondary">
					<strong>'+ _deployment.name +@'</strong><br /> Creation date: <span class="secondary">'+ date_datetime_string(_deployment.created) +@'</span>
				</p>
				<pre id="output-log" style="max-height: 300px; overflow-y: auto; overflow-x: auto;">'+ string_join_ext("\n", _output) + @'</pre>
				<script>
					let obj = document.getElementById("output-log");
					obj.scrollTop = obj.scrollHeight;
				</script>
				
				<footer style="text-align: right;">
					<a href="/'+ ViewDashboard.path +@'?action=restart" hx-boost="true" hx-target="#' + ViewMain.content_id +@'" role="button" class="outline">Restart</a>
					<a href="/'+ ViewDeploy.path +@'" hx-boost="true" hx-target="#' + ViewMain.content_id +@'" role="button" class="outline">Manage Deployments</a>
				</footer>
			';
		}
		else {
			_render += @'
				<p style="text-align: center;" class="secondary">
					<em>There is no active deployment</em>.
				</p>
				<footer style="text-align: right;">
					<a href="/'+ ViewDeploy.path +@'" hx-boost="true" hx-target="#' + ViewMain.content_id +@'" role="button" class="outline">Manage Deployments</a>
				</footer>
			';
		}
		_render += @'
			</article>
		';
				
		return _render;
	};
}