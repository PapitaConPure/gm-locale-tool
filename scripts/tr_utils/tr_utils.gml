/**
 * @func tr(key_or_path)
 * @desc Returns a locale string for the specified key or path
 * @param {String} key_or_path locale key, or path to the locale key with each section separated by "/"
 */
function tr(key_or_path) {
	var _provider = __tr_provider_get._tr;
	var _locale = _provider.locale;
	
	var _string = _provider.path;
	var _path = string_split(key_or_path, "/", true);
	var _pl = array_length(_path);
	var _p = 0;
	var _next;
	repeat _pl {
		_next = _path[_p++];
		_string = _string[$ _next];
		if is_undefined(_string) {
			show_debug_message($"Invalid locale key or path '{key_or_path}'");
			return TR_FALLBACK_STRING;
		}
	}
	
	if not is_string(_string) {
		show_debug_message($"Invalid locale key or path '{key_or_path}'");
		return TR_FALLBACK_STRING;
	}
	
	return string(_string);
}

/**
 * @desc Sets the specified section within the current locale as the new root section for faster access.
 *       To reset the root section and use the locale root instead, use tr_section_reset
 * @param {String} path The new root section path, relative to the translation provider's locale root
 */
function tr_section_set(path) {
	var _provider = __tr_provider_get._tr;
	var _locale = _provider.locale;
	
	var _strings = _provider.strings[$ _locale];
	var _section = string_split(path, "/", true);
	var _pl = array_length(_section);
	var _p = 0;
	var _next;
	repeat _pl {
		_next = _section[_p++];
		_strings = _strings[$ _next];
		if is_undefined(_strings) {
			show_debug_message($"Invalid section path '{path}'");
			return false;
		}
	}
	
	if not is_struct(_strings) {
		show_debug_message($"Invalid section path '{path}'");
		return false;
	}
	
	_provider.path = _strings;
	return true;
}

/**
 * @desc Resets the root section path to match the translation provider's locale root
 */
function tr_section_reset() {
	__tr_provider_path_reset();
}

/**
 * @desc Sets the current locale as the root for the translation provider.
 *       Please note that this will also reset the root section path to the new locale root,
 *       so any previous use of tr_section_set will be forgotten
 * @param {String} locale
 */
function tr_locale_set(locale) {
	var _provider = __tr_provider_get._tr;
	_provider.locale = locale;
	__tr_provider_path_reset();
}

/**
 * @desc Sets the current locale as the root for the translation provider
 * @returns {String}
 */
function tr_locale_get(locale) {
	var _provider = __tr_provider_get._tr;
	return _provider.locale;
}
