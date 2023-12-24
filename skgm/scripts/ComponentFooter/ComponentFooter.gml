function ComponentFooter(): HtmlComponent() constructor {
	static render = function(_context) {
		static cached = @'
			<footer hx-boost="true" class="container-fluid grid">
				<p style="text-align: center; color: var(--secondary);">
					<small>
						&copy; <a href="https://meseta.dev" class="secondary">Meseta</a> '+ string(current_year) +@'
					</small>
				</p>
				
				<p style="text-align: center; color: var(--secondary);">
					<small>
						Made with <img src="/images/sGameMaker.png" style="height: 16px; width: 16px; vertical-align: baseline" alt="" /> GameMaker
					</small>
				</p>
				
				<p style="text-align: center; color: var(--secondary);">
					<small>
						<a href="https://skgm.meseta.dev" class="secondary">SKGM</a>
					</small>
				</p>
			</footer>
		';
		return cached;
	};
}
