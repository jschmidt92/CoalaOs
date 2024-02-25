_width = 62.5;
_height = 27.5;
_standartURL = format ["https://a3sog.org/portal/federal-deposit-insurance-corporation/%1", (player getVariable ["bankAccount", 0])];
_newWindow = [-11.25, -4, _width, _height, "Portal - Federal Deposit Insurance Corporation"] call fnCoala_DrawWindow;

_browserCtrl = ["RscText", "", 0, 0, 0, 0] call addCtrl; // idc 1815
_browserCtrl ctrlSetBackgroundColor [0.9, 0.9, 0.9, 1];
_browserCtrl ctrlSetTextColor [0.1, 0.1, 0.1, 1];
[_newWindow select 0, _browserCtrl, [0.2, 1.7, _width - 0.2, _height - 3]] call fnCoala_addControlToWindow;

_pageTitle = ["RscText", "Federal Deposit Insurance Corporation", 0, 0, 0, 0] call addCtrl; // idc 1816
_pageTitle ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _pageTitle, [25, 2.5, _width - 21, _height - 25]] call fnCoala_addControlToWindow;

_bankCtrl = ["RscText", "Bank:", 0, 0, 0, 0] call addCtrl; // idc 1817
_bankCtrl ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _bankCtrl, [23, 2.5, _width - 11, _height - 20.5]] call fnCoala_addControlToWindow;
_bankValue = ["RscText", "", 0, 0, 0, 0, 2023001] call addCtrl; // idc 1818
_bankValue ctrlSetText format ["$%1", (player getVariable ["bank", 0])];
_bankValue ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _bankValue, [30, 2.5, _width - 52, _height - 20.5]] call fnCoala_addControlToWindow;

_cashCtrl = ["RscText", "Cash:", 0, 0, 0, 0] call addCtrl; // idc 1819
_cashCtrl ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _cashCtrl, [23, 2.5, _width - 11, _height - 16.5]] call fnCoala_addControlToWindow;
_cashValue = ["RscText", "", 0, 0, 0, 0] call addCtrl; // idc 1820
_cashValue ctrlSetText format ["$%1", (player getVariable ["cash", 0])];
_cashValue ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _cashValue, [30, 2.5, _width - 52, _height - 16.5]] call fnCoala_addControlToWindow;

_amountCtrl = ["RscText", "Amount:", 0, 0, 0, 0] call addCtrl; // idc 1821
_amountCtrl ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _amountCtrl, [23, 2.5, _width - 11, _height - 12.5]] call fnCoala_addControlToWindow;
_amountValue = ["RscEdit", "", 0, 0, 0, 0] call addCtrl; // idc 1822
_amountValue ctrlSetBackgroundColor [0.25, 0.25, 0.25, 1];
_amountValue ctrlSetTextColor [1, 1, 1, 1];
[_newWindow select 0, _amountValue, [30, 9.5, _width - 52, _height - 26.5]] call fnCoala_addControlToWindow;

_withdrawBtn = ["RscButton", "Withdraw", 0, 0, 0, 0] call addCtrl; // idc 1823
_withdrawBtn ctrlSetBackgroundColor [0, 0, 0, 1];
_withdrawBtn ctrlSetTextColor [1, 1, 1, 1];
[_newWindow select 0, _withdrawBtn, [23, 11.5, _width - 56, _height - 26.5]] call fnCoala_addControlToWindow;
_withdrawBtn ctrlEnable true;
_withdrawBtn ctrlAddEventHandler ["MouseButtonDown", {
	_ctrlCIDC = ctrlIDC _amountValue;
	diag_log format ["%1", _ctrlCIDC];
	hint format ["%1", _ctrlCIDC];
	[_ctrlCIDC] call SOG_ClientModules_fnc_bankWithdraw;
}];

