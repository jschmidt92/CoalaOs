/*
	File: CoalaOsMDT.sqf
	Creator: J. Schmidt
	Date: 02.25.2024
*/

params ["_parameters", "_processId", "_fileName"];

fnCoala_startmdt = {
	_width = 46.5;
	_height = 20.25;
	_x = -2;
	_y = 1;

	if (count _parameters > 2) then {
		_x = parseNumber (_parameters select 2);
		_y = parseNumber (_parameters select 3);
	};

	_programWindow = [_x, _y, _width, _height, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;

	_backgroundCtrl = ["RscText", "", 0, 0, 0, 0] call addCtrl;
	_backgroundCtrl ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
	[_programWindow select 0, _backgroundCtrl, [0, 0, _width - 0, _height - 0]] call fnCoala_addControlToWindow;

	_pos = ctrlPosition (_programWindow select 0);
	_prog = ([_processId] call fnCoala_getProgramEntryById);
	_prog set [7, [(_pos select 0) / GUI_GRID_W + GUI_GRID_X, (_pos select 1) / GUI_GRID_H + GUI_GRID_Y]];
};

fnCoala_stopmdt = {};

call fnCoala_startmdt;