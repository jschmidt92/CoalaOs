/*
	File: CoalaOsFuncitons.sqf
	Creator: J. Schmidt
	Date: 02.25.2024
*/

fnCoala_excecuteCommandFromNonConsole = {
	_attach = _this select 0;
	if (_attach != "") then {
		_input = ctrlText 1400;
		ctrlSetText [1400, format["%1%2 ", _input, _attach]];
		_returned = [_attach] call fnCoala_excecuteCommand;
		_returned
	};
};

// Führt den übergebenen Command aus.
fnCoala_excecuteCommand = {
	// [command : String] call fnc_excecuteCommand;
	_cmd = _this select 0;
	_commandWithoutParam = _cmd;
	_completeCmd = _cmd;
	_returned = [];
	_parameters = [_cmd] call fnCoala_getParameters;

	if (count _parameters > 0) then {
		_cmd = _parameters select 0;
		_commandWithoutParam = format["%1 %2", _parameters select 0, _parameters select 1];
	};
	_commands = ["cd", "ls", "time", "help", "open", "processes", "close"];
	_commandHelp = [
		"cd - change active directory 'cd [foldername]'",
		"ls - list files in active directory 'ls'",
		"time - shows the current time 'time'",
		"help - displays this list 'help'",
		"open - opens a given file 'open [filename] [parameters]'",
		"processes	- shows all active processes 'processes'",
		"close - closes a given process 'close [process id]' (process id can be found with processes command)"
	];

	if (_cmd == "processes") then {
		_input = ctrlText 1400;
		_CRLF = toString [0x0D, 0x0A];

		_programs = "";

		{
			_programs = format["%1%2%4# %3", _programs, _CRLF, _x select 2, _x select 1];
		} forEach coala_ActivePrograms;

		_attach = format["%1Open processes: %2%1%1%3", _CRLF, _programs, coala_currentFolderName];
		_returned = _attach;
		ctrlSetText [1400, format["%1%2 ", _input, _attach]];
	};
	if (_cmd == "close") then {
		_input = ctrlText 1400;
		_CRLF = toString [0x0D, 0x0A];
		if (count _parameters > 1) then {
			_id = parseNumber format["%1", _parameters select 1];
			_foundArr = [];
			_foundIndex = -1;

			{
				if (format["%1", _id] == format["%1", _x select 1]) then {
					_foundIndex = _forEachIndex;
					breakOut "";
				};
			} forEach coala_ActivePrograms;

			if (_foundIndex != -1) then {
				_foundArr = coala_ActivePrograms deleteAt _foundIndex;
				missionNamespace setVariable [format["coala_ActivePrograms"], coala_ActivePrograms];
				call compile format["[%2] call fnCoala_stop%1", _foundArr select 4, str(_id)];

				_attach = format["%1Process %3 was closed.%1%1%2", _CRLF, coala_currentFolderName, _id];
				_returned = _attach;
				ctrlSetText [1400, format["%1%2 ", _input, _attach]];
			} else {
				_attach = format["%1There is no process with id: %3.%1%1%2", _CRLF, coala_currentFolderName, _id];
				_returned = _attach;
				ctrlSetText [1400, format["%1%2 ", _input, _attach]];
			};
		} else {
			_attach = format["%1Please also add a process id.%1%1%2", _CRLF, coala_currentFolderName];
			_returned = _attach;
			ctrlSetText [1400, format["%1%2 ", _input, _attach]];
		};
	};
	if (_cmd == "open") then {
		_input = ctrlText 1400;
		_CRLF = toString [0x0D, 0x0A];

		if (count _parameters > 0) then {
			_filename = _parameters select 1;
			_file = [_fileName] call fnCoala_getFileWithName;

			if (count _file > 0) then {
				_attach = format["%1Opening File: %2%1%1%3", _CRLF, _filename, coala_currentFolderName];
				_returned = _attach;
				ctrlSetText [1400, format["%1%2 ", _input, _attach]];

				if (count _file > 5) then {
					if (_file select 6 == "video") then {
						_handle = [_file, count coala_ActivePrograms] execVM "CoalaOs\Programs\CoalaOsPlayer.sqf";
						coala_ActivePrograms set [count coala_ActivePrograms, [_handle, count coala_ActivePrograms, format["%1", _file select 0], format["%1", _file select 1], format["%1", "player"]]];
					};
					if (_file select 6 == "exe") then {
						_handle = [_parameters, count coala_ActivePrograms, _file select 0] execVM (format["%1", _file select 5]);
						coala_ActivePrograms set [count coala_ActivePrograms, [_handle, count coala_ActivePrograms, format["%1", _file select 0], format["%1", _file select 1], format["%1", _file select 7], _file, [_commandWithoutParam]]];
					};
					if (_file select 6 == "picture") then {
						_handle = [_file, count coala_ActivePrograms] execVM "CoalaOs\Programs\CoalaOsGallery.sqf";
						coala_ActivePrograms set [count coala_ActivePrograms, [_handle, count coala_ActivePrograms, format["%1", _file select 0], format["%1", _file select 1], format["%1", "player"]]];
					};
				} else {
					_attach = format["%1Error: Could not open file. (File is empty)%1%1%3", _CRLF, _filename, coala_currentFolderName];
					_returned = _attach;
					ctrlSetText [1400, format["%1%2 ", _input, _attach]];
				};
			} else {
				_attach = format["%1Error: No such file in this folder.%1%1%3", _CRLF, _filename, coala_currentFolderName];
				_returned = _attach;
				ctrlSetText [1400, format["%1%2 ", _input, _attach]];
			};
		} else {
			_attach = format["%1Please also add a Filename.%1%1%3", _CRLF, _filename, coala_currentFolderName];
			_returned = _attach;
			ctrlSetText [1400, format["%1%2 ", _input, _attach]];
		};
	};
	if (_cmd == "help") then {
		_input = ctrlText 1400;
		_CRLF = toString [0x0D, 0x0A];

		_toReturn = [_commandHelp] call fnCoala_generateListFromArray;

		_attach = format["%1Availabe Command are:%2%1%1%3", _CRLF, _toReturn, coala_currentFolderName];
		_returned = _attach;
		ctrlSetText [1400, format["%1%2 ", _input, _attach]];
	};
	if (_cmd == "cd") then {
		_input = ctrlText 1400;
		_CRLF = toString [0x0D, 0x0A];

		if (count _parameters > 1) then {
			_id = -1;
			if (_parameters select 1 == "..") then {
				_id = coala_currentFolder select 2;
			} else {
				_id = [_parameters select 1] call fnCoala_getSubFolderIdFromname;
			};

			if (_id != -1) then {
				coala_currentFolderId = _id;
				coala_currentFolder = coala_FileSystem select coala_currentFolderId;
				coala_currentFolderName = format["%1\", [_id] call fnCoala_getCompleteFolderName];
				_attach = format["%1%1%3", _CRLF, _toReturn, coala_currentFolderName];
				_returned = _attach;
				ctrlSetText [1400, format["%1%2 ", _input, _attach]];
			} else {
				_attach = format["%1Could not Find Folder: '%2'%1%1%3", _CRLF, _parameters select 1, coala_currentFolderName];
				_returned = _attach;
				ctrlSetText [1400, format["%1%2 ", _input, _attach]];
			};
		} else {
			_attach = format["%1Could not Find Folder: %2%1%1%3", _CRLF, "''", coala_currentFolderName];
			_returned = _attach;
			ctrlSetText [1400, format["%1%2 ", _input, _attach]];
		};
	};
	if (_cmd == "ls") then {
		_input = ctrlText 1400;
		_CRLF = toString [0x0D, 0x0A];
		_folders = [coala_currentFolderId] call fnCoala_getSubFolders;
		_returned = _folders;
		_folderList = [_folders] call fnCoala_generateListFromFolders;

		if (count _folders == 0) then {
			_folderList = format["%1-Folder is empty-", _CRLF];
		};
		_attach = format["%1%2%2%3", _folderList, _CRLF, coala_currentFolderName];
		ctrlSetText [1400, format["%1%2 ", _input, _attach]];
	};
	if (_cmd == "time") then {
		_input = ctrlText 1400;
		_CRLF = toString [0x0D, 0x0A];

		_hour = floor dayTime;
		_minute = floor ((dayTime - _hour) * 60);
		_second = floor (((((dayTime) - (_hour))*60) - _minute)*60);

		_h = "";
		if (_hour < 10) then {
			_h = "0";
		};
		_m = "";
		if (_minute < 10) then {
			_m = "0";
		};
		_s = "";
		if (_second < 10) then {
			_s = "0";
		};

		_time24 = text format ["%4%1:%5%2:%6%3", _hour, _minute, _second, _h, _m, _s];

		_attach = format["%1%2%1%1%3", _CRLF, _time24, coala_currentFolderName];
		ctrlSetText [1400, format["%1%2 ", _input, _attach]];
		_returned = _attach;
	};
	if (!(_cmd in _commands)) then {
		_CRLF = toString [0x0D, 0x0A];
		_input = ctrlText 1400;

		ctrlSetText [1400, format["%1%2Command %3 is unknown.%2%2%4 ", _input, _CRLF, _cmd, coala_currentFolderName]];
	};

	_returned
};

fnCoala_getProgramEntryById = {
	_returner = [];
	{
		if (str(_x select 1) == str(_this select 0)) then {
			_returner = _x;
		};
	} forEach coala_ActivePrograms;

	_returner
};

fnCoala_removeTopLine = {
	// max line num: 28
	// [currentInput] call fnCoala_getParameters;
	ctrlSetText[2001, "got here"];
	_arr = toArray (_this select 0);
	_CRLF = toString [0x0D, 0x0A];
	_lastTwo = [];
	_lineBreaks = [];

	{
		if (count _lastTwo == 0) then {
			_lastTwo set [0, _x];
		};
		if (count _lastTwo == 1) then {
			_lastTwo set [1, _x];
			if ((toString _lastTwo) == _CRLF) then {
				_lineBreaks set[count _lineBreaks, _forEachIndex];
			};
		};
		if (count _lastTwo == 2) then {
			_lastTwo set [0, _lastTwo select 1];
			_lastTwo set [1, _x];
		};
	} forEach _arr;
	ctrlSetText[2001, (toString _lineBreaks)];
	cutText [(toString _lineBreaks), "PLAIN", 2];
};

fnCoala_getParameters = {
	// [command] call fnCoala_getParameters;
	_command = _this select 0;
	_arr = toArray _command;
	_i = 0;
	_lastFoundIndex = 0;
	_isFirst = true;
	_parameters = [];

	while { _i < count _arr } do {
		if (str(_arr select _i) == "32") then {
			// leerzeichen gefunden -> parameter
			if (_isFirst) then {
				_isFirst = false;
				_lastFoundIndex = _i;
				_parameters set [count _parameters, toString(_arr select[0, _i])];
			} else {
				_parameters set [count _parameters, toString(_arr select[_lastFoundIndex + 1, _i - _lastFoundIndex - 1])];
				_lastFoundIndex = _i;
			};
		};
		if ((_i + 1 == count _arr) && count _parameters > 0) then {
			_parameters set [count _parameters, toString(_arr select[_lastFoundIndex + 1, _i - _lastFoundIndex])];
		};

		_i = _i + 1;
	};
	_parameters
};

fnCoala_generateListFromArray = {
	// [array] call fnCoala_generateListFromArray
	_arr = _this select 0;
	_CRLF = toString [0x0D, 0x0A];
	_arrList = "";

	{
		_arrList = format["%1%2%3", _arrList, _CRLF, _x];
	} forEach _arr;

	_arrList
};

fnCoala_generateListFromFolders = {
	// [folders] call fnCoala_generateListFromFolders
	_folders = _this select 0;
	_CRLF = toString [0x0D, 0x0A];
	_folderList = "";

	{
		if (_x select 4 == 1) then {
			_folderList = format["%1%2#Folder# \%3\", _folderList, _CRLF, _x select 0];
		} else {
			_folderList = format["%1%2# File # \%3", _folderList, _CRLF, _x select 0];
		}
	} forEach _folders;

	_folderList
};

// Holt aus der gesamten Console den letzten Command
fnCoala_getLastInsert = {
	/*lastInsert = [string] call fnc_getLastInsert
		Example:
		awdlkawlkawd cd
		dc dwaklwakldwa
		dc
	cd */

	// alles am anfang trimmen
	private "_arr";
	_arr = toArray(_this select 0);
	reverse _arr;
	_break = false;
	_foundLetter = false;
	_i = 0;

	while { (_i < ((count _arr)-1)) and (!_break) } do {
		_curChar = str (_arr select _i);
		if ((!_foundLetter) and ((str (_arr select _i) != "32"))) then {
			_foundLetter = true;
		};
		if ((str (_arr select _i) == "13") and _foundLetter) then {
			_break = true;
			// found space
		};
		_i = _i + 1;
	};

	_arr resize _i - 1;

	_break = false;
	_foundLetter = false;
	_i = 0;
	_lastFound = 0;
	while { (_i < ((count _arr)-1)) and (!_break) } do {
		_curChar = str (_arr select _i);
		if ((!_foundLetter) and ((str (_arr select _i) != "32"))) then {
			_foundLetter = true;
		};
		if ((str (_arr select _i) == "32") and _foundLetter) then {
			_lastFound = _i;
			// found space
		};
		_i = _i + 1;
	};
	_arr resize _lastFound;
	reverse _arr;

	/*// leerzeichen am ende trimmen
	_i = 0;
	_break = false;
	while { (_i < ((count _arr)-1)) and (!_break) } do {
		_curChar = str (_arr select _i);
		if ((_curChar == "32")) then {
			_break = true;
		};
		_i = _i + 1;
	};

	if (_break) then {
		_arr resize _i - 1;
	};*/
	toString _arr
};