/*
	File: CoalaOsPlayer.sqf
	Creator: J. Schmidt
	Date: 01-10-2023
*/

params ["_file", "_processId"];

fncoala_startplayer = {
	_programWindow = [1, 1, 30, 15, _file select 0] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;

	_renderSurface = ["RscPicture", "", 0, 0, 0, 0] call addCtrl;
	[_programWindow select 0, _renderSurface, [0,0,30,15 - 1.5]] call fnCoala_addControlToWindow;
	_renderSurface ctrlSetText format["%1", _file select 5];

	missionNamespace setVariable ["coalaVideoPlayer", _renderSurface, true];
	// hint format["%1", coalaVideoPlayer];
};

fncoala_stopplayer = {
	missionNamespace getVariable "coalaVideoPlayer";
	coalaVideoPlayer ctrlSetText "";
	missionNamespace setVariable ["coalaVideoPlayer", nil, true];
};

call fncoala_startplayer;