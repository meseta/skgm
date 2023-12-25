function ViewDeploy(): HtmxView() constructor {
	// View setup
	static path = "deploy";
	static redirect_path = "main";
	
	static render = function(_context) {
		var _message = undefined;
		
		if (_context.request.method == "POST") {
			var _file = _context.request.get_file("file");
			var _name = _context.request.get_form("name");
		
			if (_name == "") {
				_name = "Deployment";
			}
		
			if (!is_undefined(_file)) {
				if (DATA.deployments.check_buffer(_file.buffer)) {
					DATA.deployments.add(_file.buffer, _name);
					_message = @'New version "'+ _name + @'" successfully uploaded';
				}
				else {
					_message = "Error: file was not an AppImage";	
				}
			}
		}
		else if (_context.request.get_query("action") == "delete") {
			var _deployment_id = _context.request.get_query("deployment_id");
			if (DATA.deployments.has(_deployment_id)) {
				var _deployment = DATA.deployments.get(_deployment_id);
				DATA.deployments.remove(_deployment_id);
				_message = @'Deployment "' + _deployment.name + @'" sucessfully delete';
			}
			else {
				_message = "Deployment could not be found";
			}
		}
		else if (_context.request.get_query("action") == "deploy") {
			var _deployment_id = _context.request.get_query("deployment_id");
			if (DATA.deployments.has(_deployment_id)) {
				var _deployment = DATA.deployments.get(_deployment_id);
				DATA.deployments.deploy(_deployment_id);
				_message = @'Deployment "' + _deployment.name + @'" sucessfully deployed';
			}
			else {
				_message = "Deployment could not be found";
			}
		}
		
		var _render = @'
			<title>Manage Deployments</title>
			<h1>Manage Deployments</h1>
		';
		
		if (!is_undefined(_message)) {
			_render += $"<p><mark>{_message}</mark></p>";
		}
		
		_render += quote_fix(@'
			<form hx-boost="true" hx-target="#'+ ViewMain.content_id +@'" action="/'+ self.path +@'" method="POST" enctype="multipart/form-data">
			<article>
				<header>
					<h2 style="margin-bottom: 0;">Deploy a new version</h2>
				</header>
				
				<p>
					Select a GameMaker Ubuntu build with a <code>*.AppImage</code> extension to upload. You can give
					the deployment a nickname (e.g. version number) to help you keep track of different versions.
				</p>
				
				<input type="file" name="file" required>
				
				<label for="name">Deployment Nickname</label>
				<input type="text" id="name" name="name" placeholder="Deployment">
				
				<footer style="text-align: right;">
					<button style="display: inline; width: auto;" type="submit" hx-on:click="this.setAttribute(`disabled`, ``); this.setAttribute(`aria-busy`, `true`); this.form.submit();">Upload and Deploy</button>
				</footer>
			</article>
			</form>
		
			
			<article>
				<header>
					<h2 style="margin-bottom: 0;">Version history</h2>
				</header>
		');
		
		var _current_id = DATA.deployments.get_current_id();
		var _deployments = DATA.deployments.list();
		var _len = array_length(_deployments);
		if (_len > 0) {
			_render += @'
				<table role="grid">
				<tbody>
			';
			for (var _i=_len-1; _i>=0; _i-=1) {
				var _deployment = _deployments[_i];
				_render += @'
					<tr>
						<td>
							<strong>'+ _deployment.name +@'</strong><br />
							<span class="secondary">'+ date_datetime_string(_deployment.created) +@'</span>
						</td>
						<td style="text-align: right;" hx-boost="true" hx-target="#'+ ViewMain.content_id +@'">
				';
				if (_deployment.deployment_id == _current_id) {
					_render += @'
							<mark>Deployed!</mark>
					';
				}
				else {
					_render += @'
							<a href="/'+ ViewDeploy.path +@'?deployment_id='+_deployment.deployment_id+@'&action=delete" role="button" class="outline" hx-confirm="Are you sure you wish to delete this deployment?">Delete</a>
							<a href="/'+ ViewDeploy.path +@'?deployment_id='+_deployment.deployment_id+@'&action=deploy" role="button">Deploy</a>
					';
				}
				_render += @'
						</td>
					</tr>
				';
			}
			_render += @'
				</tbody>
				</table>
			';
		}
		else {
			_render += @'
				<p style="text-align: center;" class="secondary"><em>There are no versions to show</em></p>
			';
		}
		
		
		_render += @'
			</article>
		';
		
		return _render;
	};
}