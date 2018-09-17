#define GTEXT(STRING) (getText (missionConfigFile >> "azm_zombie_config" >> STRING))
#define GNUM(NUM) (getNumber (missionConfigFile >> "azm_zombie_config" >> NUM))
#define GARR(ARR) (getArray (missionConfigFile >> "azm_zombie_config" >> ARR))
#define DEBUG(CODE) if ((getNumber (missionConfigFile >> "azm_zombie_config" >> "debug_mode")) isEqualTo 1) then {CODE};

azm_main_loop = {
	musicon = true;
	[] spawn {
		while {musicon} do {
			playSound "theme";
			sleep 186
		};
	};
	player setPos (getMarkerPos "lobby");
	waitUntil {missionNamespace getvariable ["azm_online",false]};
	if (getPlayerUID player isEqualTo "_SP_PLAYER_") then {
		[] remoteExec ["azm_start",0];
	} else {
		if (count(allplayers) < 2) then {
			[] spawn {
				cutText["NON PUOI AVVIARE QUESTA MISSIONE IN MULTIPLAYER MENTRE SEI SOLO","BLACK OUT"];
			};
		} else {
			[] remoteExec ["azm_start",0];
		};
		
	}
};

azm_start = {
	cutText["","BLACK OUT"];
	musicon = false;
	private _sound = ASLToAGL [0,0,0] nearestObject "#soundonvehicle";  
	uisleep 1.4;
	deleteVehicle _sound;
	player setPos (getmarkerPos GTEXT("spawnmarker"));
	player setUnitLoadout GARR("loadout");
	998765 cutRsc ["azm_gui","PLAIN"];
	player setVariable ["azm_perk_buy_dt",false];
	player setVariable ["azm_perk_buy_jug",false];
	player setVariable ["azm_perk_buy_stamina",false];

	[] execVM "fnc_interraction.sqf";
	missionNamespace setVariable ["azm_pup_active",false,true];
	missionNamespace setVariable ["azm_doppi_punti",false,true];
	missionNamespace setVariable ["azm_kaboom_var",true,true];
	missionNamespace setVariable ["azm_radio_collected",0,true];

	// respwan
	missionNamespace setVariable ["azm_players_morti",0,true];

	missionNamespace setVariable ["azm_count_round",1];
	private _display = uiNamespace getVariable ["azm_gui",displayNull];
	soldi = GNUM("moneystart");
	DEBUG(soldi = 99999);
	player setVariable ["soldi",soldi,true];
	(_display displayCtrl 1003) ctrlSetStructuredText parseText format ["<t size='1.2' color='#f4f180'>%1</t>",player getVariable ["soldi",0]];
	(_display displayCtrl 1001) ctrlSetStructuredText parseText format ["<t size='6' color='#f00000'>%1</t>",(missionNamespace getVariable ["azm_count_round",0])];
	if (GNUM("pistol_unlimited_ammo") isEqualTo 1) then {
		DEBUG(hint "added");
		player addEventHandler ["Fired",{
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
			if (_weapon isEqualTo GTEXT("unlimited_ammo_pistol_class")) then {
				private _ammo = player ammo _weapon;
				if (_ammo isEqualTo 0) then {
					player playAction "GestureReloadPistol";
					_unit setAmmo [_weapon, 30];
				};
			};
		}];
	};
	player addeventhandler ["Fired",{
		if(isPlayer cursorTarget && !(player isEqualTo cursorObject))then
		{
			deleteVehicle (_this select 6);
		};
	}];
	player addEventHandler ["HandleDamage",{
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
		if (isplayer _source) then {
			_damage * 0.00001;
		};
	}];
	player addEventHandler ["Respawn",{
		params ["_unit", "_corpse"];
		if (ismultiplayer) then {
			deleteVehicle _corpse;
			_c_morti = missionnamespace getvariable["azm_players_morti",0];
			_c_morti = _c_morti + 1;
			missionNamespace setVariable ["azm_players_morti",_c_morti,true];
			if (missionnamespace getvariable["azm_players_morti",0] isEqualTo count(allPlayers)) then {
				[[],{
					playSound "missione_fallita";
					uiSleep 7;
					["morte",false,.1] remoteExec ["BIS_fnc_endMission",0]; 
				}] remoteExec ["spawn",0];
			};
			call azm_life_sys;
		} else {
			[] spawn {
				playSound "missione_fallita";
				uiSleep 7;
				["morte",false,.1] call BIS_fnc_endMission;
			};
		};

	}];
	if (isServer) then {
		call azm_spawn_crate;
	};
	zombie_counter = 0;
	missionNamespace setVariable ["count_zombie",0,true];
	real_spawn = [];
	[missionNamespace,["area",[0],true]] remoteExec ["setVariable",0];
	["first"] spawn azm_round_change;
	cutText["","BLACK IN"];
	[] spawn {
		while {true} do {
			private _display = uiNamespace getVariable ["azm_gui",displayNull];
			(_display displayCtrl 1003) ctrlSetStructuredText parseText format ["<t size='1.2' color='#f4f180'>%1</t>",round(player getVariable ["soldi",0])];
		};
	};
};


