/*
	File: CoalaOsFileStructure.sqf
	Creator: J. Schmidt
	Date: 01-10-2023
*/

coala_FileSystem = [
	["C:", 0, 0, [1, 2, 3], 1],
	["Programs", 1, 0, [15, 16, 17, 18, 19], 1],
	["Windows", 2, 0, [], 1],
	["Users", 3, 0, [4], 1],
	["root", 4, 3, [5, 6, 7, 8, 9, 10], 1],
	["Desktop", 5, 4, [], 1, nil, "desktop"],
	["Documents", 6, 4, [], 1, nil, "documents"],
	["Downloads", 7, 4, [], 1, nil, "downloads"],
	["Music", 8, 4, [], 1, nil, "music"],
	["Pictures", 9, 4, [11], 1, nil, "pictures"],
	["Videos", 10, 4, [12, 13, 14], 1, nil, "videos"],
	["image1.jpg", 11, 9, [], 0, MISSION_ROOT + "CoalaOs\Images\tank.jpg", "picture"],
	["video1.mp4", 12, 10, [], 0, "\A3\Missions_F_EPA\video\A_in_intro.ogv", "video"],
	["video2.mp4", 13, 10, [], 0, "\A3\Missions_F_EPA\video\A_hub_quotation.ogv", "video"],
	["video3.mp4", 14, 10, [], 0, "\A3\Missions_F_EPA\video\A_in_quotation.ogv", "video"],
	["Surveillance.exe", 15, 1, [], 0, "CoalaOs\Programs\CoalaOsSurveillance.sqf", "exe", "surveillance"],
	["frontcam.exe", 16, 1, [], 0, "CoalaOs\Programs\CoalaOsFrontcam.sqf", "exe", "frontcam"],
	["BlueforTracker.exe", 18, 1, [], 0, "CoalaOs\Programs\BlueforTracker.sqf", "exe", "bluefortracker"],
	["Chatty.exe", 19, 1, [], 0, "CoalaOs\Programs\CoalaOsChatty.sqf", "exe", "Chatty"],
	["Bodycam.exe", 17, 1, [], 0, "CoalaOs\Programs\CoalaOsBodyCam.sqf", "exe", "bodycam"]
];

coala_ActivePrograms = [];
coala_currentFolderId = 0;
coala_currentFolder = coala_FileSystem select coala_currentFolderId;
coala_currentFolderName = format["%1\", coala_currentFolder select coala_currentFolderId];

fncoala_addFolder = {
	//[FolderName, parentId] call fncoala_addFolder;
	_folderName = _this select 0;
	_parentId = _this select 1;
	_success = "Successfully created the folder.";

	if(count (toArray _folderName) > 0) then {
		_newId = count coala_FileSystem;
		// name, id, parent id, children, isfolder?
		_newFolder = [_folderName, _newId, _parentId, [], 1];
		
		//beim parent einspeichern
		(coala_FileSystem select _parentId) set [count(coala_FileSystem select _parentId), _newId];
		coala_FileSystem set [count coala_FileSystem, _newFolder];
	} else {
		_success = "Could not create the folder: No name given";
	};
	_return = _success
};

fncoala_getSubFolders = {
	//[FolderId] call fncoala_getSubFolders
	_folderId = _this select 0;
	_subFolderIds = (coala_FileSystem select _folderId) select 3;
	_folders = [];

	{
		_curFolder = coala_FileSystem select _x;
		_folders set [count _folders, _curFolder];
	} forEach _subFolderIds;

	_folders
};

fncoala_getSubFolderIdFromname = {
	//[subFolderName] call fncoala_getSubFolderIdFromname
	_subFolderName = _this select 0;
	_id = -1;

	if(count (toArray _subFolderName) > 0) then {
		_folders = [coala_currentFolderId] call fncoala_getSubFolders;
		{
			if(_x select 0 == _subFolderName) then {
				_didFind = true;
				_id = _x select 1;
			};
		} foreach _folders;
	};

	_id
};

fncoala_getCompleteFolderName = {
	//[folderId] call fncoala_getCompleteFolderName
	_folderId = _this select 0;
	_folder = coala_FileSystem select _folderId;

	while{_folder select 1 != _folder select 2} do {
		_parentFolder = coala_FileSystem select (_folder select 2);
		_fullPath = format["%2\%1", _fullPath, _parentFolder select 0];
		_folder = _parentFolder;
	};

	_fullPath
};

fncoala_getFileWithName = {
	//[fileName] call fncoala_getFileWithName;
	_fileName = _this select 0;
	_fileId = -1;
	_toFindFile = [];

	_allCurFiles = coala_currentFolder select 3;
	{
		_curFile = coala_FileSystem select _x;
		if((_curFile) select 0 == _fileName) then {
			_fileId = _curFile select 1;
			_toFindFile = _curFile;
		};
	} foreach _allCurFiles;

	_toFindFile
};