_depositBtn = ["RscButton", "Deposit", 0, 0, 0, 0] call addCtrl; // idc 1824
_depositBtn ctrlSetBackgroundColor [0, 0, 0, 1];
_depositBtn ctrlSetTextColor [1, 1, 1, 1];
[_newWindow select 0, _depositBtn, [34, 11.5, _width - 56, _height - 26.5]] call fnCoala_addControlToWindow;
_depositBtn ctrlEnable true;
_depositBtn ctrlAddEventHandler ["MouseButtonDown", {
	[]call SOG_ClientModules_fnc_bankDeposit;
}];

_pageSubtitle = ["RscText", "Transfer Funds", 0, 0, 0, 0] call addCtrl; // idc 1825
_pageSubtitle ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _pageSubtitle, [23, 10.5, _width - 11, _height - 20.5]] call fnCoala_addControlToWindow;

_accountCtrl = ["RscText", "Account:", 0, 0, 0, 0] call addCtrl; // idc 1826
_accountCtrl ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _accountCtrl, [23, 8.5, _width - 11, _height - 12.5]] call fnCoala_addControlToWindow;
_accountValue = ["RscEdit", "", 0, 0, 0, 0] call addCtrl; // idc 1827
_accountValue ctrlSetBackgroundColor [0.25, 0.25, 0.25, 1];
_accountValue ctrlSetTextColor [1, 1, 1, 1];
[_newWindow select 0, _accountValue, [30, 15.5, _width - 52, _height - 26.5]] call fnCoala_addControlToWindow;

_transferCtrl = ["RscText", "Amount:", 0, 0, 0, 0] call addCtrl; // idc 1828
_transferCtrl ctrlSetTextColor [0, 0, 0, 1];
[_newWindow select 0, _transferCtrl, [23, 10.5, _width - 11, _height - 12.5]] call fnCoala_addControlToWindow;
_transferValue = ["RscEdit", "", 0, 0, 0, 0] call addCtrl; // idc 1829
_transferValue ctrlSetBackgroundColor [0.25, 0.25, 0.25, 1];
_transferValue ctrlSetTextColor [1, 1, 1, 1];
[_newWindow select 0, _transferValue, [30, 17.5, _width - 52, _height - 26.5]] call fnCoala_addControlToWindow;

_transferBtn = ["RscButton", "Transfer", 0, 0, 0, 0] call addCtrl; // idc 1830
_transferBtn ctrlSetBackgroundColor [0, 0, 0, 1];
_transferBtn ctrlSetTextColor [1, 1, 1, 1];
[_newWindow select 0, _transferBtn, [34, 19.5, _width - 56, _height - 26.5]] call fnCoala_addControlToWindow;
_transferBtn ctrlEnable true;
_transferBtn ctrlAddEventHandler ["MouseButtonDown", {
	[]call SOG_ClientModules_fnc_bankTransfer;
}];

_url = ["RscEdit", _standartURL, 0, 0, 0, 0] call addCtrl; // idc 1831
_url ctrlSetBackgroundColor [0.25, 0.25, 0.25, 1];
_url ctrlSetTextColor [1, 1, 1, 1];
[_newWindow select 0, _url, [0.4, 0.2, _width - 5.5, 1.5]] call fnCoala_addControlToWindow;

_changeSiteButton = ["RscButton", "Go", 0, 0, 0, 0] call addCtrl; // idc 1832
_changeSiteButton ctrlSetBackgroundColor [0.1, 0.1, 0.1, 1];
[_newWindow select 0, _changeSiteButton, [_width - 5, 0.2, 5, 1.5]] call fnCoala_addControlToWindow;
_changeSiteButton ctrlAddEventHandler ["MouseButtonDown", {
	_browserCtrl = missionNamespace getVariable format["%1browser", str(_this select 0)];
	_url = missionNamespace getVariable format["%1url", str(_this select 0)];

	_browserCtrl htmlLoad (ctrlText _url);
}];

missionNamespace setVariable [ format["%1browser", str(_changeSiteButton)], _browserCtrl];
missionNamespace setVariable [ format["%1url", str(_changeSiteButton)], _url];