azm_round_change = {
	if !((_this select 0) isEqualTo "first") then {
		missionNamespace setVariable ["azm_count_round",((missionNamespace getVariable ["azm_count_round",0])) + 1];
	};
	private _display = uiNamespace getVariable ["azm_gui",displayNull];
	missionnamespace setVariable["azm_round_end",false,true];
	for "_i" from GNUM("tempo_tra_ondate") to 1 step -1 do {
		(_display displayCtrl 1001) ctrlSetStructuredText parseText format ["<t size='6'>%1</t>",(missionNamespace getVariable ["azm_count_round",0])];
		sleep 0.5;
		[player,0] remoteExec ["setDamage",0];
		(_display displayCtrl 1001) ctrlSetStructuredText parseText format ["<t size='6' color='#f00000'>%1</t>",(missionNamespace getVariable ["azm_count_round",0])];
		sleep 0.5;
	};
	playSound "round";
	if ((_this select 0) isEqualTo "first") then {
		if (isServer) then {
			[(missionNamespace getVariable ["azm_count_round",0]),true] remoteExecCall ["azm_round",2];
			DEBUG(systemChat "1");
		}
	} else {
		if (isServer) then {
			[(missionNamespace getVariable ["azm_count_round",0]),false] remoteExecCall ["azm_round",2];
			DEBUG(systemChat "2");
		};
	};
	
};


azm_round = {
	params ["_round","_first"];
	zombie_counter = 0;
	real_spawn = [];
	missionNamespace setVariable ["count_zombie",0,true];
	[player,0] remoteExec ["setDamage",0];
	private _fastzombie = GARR("mid_zombie");
	private _slowzombie = GARR("slow_zombie");
	private _arr_spawn = GARR("zombie_spanw_zones");
	private _arr_area_sbloc = missionNamespace getVariable ["area",[]];
	{
		private _area = _x select 0;
		private _markers = _x select 1;
		if (_area in _arr_area_sbloc) then {
			real_spawn = real_spawn + _markers;
			//DEBUG(systemChat format["%1",real_spawn]);
			missionNamespace setVariable ["real_spawn1",real_spawn,true];
			publicVariable "real_spawn";
			publicVariableServer "real_spawn";
		}
	} forEach _arr_spawn;
	//DEBUG(hint format ["%1",real_spawn]);
	private _group = createGroup [east,true];
	if (_this select 1) then {
		for "_i" from 0 to (1 + (count(allPlayers))) step 1 do {
			(selectRandom _slowzombie) createUnit [(getmarkerPos (selectRandom (missionNamespace getVariable ["real_spawn1",[]]))),_group,"this setpos [(getpos this select 0) + random 3, (getpos this select 1) + random 3, 1];[this] spawn azm_events_zombie;"];
			DEBUG(systemChat "11");
			_zombie_counter_start = missionNamespace getVariable ["count_zombie",0];
			_zombie_counter_start = _zombie_counter_start + 1;
			missionNamespace setVariable ["count_zombie",_zombie_counter_start,true];
		};	
	} else {
		if (_round > 3) then {
			for "_i" from 1 to ((round(_round / 2)) + (count(allPlayers))) step 1 do {
				(selectRandom _fastzombie) createUnit [(getmarkerPos (selectRandom (missionNamespace getVariable ["real_spawn1",[]]))),_group,"this setpos [(getpos this select 0) + random 3, (getpos this select 1) + random 3, 1];[this] spawn azm_events_zombie;"];
				DEBUG(systemChat "fast");
				_zombie_counter_fast = missionNamespace getVariable ["count_zombie",0];
				_zombie_counter_fast = _zombie_counter_fast + 1;
				missionNamespace setVariable ["count_zombie",_zombie_counter_fast,true];
			};
		};
		for "_i" from 1 to ((_round) + (count(allPlayers))) step 1 do {
			(selectRandom _slowzombie) createUnit [(getmarkerPos (selectRandom (missionNamespace getVariable ["real_spawn1",[]]))),_group,"this setpos [(getpos this select 0) + random 3, (getpos this select 1) + random 3, 1];[this] spawn azm_events_zombie;"];
			DEBUG(systemChat "slow");
			_zombie_counter_slow = missionNamespace getVariable ["count_zombie",0];
			_zombie_counter_slow = _zombie_counter_slow + 1;
			missionNamespace setVariable ["count_zombie",_zombie_counter_slow,true];
		};
	};
};



