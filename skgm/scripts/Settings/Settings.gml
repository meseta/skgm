function Settings(_settings_file_location="settings.json") constructor {
	static version = 1;
	self.__settings_file_location = _settings_file_location;
	self.__settings = {
		sentry_dsn: "",
		version: self.version,
	};
	
	// try to load it
	if (file_exists(self.__settings_file_location)) {
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
		var _json = json_stringify(self.__settings);
		var _buff = buffer_create(string_byte_length(_json), buffer_fixed, 1);
		buffer_write(_buff, buffer_text, _json);
		buffer_save(_buff, self.__settings_file_location);
		buffer_delete(_buff);
	}
}
