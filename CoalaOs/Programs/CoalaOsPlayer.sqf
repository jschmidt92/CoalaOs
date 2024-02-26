/*
	File: CoalaOsPlayer.sqf
	Creator: J. Schmidt
	Date: 02.25.2024
*/

params ["_file", "_processId"];

fnCoala_startplayer = {
	_programWindow = [1, 1, 30, 15, _file select 0] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;

	_renderSurface = ["RscVideo", "", 0, 0, 0, 0] call addCtrl;
	[_programWindow select 0, _renderSurface, [0, 0, 30, 15 - 1.5]] call fnCoala_addControlToWindow;
	_renderSurface ctrlSetText format["%1", _file select 5];

	missionNamespace setVariable ["coalaVideoPlayer", _renderSurface, true];
	// hint format["%1", coalaVideoPlayer];
};

fnCoala_stopplayer = {
	missionNamespace getVariable "coalaVideoPlayer";
	coalaVideoPlayer ctrlSetText "";
	missionNamespace setVariable ["coalaVideoPlayer", nil, true];
};

call fnCoala_startplayer;