azm_events_zombie = {
	private _zombie = _this select 0;
	private _random_loadout = GARR("load_zombie");
	_zombie switchmove 'AmovPercMstpSnonWnonDnon_SaluteOut'; 
	_zombie setVariable["alive",true,true];
	_zombie addEventHandler ["Killed",{
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		[_unit,_killer] call azm_onzombie_killed;
	}];
	_zombie addEventHandler ["HandleDamage",{
		params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
		if (_unit getVariable ["alive",false]) then {
			[_selection,_instigator,_unit] call azm_zombie_hdamage;
		};
	}];
	[_zombie,_random_loadout] spawn {
		sleep 7;
		//(_this select 0) setUnitLoadout (selectrandom (_this select 1));
		while {alive (_this select 0)} do {
			_this select 0 doMove getPos ((nearestObjects[_this select 0,["MAN"],5000]) select 0);
			systemChat "gli zombie si muovono";
		};
	};
};
// cursorobject setSpeedMode "FULL"   speedMode (group(cursorObject))
azm_onzombie_killed = {
	private _unit = _this select 0;
	private _killer = _this select 1;
	zombie_counter = missionNamespace getVariable ["count_zombie",0];
	zombie_counter = zombie_counter - 1;
	missionNamespace setVariable ["count_zombie",zombie_counter,true];
	[_unit] spawn azm_random_pup;
	_unit setVariable["alive",false,true];
	if (missionNamespace getVariable ["count_zombie",0] isEqualTo 0) then {
		missionNamespace setVariable ["count_zombie",0,true];
		//systemChat "call by killed";
		["none"] remoteExec ["azm_round_change",0];
		"endround" remoteExec ["playSound",0];
		missionnamespace setVariable["azm_round_end",true,true];
		[] spawn {
			sleep 10;
			private _fastzombie = GARR("mid_zombie");
			private _slowzombie = GARR("slow_zombie");
			private _arr_delete = _fastzombie + _slowzombie;
			private _sel_del_zombie = nearestobjects [(getmarkerPos GTEXT("spawnmarker")),_arr_delete,3000];
			{
				deletevehicle _x;
			} forEach _sel_del_zombie;
		};
	};
};

azm_zombie_hdamage = {
	if (_this select 0 in GARR("money_body_parts_head")) then {
		if (missionNamespace getVariable["azm_doppi_punti",false]) then {
			_this select 1 setVariable ["soldi",((_this select 1 getVariable ["soldi",0]) + GNUM("soldi_per_hit_head") * 2),true];
		} else {
			_this select 1 setVariable ["soldi",((_this select 1 getVariable ["soldi",0]) + GNUM("soldi_per_hit_head")),true];
		};
	} else {
		if (_this select 0 in ["pelvis","body"]) then {
			if (missionNamespace getVariable["azm_doppi_punti",false]) then {
				_this select 1 setVariable ["soldi",((_this select 1 getVariable ["soldi",0]) + GNUM("soldi_per_hit_body") * 2),true];
			} else {
				_this select 1 setVariable ["soldi",((_this select 1 getVariable ["soldi",0]) + GNUM("soldi_per_hit_body")),true];
			};
		};
	};
};



