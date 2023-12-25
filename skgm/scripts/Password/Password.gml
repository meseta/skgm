function Password(_password_file_location="password") constructor {
	self.__password_file_location = _password_file_location;
	self.__password_hash = undefined;
	
	// try to load it
	if (file_exists(self.__password_file_location)) {
		var _buff = buffer_load(self.__password_file_location);
		self.__password_hash = buffer_read(_buff, buffer_text);
		buffer_delete(_buff);
	}
	
	static has_password = function() {
		return !is_undefined(self.__password_hash);	
	}
	
	static check_password = function(_password) {
		return self.has_password() && self.__hash_password(_password) == self.__password_hash;	
	}
	
	static set_password = function(_password) {
		self.__password_hash = self.__hash_password(_password);
		
		var _buff = buffer_create(string_byte_length(self.__password_hash), buffer_fixed, 1)
		buffer_write(_buff, buffer_text, self.__password_hash);
		buffer_save(_buff, self.__password_file_location);
		buffer_delete(_buff);
	}
	
	static __hash_password = function(_password) {
		return sha1_string_utf8(_password);	
	}
}
