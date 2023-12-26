function ComponentMainNavigation(): HtmlComponent() constructor {
	static render = function(_context) {
		static _links = [
			new ComponentNavigationLink(ViewMain.content_id, ViewDashboard.path, "Dashboard", ViewMain.path),
			new ComponentNavigationLink(ViewMain.content_id, ViewDeploy.path, "Manage Deployments"),
			new ComponentNavigationLink(ViewMain.content_id, ViewSetPassword.path, "Change Password"),
		];
	
		return @'
			<nav hx-boost="true">
				<ul>
					'+ HtmlComponent.render_array(_links, "", _context) + @'
				</ul>
			</nav>
		';
	};
}

