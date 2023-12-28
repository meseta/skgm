function ViewDocsDocker(): HtmxView() constructor {
	// View setup
	static path = "docs/docker";
	static redirect_path = "docs";
	static should_cache = true;
	
	static demo_code_1 = new HtmlCode(dedent(@'
		// Run in the foreground. ctr+c to quit
		docker run -p 5000:5000 -it meseta/skgm:v1.0.1
		
		// Run detached (in the background. Do a "docker stop skgm" to stop it
		docker run -p 5000:5000 -d --name skgm meseta/skgm:v1.0.1
		
		// Example for adding more ports and customizing via environmental variables
		docker run -p 5000:5000 -p 5001:5001 -e SKGM_PASSWORD=123456 -d --name skgm meseta/skgm:v1.0.1
	'), "txt");
	
	static demo_code_2 = new HtmlCode(dedent(@'
		services:
		  my-skgm:
		    image: meseta/skgm:v1.0.1
		    restart: always
		    environment:
		      SKGM_WEBSITE_NAME: "My SKGM Installation"
		      SKGM_PASSWORD: "123456"
			ports:
			  - "5000:5000"
			  - "5001:5001"
		    volumes:
		      - skgm-data:/home/skgm/.config/skgm

		volumes:
		  skgm-data:
		  
	'), "yaml");
	
	
	static render = function(_context) {
		static cached = @'
			<h1>Using Docker</h1>
			<p>
				A public Docker image is provided on dockerhub containing SKGM and its prerequisites at <a href="https://hub.docker.com/r/meseta/skgm">meseta/skgm</a>.
				allowing rapid deployment of SKGM.
			</p>
			<h2>Starting From Docker</h2>
			<p>
				Use one of the following commands to launch an instance of SKGM directly on docker.
			</p>
			
			'+ self.demo_code_1.render() + @'
			
			<p>
				Once the docker container has started up, you can access it at <code>http://localhost:5000</code>. Note: the above command only exposes the default
				SKGM management port, other ports may need to be added. A newer version may also be available than the tag mentioned in the examples, please
				check DockerHub.
			</p>
			
			<h2>Docker Compose</h2>
			<p>
				Docker-compose can be used to create a more perisstent service. Here is an example of a docker-compose yaml file
			</p>
			
			'+ self.demo_code_2.render() + @'
			
			<p>
				This docker-compose file sets up some environmental variables to customize the SKGM installation, exposes some ports, and
				mounts a persistent volume so that settings and deployments are persisted across restarts. Once the docker container has started up, you can access it at <code>http://localhost:5000</code>
				Note: A newer version may also be available than the tag mentioned in the examples, please check DockerHub. 
			</p>
			
		';
		return cached;
	}
}
