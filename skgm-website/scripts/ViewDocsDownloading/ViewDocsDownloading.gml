function ViewDocsDownloading(): HtmxView() constructor {
	// View setup
	static path = "docs/downloading";
	static redirect_path = "docs";
	static shoud_cache = true;
	
	static render = function(_context) {
		static cached = @'
			<h1>Downloading</h1>
		';
		return cached;
	}
}
