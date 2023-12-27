function ViewAbout(): HtmxView() constructor {
	// View setup
	static path = "about";
	static redirect_path  = "";
	static shoud_cache = true;
	
	static render = function(_context) {
		static cached = @'
			<h2>About ServerKit GameMaker</h2>
			<p>
				<strong>ServerKit GameMaker</strong> is an open source control panel to allow easy drag & drop updating and administration
				of GameMaker servers, and server administration. For example, the <a href="https://skgm.meseta.dev">SKGM Website</a>
				is controlled and administrated by ServerKit.
			</p>
			<p>
				<strong>SKGM</strong> uses the <a href="https://htgm.meseta.dev">HTGM web framework</a>, and is inspired by server
				administration tools like cPanel.
			</p>
			<p>
				<strong>HTGM</strong> was created by <a href="https://meseta.dev">Meseta</a>, released under the
				<a href="https://opensource.org/license/mit/">MIT open source license</a>, and is free to use for commercial and non-commercial
				projects. The project is released as-is, and no support or warranties are provided, but those working on GameMaker projects in
				general may find help from the friendly <a href="https://discord.gg/gamemaker">GameMaker community on Discord</a>.
			</p>
		';
		return cached;
	}
}
