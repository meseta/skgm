function ViewDocsInstalling(): HtmxView() constructor {
	// View setup
	static path = "docs/installing";
	static redirect_path = "docs";
	static should_cache = true;
	
	static demo_code_1 = new HtmlCode(dedent(@'
		[Unit]
		Description=GameMaker Fake Display
 
		[Service]
		Restart=on-failure
		ExecStart=Xvfb :0 -screen 0 400x400x24
 
		[Install]
		WantedBy=default.target
	'), "txt");
	
	
	static demo_code_2 = new HtmlCode(dedent(@'
		adduser --disabled-password --gecos "" skgm
		usermod -L skgm
	'), "sh");
	
	static demo_code_3 = new HtmlCode(dedent(@'
		[Unit]
		Description=SeverKit GameMaker
		Requires=gamemaker-fake-display
		StartLimitBurst=5
		StartLimitIntervalSec=30
		
		[Service]
		Restart=on-failure
		Environment="DISPLAY=:0"
		ExecStart=/usr/local/bin/skgm.AppImage --appimage-extract-and-run
		User=skgm
		Group=skgm
 
		[Install]
		WantedBy=default.target
	'), "txt");
	
	static demo_code_4 = new HtmlCode(dedent(@'
		chmod 664 /etc/systemd/system/gamemaker-fake-display.service
		chmod 664 /etc/systemd/system/skgm.service

		systemctl daemon-reload
		systemctl enable gamemaker-fake-display
		systemctl enable skgm
		systemctl start gamemaker-fake-display
		systemctl start skgm
	'), "sh");
	
	static render = function(_context) {
		static cached = @'
			<h1>Installing as a Service</h1>
			<p>
				SKGM can be installed on Ubuntu 20.04 or 22.04 as a systemd service, rather than run manually. Once the prerequisites
				have been installed, the following systemd units can be created to install SKGM as a service.
			</p>
			<h2>Xvfb for Headless</h2>
			<p>
				As with the manual setup, SKGM needs a Xvfb display to run headless. Save the following script as
				<code>/etc/systemd/system/gamemaker-fake-display.service</code>
			</p>
			
			'+ self.demo_code_1.render() + @'
			
			<h2>Creating an Unpriviliged User</h2>
			<p>
				It is desirable to run SKGM as an unpriviliged user. One can be created using the following commands
			</p>
			
			'+ self.demo_code_2.render() + @'
			
			<h2>SKGM Service</h2>
			<p>
				The following systemd unit launches SKGM as a service, and provides some automatic restart support. Save the following script
				as <code>/etc/systemd/system/skgm.servic</code>. Any additional environmental variables can be added here to further customize
				SKGM before launching it.
			</p>
			
			'+ self.demo_code_3.render() + @'
			
			<h2>Enable and Start Services</h2>
			<p>
				Once the files and users have been create, the files need to be given the correct permissions, and enabled as services.
			</p>
			
			'+ self.demo_code_4.render() + @'
			
			<p>
				Once SKGM is running, you can open up the control panel, using port 5000 (the default port). e.g. <code>http://<your server ip>:5000</code>
			</p>
		';
		return cached;
	}
}
