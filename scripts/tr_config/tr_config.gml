//Root folder in which all translation files are stored. Must be part of the included files
#macro TR_LOCALE_DIRECTORY ".\\locales"

//0-indexed position for the column that contains all internationalization entry keys
#macro TR_ENTRY_KEYS_COLUMN 0

//0-indexed position for the row that contains all internationalization locale IDs
#macro TR_LOCALE_IDS_ROW 0

//0-indexed position for the first column that contains an internationalization locale ID and locale strings
#macro TR_FIRST_LOCALE_COLUMN 2

//0-indexed position for the first row that contains an internationalization entry key and strings
#macro TR_FIRST_ENTRY_ROW 1

//Fallback string for when things go awry
#macro TR_FALLBACK_STRING "tr_fetch_err!"
