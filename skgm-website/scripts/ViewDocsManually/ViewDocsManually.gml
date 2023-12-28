function ViewDocsManually(): HtmxView() constructor {
	// View setup
	static path = "docs/running-manually";
	static redirect_path = "docs";
	static should_cache = true;
	
	static demo_code_1 = new HtmlCode(dedent(@'
		echo "deb http://security.ubuntu.com/ubuntu xenial-security main" > /etc/apt/sources.list.d/xenial-security.list

		apt-get update
		apt-get install --no-install-recommends --yes \
		  libxxf86vm1 \
		  libgl1 \
		  libssl1.1 \
		  libxrandr2 \
		  libglu1-mesa \
		  libcurl4 \
		  libopenal1 \
		  xvfb \
		  libssl1.0.0 \
		  libcurl3-gnutls \
		  lsb-release
	'), "sh");
	
	static demo_code_2 = new HtmlCode(dedent(@'
		apt-get update
		apt-get install --no-install-recommends --yes \
		  curl \
		  ca-certificates \
		  gpg \
		  gpg-agent \
		  dirmngr

		echo "deb http://security.ubuntu.com/ubuntu xenial-security main" > /etc/apt/sources.list.d/xenial-security.list
		echo "deb http://security.ubuntu.com/ubuntu focal-security main" > /etc/apt/sources.list.d/focal-security.list
		gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 40976EAF437D05B5 3B4FE6ACC0B21F32
		gpg --export 40976EAF437D05B5 3B4FE6ACC0B21F32 >/etc/apt/trusted.gpg.d/security.ubuntu.com.gpg

		apt-get update
		apt-get install --no-install-recommends --yes \
		  libxxf86vm1 \
		  libgl1 \
		  libssl1.1 \
		  libxrandr2 \
		  libglu1-mesa \
		  libcurl4 \
		  libopenal1 \
		  xvfb \
		  libssl1.0.0 \
		  libcurl3-gnutls \
		  lsb-release
	'), "sh");
	
	static demo_code_3 = new HtmlCode(dedent(@'
		Xvfb :0 -screen 0 400x400x24 &
	'), "sh");
	
	static demo_code_4 = new HtmlCode(dedent(@'
		DISPLAY=:0 ./skgm.AppImage --appimage-extract-and-run
	'), "sh");
	
	static render = function(_context) {
		static cached = @'
			<h1>Running Manually</h1>
			<p>
				SKGM can be downloaded as a AppImage from <a href="https://github.com/meseta/skgm/releases">the GitHub releases</a>
				and run on the server. A <a href="https://meseta.dev/serverkit-gamemaker/">beginners guide is available here</a>. An
				<a href="https://gist.github.com/meseta/53bac1a27c4ab48065c49f509a18e55b">cloud-init script is available here</a>.
			</p>
			<h2>Prerequisites</h2>
			<p>
				The prerequisites for SKGM are the same as other GameMaker games. Ubuntu 20.04 and 22.04 are needed (other distros
				may work but are not tested), and the following apt packages are needed:
				<ul>
					<li>libxxf86vm1</li>
					<li>libgl1</li>
					<li>libssl1.1</li>
					<li>libxrandr2</li>
					<li>libglu1-mesa</li>
					<li>libcurl4</li>
					<li>libopenal1</li>
					<li>xvfb</li>
					<li>libssl1.0.0</li>
					<li>libcurl3-gnutls</li>
					<li>lsb-release</li>
				</ul>
			</p>
			<p>
				For Ubuntu 20.04, use the following commands to install them:
			</p>
			
			'+ self.demo_code_1.render() + @'
			
			<p>
				For Ubuntu 22.04, use the following commands to install them:
			</p>
			
			'+ self.demo_code_2.render() + @'
			
			<h2>Running headless</h2>
			<p>
				As usual for GameMaker games on linux, running headless needs the help of <code>Xvfb</code>. This needs to be running at any
				time SKGM is running. The following commands will run Xvfb in the background:
			</p>
			
			'+ self.demo_code_3.render() + @'
			
			<p>
				Once Xvfb has been run, SKGM can then be run headless on DISPLAY=:0. Games that it start up will also use this display to run headless
			</p>
			
			'+ self.demo_code_4.render() + @'
			
			<p>
				Once SKGM is running, you can open up the control panel, using port 5000 (the default port). e.g. <code>http://<your server ip>:5000</code>
			</p>
		';
		return cached;
	}
}
