function ViewDocs(): HtmxView() constructor {
	// View setup
	static path = "docs";
	static redirect_path  = "";
	static should_cache = true;
	
	// Static properties
	static content_id = self.auto_id("content");
	
	// On-page components
	static navigation = new ComponentDocsNavigation();
	
	// Rendering dynamic routes
	static render_route = function(_context) {
		var _render = _context.pop_render_stack();
		return is_method(_render) ? _render(_context) : ViewDocsManually.render(_context);
	};
	
	static render = function(_context) {
		return Chain.concurrent_struct({
			route: self.render_route(_context),
			navigation: self.navigation.render(_context),
		}).chain_callback(function(_rendered) {
			return @'
				<style>
					@media (min-width: 992px) {
					    .grid-nav {
					        grid-template-columns: 3fr 9fr;
							column-gap: 3em;
					    }
					}
			    </style>
				
				<div class="grid grid-nav">
					<aside>
						'+ _rendered.navigation +@'
					</aside>
					<section id="'+self.content_id+@'">
						'+ _rendered.route +@'
					</section>
				</div>
		'});
	};
}
