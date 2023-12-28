function ViewHome(): HtmxView() constructor {
	// View setup
	static path = "home";
	static redirect_path  = "";
	static should_cache = true;
	
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
				<div class="grid" style="column-gap: 3em; align-items:center">
				<div>
					<hgroup>
						<h2>Deploy GameMaker Servers</h2>
						<h3>Easily upload, deploy and manage new builds from a web interface</h3>
					</hgroup>
					<p>
						SKGM allows you to upload GameMaker *.AppImage builds to your server
						and run them from the web interface and monitor the server logs from
						the dashboard, without needing to do any scripting or server administration
					</p>
				</div>
				<img src="/static/docs/manage.png" alt="" />
				</div>
			</article>
			
			<article>
				<div class="grid" style="column-gap: 3em; align-items:center">
				<img src="/static/docs/version.png" alt="" />
				<div>
					<hgroup>
						<h2>Manage Version</h2>
						<h3>View past versions and roll back with a single click</h3>
					</hgroup>
					<p>
						SKGM stores a history of your previous deployed versions, so if your new
						build isn`t working, you can quickly roll back to a previous build with
						a single click
					</p>
				</div>
				</div>
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
