/* 
	written by eugene27.
	server only
    1.3.0
*/

if (isServer) then {

	if (("patrols" call BIS_fnc_getParamValue) != 1) exitWith {};
	
	private ["_index","_taskID","_pos","_task","_trg"];

	_index = 0;

    while {true} do {

		uiSleep 30;

		_index = _index + 1;
		_taskID = "PATROL_" + str _index;

		_pos = [1,false] call prj_fnc_select_position;

		[_taskID,_pos,"ColorEAST",0.7,[[150,150],"ELLIPSE"]] call prj_fnc_create_marker;

		_task = [west, [_taskID], [localize "STR_PATROL_DESCRIPTION", "STR_PATROL_TITLE", ""], _pos, "CREATED", 0, false, "walk"] call BIS_fnc_taskCreate;

		_trg = createTrigger ["EmptyDetector", _pos, true];
		_trg setTriggerArea [150, 150, 0, false, 20];
		_trg setTriggerActivation ["WEST", "PRESENT", false];
		_trg setTriggerStatements ["this", "",""];
		_trg setTriggerTimeout [600, 600, 600, true];

		waitUntil {sleep 5; _taskID call BIS_fnc_taskCompleted || triggerActivated _trg};

		if (triggerActivated _trg) then {
			[_taskID,"SUCCEEDED"] call BIS_fnc_taskSetState;
			[player,["money",(player getVariable "money") + 200]] remoteExec ["setVariable",0];
			uiSleep 2;
		};
	
		[_taskID] call BIS_fnc_deleteTask;
		deleteVehicle _trg;
		deleteMarker _taskID;
	};
};