_width = 62.5;
_height = 27.5;
_standartURL = "https://a3sog.org/portal/fleet-military-surplus";
_newFMSWindow = [-11.25, -4, _width, _height, "Portal - Fleet Military Surplus Store"] call fnCoala_DrawWindow;

_browserCtrl = ["RscText", "", 0, 0, 0, 0] call addCtrl;
_browserCtrl ctrlSetBackgroundColor [0.9, 0.9, 0.9, 1];
_browserCtrl ctrlSetTextColor [0.1, 0.1, 0.1, 1];
[_newFMSWindow select 0, _browserCtrl, [0.2, 1.7, _width - 0.2, _height - 3]] call fnCoala_addControlToWindow;

_url = ["RscEdit", _standartURL, 0, 0, 0, 0] call addCtrl;
_url ctrlSetBackgroundColor [0.25, 0.25, 0.25, 1];
_url ctrlSetTextColor [1, 1, 1, 1];
[_newFMSWindow select 0, _url, [0.4, 0.2, _width - 5.5, 1.5]] call fnCoala_addControlToWindow;

_changeSiteButton = ["RscButton", "Go", 0, 0, 0, 0] call addCtrl;
_changeSiteButton ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
[_newFMSWindow select 0, _changeSiteButton, [_width - 5, 0.2, 5, 1.5]] call fnCoala_addControlToWindow;
_changeSiteButton ctrlAddEventHandler ["MouseButtonDown", {
	_browserCtrl = missionNamespace getVariable format["%1browser", str(_this select 0)];
	_url = missionNamespace getVariable format["%1url", str(_this select 0)];

	_browserCtrl htmlLoad (ctrlText _url);
}];

missionNamespace setVariable [ format["%1browser", str(_changeSiteButton)], _browserCtrl];
missionNamespace setVariable [ format["%1url", str(_changeSiteButton)], _url];

_allControls = [];

{
	_x setVariable ["otherElements", _allControls];
	_x ctrlCommit 0;
	[_x, _allControls] call fnCoala_addVariableToControl;
	[_x, "Basic", "type"] call fnCoala_addVariableToControl;
} foreach _allControls;
_allControls