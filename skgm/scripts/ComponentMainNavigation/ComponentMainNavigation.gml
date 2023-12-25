function ComponentMainNavigation(): HtmlComponent() constructor {
	static render = function(_context) {
		static _links = [
			new ComponentNavigationLink(ViewMain.content_id, ViewDashboard.path, "Dashboard", ViewMain.path),
		];
	
		return @'
			<nav hx-boost="true">
				<ul>
					'+ HtmlComponent.render_array(_links, "", _context) + @'
					<li>
						<a href="/'+ ViewSetPassword.path +@'" class="secondary" hx-target="#'+ ViewIndex.content_id +@'">Change Password</a>
					</li>
				</ul>
			</nav>
		';
	};
}

