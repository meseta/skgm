function ViewHome(): HtmxView() constructor {
	// View setup
	static path = "home";
	static redirect_path  = "";
	static shoud_cache = true;
	
	static render = function(_context) {
		static cached = @'
			<section style="text-align: center; margin-top: 3em;">
				<hgroup>
					<h1>ServerKit GameMaker</h1>
					<h2>A server control and administration tool for GameMaker</h2>
				</hgroup>
				<p>
					<a href="/'+ViewDocs.path+@'" role="button">Usage Guide</a> &nbsp; 
					<a href="https://github.com/meseta/skgm/releases" role="button" class="secondary outline" target="_blank">Download</a>
				</p>
			</section>
			
			<article>
				<h2>Manage GameMaker Servers</h2>
				<p>Drag-and-drop new builds to update your server</p>
				
			</article>
			
			<article>
				<h2>Host multiple servers on one server</h2>
				<p>Run and operate multiple GameMaker servers</p>
				
			</article>
			
			<section style="text-align: center;">
				<h1>Ready to start using ServerKit GameMaker?</h1>
				<p>
					<a href="/'+ViewDocs.path+@'" role="button">Usage Guide</a> &nbsp; 
					<a href="https://github.com/meseta/skgm/releases" role="button" class="secondary outline" target="_blank">Download</a>
				</p>
			</section>
		';
		return cached;
	}
}
