function ComponentDocsNavigation(): HtmlComponent() constructor {
	static render = function(_context) {
		static _links_1 = [
			new ComponentNavigationLink(ViewDocs.content_id, ViewDocsManually.path, "Running manually", ViewDocs.path),
			new ComponentNavigationLink(ViewDocs.content_id, ViewDocsInstalling.path, "Installing as a Service"),
			new ComponentNavigationLink(ViewDocs.content_id, ViewDocsDocker.path, "Using Docker"),
			new ComponentNavigationLink(ViewDocs.content_id, ViewDocsEnvVars.path, "Environmental Variables"),
		];
	
		return @'
			<nav hx-boost="true">
				<ul>
					'+ HtmlComponent.render_array(_links_1, "", _context) + @'
				</ul>
			</nav>
		';
	};
}

