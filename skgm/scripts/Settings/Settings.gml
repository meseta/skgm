function Settings(_settings_file_location="settings.json") constructor {
	static version = 1;
	self.__settings_file_location = _settings_file_location;
	self.__settings = {
		sentry_dsn: self.__get_env("SKGM_SENTRY_DSN", ""),
		website_name: self.__get_env("SKGM_WEBSITE_NAME", "ServerKit GameMaker"),
		port: self.__get_env("SKGM_PORT", "5000"),
		display: self.__get_env("SKGM_DISPLAY", ":0"),
		version: self.version,
	};
	
	// try to load it
	if (file_exists(self.__settings_file_location)) {
		LOGGER.info("Loading settings", {settings_file_location: self.__settings_file_location});
		var _buff = buffer_load(self.__settings_file_location);
		var _str = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
		
		var _data = json_parse(_str);
		if (self.version == _data[$ "version"]) {
			struct_foreach(_data, function(_key, _value) {
				self.__settings[$ _key] = _value;
			});
		}
	}
	
	static set = function(_key, _value) {
		self.__settings[$ _key] = _value;
		self.__save();
	}
	
	static get = function(_key) {
		return self.__settings[$ _key] 
	}
	
	static __save = function() {
		LOGGER.info("Saving settings", {settings_file_location: self.__settings_file_location});
		var _json = json_stringify(self.__settings);
		var _buff = buffer_create(string_byte_length(_json), buffer_fixed, 1);
		buffer_write(_buff, buffer_text, _json);
		buffer_save(_buff, self.__settings_file_location);
		buffer_delete(_buff);
	}
	
	static __get_env = function(_env_name, _default) {
		var _env = environment_get_variable(_env_name);
		return _env == "" ? _default : _env;
	}
}
