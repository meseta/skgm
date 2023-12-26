function ViewDashboard(): HtmxView() constructor {
	// View setup
	static path = "dashboard";
	static redirect_path = "main";
	static no_session_redirect_path = "not-logged-in";
	static should_cache = false;
	
	static output_log_id = self.auto_id("output-log");
	
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
			//var _output = DATA.deployment_manager.get_output();
			// '+ string_join_ext("\n", _output) + @'
			// 
			// 				<script>
				//	let obj = document.getElementById("output-log");
				//	obj.scrollTop = obj.scrollHeight;
				//</script>
			//
			//
			_render += @'
				<p style="text-align: center;" class="secondary">
					<strong>'+ _deployment.name +@'</strong><br /> Creation date: <span class="secondary">'+ date_datetime_string(_deployment.created) +@'</span>
				</p>
				
				<style>
					#'+self.output_log_id+@' {
						height: 300px;
						overflow-y: auto;
						overflow-x: auto;
						padding: 4px;"
					}
				</style>
				<div hx-ext="ws" ws-connect="/'+WebsocketDashboardLogs.path+@'">
					<pre id="'+self.output_log_id+@'">Loading...</pre>
				</div>
				<script>
					var logScrollSnapped = true;
					document.body.addEventListener("htmx:wsBeforeMessage", function() {
						let el = document.getElementById("'+self.output_log_id+@'");
						if (el) {
							logScrollSnapped = el.scrollHeight - el.clientHeight <= el.scrollTop + 1;
						}
					});
					document.body.addEventListener("htmx:wsAfterMessage", function() {
						let el = document.getElementById("'+self.output_log_id+@'");
						if (el && logScrollSnapped) {
							el.scrollTop = el.scrollHeight;
						}
					});
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