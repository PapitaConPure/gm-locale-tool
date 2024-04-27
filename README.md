# Locale Tool
A simple internationalization tool. Supports directories and somewhat-flexible .csv parsing

## Setup
You can tweak some settings in the `tr_config.gml` script.

### Settings
The most important setting for starters is the root directory for all the translations in the game.
```gml
#macro TR_LOCALE_DIRECTORY ".\\locales"
```
By default, it expects a "locales" directory in the included files.
Please note that the `.\\` here means that the path is relative to the `working_directory` (included files). Separate sub-directories with `\\`.

### Locale IDs and entry keys
You define all of these in your CSVs!
* Each column is a locale. There must be a row that specifies the locale ID for each column ("es", "en", "it", "jp", etc)
* The other rows are the individual entries or texts within your game. There must be a column that specifies the entry key for each row ("play", "configs", "help", "jump", "dialog1", etc)
* The order of both the locale IDs and the entry keys doesn't matter. The CSV parser handles all that for you.

## Usage
Imagine we have `"es"` and `"en"` locale IDs for Spanish and English respectively, and the following hierarchy:
```
- menu/
    - main.csv
        - "play"
        - "help"
        - "quit"
    - general.csv
        - "salute"
        - "goodbye"
```

### Initialization
Just add this line somewhere in the first room and make sure it gets executed before any translation.
```gml
//Initialize the system with one of the locale IDs we defined in our CSVs. In this case, English.
tr_system_init("en");
```

### Configuration
```
//Change the current locale to Spanish (as defined in our CSVs)
tr_locale_set("es")
```

### Basics
Use the `tr` function to get the string you want.
```gml
//Show a hi message in the current locale. The CSV files themselves act like directories!
show_message(tr("general/salute"));

//Enter the menu directory, then the main.csv file, and then show the "play" entry...
show_message(tr("menu/main/play"));
```

### Sections
If you use a section (path or file) too much in a certain piece of code, you can change the root section.
```gml
//Set the main.csv file as the root section instead of the locale root
tr_section_set("menu/main");

///...then we can just do this. It's both easier to read and faster to execute
show_message(tr("play"));
show_message(tr("help"));
show_message(tr("quit"));

//...after you're done, remember to reset the root section to the locale root!
tr_section_reset();
```
