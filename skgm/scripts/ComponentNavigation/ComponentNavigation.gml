function ComponentNavigation(): HtmlComponent() constructor {
	static render = function(_context) {
		static _logged_out_links = [
			new ComponentNavigationLink(ViewIndex.content_id, ViewLogIn.path, "Log In"),
		];
		
		static _logged_in_links = [
			new ComponentNavigationLink(ViewIndex.content_id, ViewMain.path, "Home"),
			new ComponentNavigationLink(ViewIndex.content_id, ViewLogOut.path, "Log Out"),
		]
		
		var _links = _context.has_session() ? _logged_in_links : _logged_out_links;
	
		return @'
			<nav hx-boost="true" class="container-fluid" style="height: 3.5em; border-bottom: 1px solid var(--muted-border-color); padding-left: 0px;">
				<div>
					<img src="/images/sLogo.png" alt="" style="height: 3.5em; width: 3.5em; margin-right: 0.5em;" />
					<strong>'+ string(DATA.settings.get("website_name")) +@'</strong>
				</div>
				<ul>
					'+ HtmlComponent.render_array(_links, "", _context) + @'
				</ul>
			</nav>
		';
	};
}
