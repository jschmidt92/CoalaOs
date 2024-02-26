/*
	File: CoalaOsBFT.sqf
	Creator: J. Schmidt
	Date: 02.25.2024
*/

params ["_parameters", "_processId", "_fileName"];

fnCoala_startbluefortracker = {
	_width = 30;
	_height = 20.25;
	_x = -2;
	_y = 1;

	if (count _parameters > 2) then {
		_x = parseNumber (_parameters select 2);
		_y = parseNumber (_parameters select 3);
	};

	_programWindow = [_x, _y, _width, _height, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;

	_pos = ctrlPosition (_programWindow select 0);
	_prog = ([_processId] call fnCoala_getProgramEntryById);
	_prog set [7, [(_pos select 0) / GUI_GRID_W + GUI_GRID_X, (_pos select 1) / GUI_GRID_H + GUI_GRID_Y]];

	_map = ["RscMapControl", "", 0, 0, 0, 0] call addCtrl;
	[_programWindow select 0, _map, [0, 0, _width, _height - 1.5]] call fnCoala_addControlToWindow;

	_map ctrlAddEventHandler ["Draw", {
		{
			_items = items _x;
			_device = ["SOG_Tablet"];
			if (((playerSide == side _x) || (side player == side _x)) && ((_device findIf { _x in _items } > -1) || ((commander vehicle _x == _x) && (vehicle _x != _x)))) then {
				_name = name _x;
				if ((commander vehicle _x == _x) && (vehicle _x != _x)) then {
					_name = format["%1 - %2", _name, getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "displayname")];
				};
				_this select 0 drawIcon [getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "icon"), [0, 0, 0.7, 0.7], getPos _x, 40, 40, getDir _x, _name, 1, 0.05, "TahomaB", "right"];
			};
		} forEach allUnits;
	}];
	_map ctrlAddEventHandler ["MouseButtonDblClick", {
		// TODO: find a way to add markers that can be deleted by user on map....... cannot find a solution right now..

		/*_WorldCoord = (_this select 0) posScreenToWorld [_this select 2, _this select 3];
			hint format["%1 %2", str(_WorldCoord select 0), str(_WorldCoord select 1)];
			_marker = createMarker [str(_WorldCoord), _WorldCoord];
			_marker setMarkerShape "ICON";
			_marker setMarkerBrush "Solid";
			_marker setMarkerColor "ColorRed";
			_marker setMarkerType "DOT";
			
			_aMarker = vehicleVarName _x;
			_aMarker = createMarkerLocal [_aMarker, _WorldCoord];
			_aMarker setMarkerShapeLocal "ICON";
			_aMarker setMarkerTypeLocal "mil_dot";
		// _aMarker setMarkerTextLocal _unitName;
			_aMarker setMarkerSizeLocal [1, 1];
		// _aMarker setMarkerDirLocal (getDir _x);
			_aMarker setMarkerPosLocal (_WorldCoord);
		// _aMarker setMarkerTextLocal _unitName;
		_aMarker setMarkerColorLocal "ColorGreen";*/
	}];
};

fnCoala_stopbluefortracker = {};

call fnCoala_startbluefortracker;