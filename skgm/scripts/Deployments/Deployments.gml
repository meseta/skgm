
function Deployments(_directory="deployments") constructor {
	self.__directory = _directory;
	self.__metadata_file = _directory+"/deployments.json";
	static metadata_version = 0;
	
	self.__deployments = [];
	self.__deployment_lookup = {};
	self.__current = "";
	
	// try to load historical deployment list
	if (file_exists(self.__metadata_file)) {
		var _buff = buffer_load(self.__metadata_file);
		var _str = buffer_read(_buff, buffer_text);
		var _json = json_parse(_str);
		self.__deployments = _json.deployments;
		self.__current = _json.current;
		
		array_foreach(self.__deployments, function(_deployment) {
			self.__deployment_lookup[$ _deployment.deployment_id] = _deployment;	
		});
		buffer_delete(_buff);
	}
	
	static list = function() {
		return self.__deployments;	
	}
	
	static get = function(_deployment_id) {
		return self.__deployment_lookup[$ _deployment_id];	
	}
	
	static get_current_id = function() {
		return self.__current;	
	}
	
	static has = function(_deployment_id) {
		return struct_exists(self.__deployment_lookup, _deployment_id);	
	}
	
	static remove = function(_deployment_id) {
		var _deployment = self.__deployment_lookup[$ _deployment_id];
		if (!is_undefined(_deployment)) {
			var _deployment_directory = self.__directory + "/" + _deployment_id;
			if (directory_exists(_deployment_directory)) {
				directory_destroy(_deployment_directory);	
			}
			
			struct_remove(self.__deployment_lookup, _deployment_id);
			array_delete(self.__deployments, array_get_index(self.__deployments, _deployment), 1);
			self.__save();
		}
	}
	
	static deploy = function(_deployment_id) {
		var _deployment = self.__deployment_lookup[$ _deployment_id];
		if (!is_undefined(_deployment)) {
			self.__current = _deployment_id;
		}
	}
	
	static add = function(_buffer, _name) {
		self.__ensure_directory();
		
		var _deployment_id = self.__uuid4();
		
		// create directory
		var _deployment_directory = self.__directory + "/" + _deployment_id;
		if (!directory_exists(_deployment_directory)) {
			directory_create(_deployment_directory);	
		}
		
		// save buffer
		var _file = _deployment_directory + "/deployment.AppImage";
		buffer_save(_buffer, _file);
		
		// create metadata
		var _deployment = {
			deployment_id: _deployment_id,
			created: date_current_datetime(),
			name: _name,
			size: buffer_get_size(_buffer),
		}
		
		array_push(self.__deployments, _deployment);
		self.__deployment_lookup[$ _deployment_id] = _deployment;
		self.__current = _deployment_id;
		
		self.__save();
	}
	
	/// Check that the buffer contains a valid AppImage (just a bit of extra safety)
	static check_buffer = function(_buffer) {
		return buffer_peek(_buffer, 0, buffer_u32) == 0x464c457f && // ELF header
			buffer_peek(_buffer, 4, buffer_u32) == 0x00010102 && // 64-bit little endian, ELF v1
			buffer_peek(_buffer, 8, buffer_u32) == 0x00024941; // Appimage type 2
	}
	
	static __save = function() {
		self.__ensure_directory();
		
		var _json = {
			deployments: self.__deployments,
			metadata_version: self.metadata_version,
			current: self.__current,
		}
		var _str = json_stringify(_json);
		var _buff = buffer_create(string_byte_length(_str), buffer_fixed, 1)
		buffer_write(_buff, buffer_text, _str);
		buffer_save(_buff, self.__metadata_file);
		buffer_delete(_buff);	
	}
	
	static __ensure_directory = function() {
		if (!directory_exists(self.__directory)) {
			directory_create(self.__directory);	
		}
	}
	
	static __uuid4 = function() {
		static _sequence = 0;
		_sequence += 1; // sequence avoids getting the same number twice
		
		var _uuid = md5_string_utf8($"{date_current_datetime()}:{get_timer()}:{_sequence}");
		_uuid = string_set_byte_at(_uuid, 13, ord("4"));
		_uuid = string_set_byte_at(_uuid, 17, ord(choose("8", "9", "a", "b")));
		_uuid = string_insert("-", string_insert("-", string_insert("-", string_insert("-", _uuid, 9), 14), 19), 24);
		return _uuid;
	}
}