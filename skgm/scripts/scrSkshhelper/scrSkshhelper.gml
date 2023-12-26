function Skshhelper() constructor {
	static open = function(_file, _id) {
		if (os_type == os_linux) {
			return !!extSkshhelper_open(_file, _id);
		}
		return false;
	}

	static is_open = function(_id) {
		if (os_type == os_linux) {
			return !!extSkshhelper_is_open(_id);
		}
		return false;
	}

	static read = function() {
		if (os_type == os_linux) {
			return extSkshhelper_read();
		}
		return "";
	}

	static close = function(_id) {
		if (os_type == os_linux) {
			return !!extSkshhelper_close(_id);
		}
		return false;
	}
}

// initialize statics
new Skshhelper();