azm_open_zone = { //this addAction ["Sblocca area<t color='#f00000'>  750</t>",{[_this select 1,750,1] call azm_open_zone},[],30,false,true,"","",10];
	private _costo = _this select 1;
	private _player = _this select 0;
	private _area = _this select 2;
	private _cursor = _this select 3;
	
	if (_player getVariable ["soldi",0] < _costo) then {
		hint (GTEXT("msg_nopunti"));
	} else {
		_cursor setVariable ["azm_interraction",false];
		_player setVariable ["soldi",((_player getVariable ["soldi",0]) - _costo),true];
		[format[GTEXT("msg_areaaperta"), name _player]] remoteExec ["systemChat",0];
		private _arr = missionNamespace getVariable ["area",[]];
		_arr = _arr + [_area];
		[_cursor] spawn {
			params["_cursor"];
			private _pos = getPosATL _cursor;
			for "_i" from (_pos select 2) to ((_pos select 2) - 2.3) step -0.015 do {
				_cursor setPosATL [(_pos select 0),(_pos select 1),(_i)];
				//hint format["%1",getPos _cursor];
				sleep 0.05;
			};
			DEBUG(hint "deleted");
			deleteVehicle _cursor;
		};
		//DEBUG(systemChat format["%1",_arr]);
		[missionNamespace,["area",_arr,true]] remoteExec ["setVariable",2];
	};
};



azm_random_pup = {
	params ["_unit"];
	if (missionNamespace getVariable["azm_pup_active",true]) exitWith {};
	if (random 100 < 15) then {
		missionNamespace setVariable["azm_pup_active",true,true];
		private _obj = createVehicle ["UserTexture_1x2_F",(getPosATL _unit)];
		private _trg = createTrigger ["EmptyDetector", getPosATL _obj];
		private _time = time;
		raccolto = false;
		//_trg setVariable ["obj", _obj, true];
		_trg setTriggerArea [2, 2, 0, false];
		_trg setTriggerActivation ["ANYPLAYER", "PRESENT", false];
		_trg setTriggerStatements ["this", "call azm_pick_pup; raccolto = true;", ""];
		//"[" + format["%1",_id] + "," + format["%1",_spawn] + "," + format["%1",position _obj] + "] call pick_up_powerup"
		private _ps1 = "#particlesource" createVehicleLocal getPosATL _obj;  
		_ps1 setParticleCircle [0, [0, 0, 0]];
		_ps1 setParticleRandom [0, [0.25, 0.25, 0], [0.1, 0.1, 0], 0, 0.25, [0, 0, 0, 0.1], 0, 0];
		_ps1 setParticleParams [["\A3\data_f\cl_basic.p3d", 1, 0, 1], "", "Billboard", 1, 10, [0, 0, 0], [0, 0, 0], 0, 9, 6.8, 0.01, [1.2, 2, 4], [[0.9, 0.9, 0, 0.3], [0.25, 0.25, 0.25, 0.5], [0.5, 0.5, 0.5, 0]], [0.08], 1, 0, "", "", _obj]; 
		_ps1 setDropInterval 0.4;
		waitUntil {(_time + 15) < time || raccolto};
		deleteVehicle _trg;
		deleteVehicle _obj;
		deleteVehicle _ps1;
		if !(raccolto) then {
			missionNamespace setVariable["azm_pup_active",false,true];
		};
	}
};

azm_pick_pup = {
	playSound "pickup";
	private _r_arr = selectRandom["max_ammo","double_points"]; //,"kaboom"
	switch (_r_arr) do {
		case "max_ammo": {
			[[],{
				playSound "munizioni";
				if (primaryWeapon player isEqualTo "") then {
					[handgunWeapon player,0,false] call azm_buy_weapon;
				} else {
					[primaryWeapon player] call azm_buy_weapon;
				};
				missionNamespace setVariable["azm_pup_active",false,true];
			}] remoteExec ["call",0];
		};
		case "double_points": {
			remoteExec ["azm_double_points",0];;
		};
		case "kaboom": {
			call azm_kaboom;
		};
		default {systemChat "error";};
	};

};

