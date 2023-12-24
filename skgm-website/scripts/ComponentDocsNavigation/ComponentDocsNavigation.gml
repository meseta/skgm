function ComponentDocsNavigation(): HtmlComponent() constructor {
	static render = function(_context) {
		static _links_1 = [
			new ComponentNavigationLink(ViewDocs.content_id, ViewDocsDownloading.path, "Downloading", ViewDocs.path),
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

