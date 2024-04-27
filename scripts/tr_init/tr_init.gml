/**
 * Initializes the internationalization system with the specified locale.
 * This function should be called once and just once
 */
function tr_system_init(locale) {
	if struct_exists(static_get(__tr_provider_get), "_tr") {
		show_debug_message("Warning! tr_system_init has been called more than once");
		return;
	}
	
	show_debug_message("================================== LOCALE SYSTEM INIT ==================================");
	__tr_provider_get();
	__tr_locales_load_all(TR_LOCALE_DIRECTORY, locale);
	show_debug_message("=================================== LOCALE SYSTEM UP ===================================");
}

#region Provider
function __tr_provider_get() {
	static _tr = {
		locale: "",
		strings: {},
		path: undefined,
	};
	
	return _tr;
}

function __tr_provider_path_reset() {
	var _provider = __tr_provider_get._tr;
	var _locale = _provider.locale;
	_provider.path = _provider.strings[$ _locale];
}
#endregion

#region Load Locales
function __tr_locales_load_all(path, locale) {
	if string_starts_with(path, ".\\") or string_starts_with(path, "./")
		path = working_directory + string_copy(path, 3, string_length(path) - 2);
		
	if not string_ends_with(path, "\\")
		path += "\\";
	
	if not directory_exists(path)
		throw $"Couldn't find locales directory '{path}'. Check the TR_LOCALE_DIRECTORY config in locale_config.gml";
	
	show_debug_message($"Starting on: '{path}'");
	
	__tr_locales_load_directory(path);
	tr_locale_set(locale);
}

function __tr_locales_load_directory(path, section_stack = []) {
	var _tt = string_repeat("\t", array_length(section_stack));
	show_debug_message($"{_tt}Registering directory: '{__tr_relative_path(path)}'");
	show_debug_message($"{_tt}Stack: '{section_stack}'");
	
	var _pending_branches = ds_stack_create();
	
	var _filename = file_find_first(path + "*", fa_directory);
	var _branch_path;
	while(_filename != "") {
		_branch_path = path + _filename;
		
		if directory_exists(_branch_path) {
			_branch_path += "\\";
			show_debug_message($"{_tt}\tRegistering branch: '{__tr_relative_path(_branch_path)}'");
			array_push(section_stack, _filename);
			ds_stack_push(_pending_branches, {
				name: _filename,
				path: _branch_path,
				sections: __tr_array_clone(section_stack),
			});
			array_pop(section_stack);
		} else if string_ends_with(_filename, ".csv") {
			show_debug_message($"{_tt}\tRegistering translation: '{__tr_relative_path(_branch_path)}'");
			__tr_locales_load_from_csv(_branch_path, section_stack);
		}
		
		_filename = file_find_next();
	}
	file_find_close();
	
	show_debug_message($"{_tt}Directory registered. Walking nodes for: '{__tr_relative_path(path)}'");
	
	var _node;
	while(!ds_stack_empty(_pending_branches)) {
		_node = ds_stack_pop(_pending_branches);
		__tr_locales_load_directory(_node.path, _node.sections);
	}
	
	ds_stack_destroy(_pending_branches);
}

///@param {String} path
///@param {Array<String>} section_stack
function __tr_locales_load_from_csv(path, section_stack = []) {
	if !string_ends_with(path, ".csv")
		throw "Expected a CSV locales file";
	
	var _filename_pos = string_last_pos("\\", path) + 1;
	var _filename_len = string_length(path) - _filename_pos - 3;
	var _filename = string_copy(path, _filename_pos, _filename_len);
	var _tr = __tr_provider_get._tr;
	var _file_grid = load_csv(path);
	var _ww = ds_grid_width(_file_grid);
	var _hh = ds_grid_height(_file_grid);
	var _locale, _current_section, _next_section, _s, _key;
	var _xx, _yy;
	
	for(_xx = TR_FIRST_LOCALE_COLUMN; _xx < _ww; _xx++) {
		_locale = _file_grid[# _xx, TR_LOCALE_IDS_ROW];
		_tr.strings[$ _locale] ??= {};
		_current_section = _tr.strings[$ _locale];
		_s = 0;
		repeat(array_length(section_stack)) {
			_next_section = section_stack[_s++];
			_current_section[$ _next_section] ??= {};
			_current_section = _current_section[$ _next_section];
		}
		_current_section[$ _filename] ??= {};
		_current_section = _current_section[$ _filename];
	
		for(_yy = TR_FIRST_ENTRY_ROW; _yy < _hh; _yy++;) {
			_key = _file_grid[# TR_ENTRY_KEYS_COLUMN, _yy];
			_current_section[$ _key] = _file_grid[# _xx, _yy];
		}
	}
}
#endregion

#region Internal utils
function __tr_relative_path(path) {
	return string_replace(path, working_directory, ".\\");
}

function __tr_array_clone(arr) {
	var _l = array_length(arr);
	var _dest = array_create(_l);
	array_copy(_dest, 0, arr, 0, _l);
	return _dest;
}
#endregion