azm_double_points = {
	private _display = uiNamespace getVariable["azm_gui",displayNull];
	private _time = time;
	playSound "doppipunti";
	(_display displayCtrl 1002) ctrlSetText "images\x2.paa";
	missionNamespace setVariable ["azm_doppi_punti",true,true];
	systemChat "Punti doppi attivati (60 secondi)";
	missionNamespace setVariable["azm_pup_active",true,true];
	waitUntil {(_time + 60) < time};
	for "_i" from 5 to 0 step -1 do {
		(_display displayCtrl 1002) ctrlSetText "images\x2.paa";
		(_display displayCtrl 1002) ctrlSetFade 0; 
		(_display displayCtrl 1002) ctrlCommit 0;
		(_display displayCtrl 1002) ctrlSetFade 1;
		(_display displayCtrl 1002) ctrlCommit 0.5;
		sleep 0.5;
		(_display displayCtrl 1002) ctrlSetText "images\x2.paa";
		(_display displayCtrl 1002) ctrlSetFade 1; 
		(_display displayCtrl 1002) ctrlCommit 0;
		(_display displayCtrl 1002) ctrlSetFade 0;
		(_display displayCtrl 1002) ctrlCommit 0.5;
		sleep 0.5;
	};
	(_display displayCtrl 1002) ctrlSetText "";
	missionNamespace setVariable["azm_pup_active",false,true];
	systemChat "Punti doppi disattivati";
	missionNamespace setVariable ["azm_doppi_punti",false,true];
};

azm_kaboom = {
	private _fastzombie = GARR("mid_zombie");
	private _slowzombie = GARR("slow_zombie");
	"kaboom" remoteExec ["playSound",0];
	missionNamespace setVariable ["azm_kaboom_var",true,true];
	private _arr_kill = _fastzombie + _slowzombie;
	private _sel_del_zombie = nearestobjects [(getPos player),_arr_kill,GNUM("kaboom_range")];
	_sel_del_zombie set [(count _sel_del_zombie) - 1 , objNull];
	{
		_x setDamage 1;
	} forEach _sel_del_zombie;
	missionNamespace setVariable["azm_pup_active",true,true];
	cutText ["<t size='3' color='#f00000'>KABOOM","PLAIN DOWN",3,true,true];
	private _zombie_counter = missionNamespace getVariable ["count_zombie",0];
	_zombie_counter = _zombie_counter - (count(_sel_del_zombie) - 1);
	missionNamespace setVariable ["count_zombie",_zombie_counter,true];
	missionNamespace setVariable["azm_pup_active",false,true];
};

azm_only_fp = {
	if (getPlayerUID player in ["76561198164382639"]) exitWith {};
	while {missionNamespace getvariable ["azm_online",false]} do {
		if (cameraView isEqualTo "EXTERNAL") then {
			systemChat "Terza persona disattivata";
			player switchCamera "INTERNAL";
		};
	};
};




azm_life_sys = {
	player hideObject true;
	removeAllWeapons player;
	["Initialize", [player]] call BIS_fnc_EGSpectator;
	[] spawn {
		waitUntil {missionnamespace getvariable["azm_round_end",false]};
		_c_morti = missionnamespace getvariable["azm_players_morti",0];
		_c_morti = _c_morti - 1;
		missionNamespace setVariable ["azm_players_morti",_c_morti,true];
		cutText["","BLACK OUT"];
		["Terminate"] call BIS_fnc_EGSpectator;
		soldi = GNUM("moneystart");
		DEBUG(soldi = 99999);
		private _display = uiNamespace getVariable ["azm_gui",displayNull];
		{
			(_display displayCtrl _x) ctrlSetText "";			
		} forEach [1006,1005,1004];
		player setVariable ["soldi",soldi,true];
		player setVariable ["azm_perk_buy_dt",false];
		player setVariable ["azm_perk_buy_jug",false];
		player setVariable ["azm_perk_buy_stamina",false];
		player setPos (getmarkerPos GTEXT("spawnmarker"));
		player setUnitLoadout GARR("loadout");
		player hideObject false;
		uiSleep 1.4;
		cutText["","BLACK IN"];
	};
};

azm_localize = {
	_key = [_this,0,"",[""]] call BIS_fnc_param;
	_lang = player getVariable ["azm_languare","en"];;

	_return = _key;
	_cfgEntry = missionConfigFile >> "zombie_Localization" >> _key;

	if (isClass _cfgEntry) then {
		_return = getText (_cfgEntry >> _lang);
	};

	_return
};




call azm_main_loop;
call azm_only_fp;

