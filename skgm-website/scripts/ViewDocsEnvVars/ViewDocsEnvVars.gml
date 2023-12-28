function ViewDocsEnvVars(): HtmxView() constructor {
	// View setup
	static path = "docs/environmental-variables";
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
			<h1>Environmental Variables</h1>
			<p>
				SKGM can be started without any customization. Almost all of the configurable elements can be configured from the
				web interface. However, it is sometimes desirable to customize it using environmental variables so that it is set up
				at launch. The following table lists the available environmental variables:
			</p>
			<table>
			<thead>
				<tr>
				<th>Variable</th>
				<th>Default</th>
				<th>Description</th>
				</tr>
			</thead>
			<tbody>
				<tr>
				<td><strong>SKGM_DISPLAY</strong></td>
				<td><em>:0</em></td>
				<td>The DISPLAY variable that will be used to start deployments</td>
				</tr>
				<tr>
				<td><strong>SKGM_PASSWORD</strong></td>
				<td><em>empty</em></td>
				<td>The initial admin password. The password can still be changed to a different one via the web interface</td>
				</tr>
				<tr>
				<td><strong>SKGM_PORT</strong></td>
				<td><em>5000</em></td>
				<td>The port that SKGM will use for the web interface</td>
				</tr>
				<tr>
				<td><strong>SKGM_SENTRY_DSN</strong></td>
				<td><em>empty</em></td>
				<td>SKGM can use Sentry to monitor itself, this is the DSN to use</td>
				</tr>
				<tr>
				<td><strong>SKGM_WEBSITE_NAME</strong></td>
				<td><em>ServerKit GameMaker</em></td>
				<td>The name of the website that shows in the top left corner of the web UI. This can be customized to help distinguish different SKGM installations</td>
				</tr>
			</tbody>
			</table>
		';
		return cached;
	}
}
