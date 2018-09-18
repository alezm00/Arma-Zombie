#define GTEXT(STRING) (getText (missionConfigFile >> "azm_zombie_config" >> STRING))
#define GNUM(NUM) (getNumber (missionConfigFile >> "azm_zombie_config" >> NUM))
#define GARR(ARR) (getArray (missionConfigFile >> "azm_zombie_config" >> ARR))
#define DEBUG(CODE) if ((getNumber (missionConfigFile >> "azm_zombie_config" >> "debug_mode")) isEqualTo 1) then {CODE};


azm_perk_zone_sound = { // [(getPos this),"staminup",5] spawn azm_perk_zone_sound;
	params["_pos","_sound","_distance"];
	while {true} do {
		switch (_sound) do {
			case "juggernog": {
				_pos say3D [_sound,_distance];
				sleep 30.41;
			};
			case "doubletap": {
				_pos say3D [_sound,_distance];
				sleep 36.05;
			};
			case "staminup": {
				_pos say3D [_sound,_distance];
				sleep 60;
			};
			default { };
		};
	};	
};


azm_perk_jug = { // 
	params[
		["_prezzo",0,[0]]
	];
	private _soldi = player getVariable ["soldi",0];
	if (player getVariable ["azm_perk_buy_jug",false]) exitWith {hint (["STR_PERK_ALREADY_OWN"]call azm_localize)};
	if (_soldi < GNUM("costo_perk_jug")) exitWith {hint (["STR_PERK_NO_MONEY"]call azm_localize)};
	_soldi = _soldi - GNUM("costo_perk_jug");
	player setVariable ["azm_perk_buy_jug",true];
	player setVariable ["soldi",_soldi,true];
	private _display = uiNamespace getVariable ["azm_gui",displayNull];
	(_display displayCtrl 1004) ctrlSetText "images\juggernog.paa";
	(_display displayCtrl 1004) ctrlSetFade 1; 
	(_display displayCtrl 1004) ctrlCommit 0;
	(_display displayCtrl 1004) ctrlSetFade 0;
	(_display displayCtrl 1004) ctrlCommit 0.5;
	player addEventhandler ["HandleDamage",{
		params ["_unit","_selection","_damage"];
		if (player getVariable ["azm_perk_buy_jug",false]) then {
			_damage * 0.5;
		};
	}];
	hint (["STR_PERK_JUG"] call azm_localize);
};

azm_perk_dt = {
	params[
		["_prezzo",0,[0]]
	];
	private _soldi = player getVariable ["soldi",0];
	if (player getVariable ["azm_perk_buy_dt",false]) exitWith {hint (["STR_PERK_ALREADY_OWN"]call azm_localize)};
	if (_soldi < GNUM("costo_perk_dt")) exitWith {hint (["STR_PERK_NO_MONEY"]call azm_localize)};
	hint (["STR_PERK_DT"] call azm_localize);
	player setVariable ["azm_perk_buy_dt",true];
	_soldi = _soldi - GNUM("costo_perk_dt");
	player setVariable ["soldi",_soldi,true];
	private _display = uiNamespace getVariable ["azm_gui",displayNull];
	(_display displayCtrl 1005) ctrlSetText "images\doubletap.paa";
	(_display displayCtrl 1005) ctrlSetFade 1; 
	(_display displayCtrl 1005) ctrlCommit 0;
	(_display displayCtrl 1005) ctrlSetFade 0;
	(_display displayCtrl 1005) ctrlCommit 0.5;
	doubleTapPerk = findDisplay 46 displayAddEventHandler ["MouseButtonDown", 
	{ if (inputAction "DefaultAction" != 0) then 
		{ 
			[] spawn { 
				while {inputAction "DefaultAction" != 0} do {
					if !(currentWeapon player isEqualTo GTEXT("unlimited_ammo_pistol_class")) then { 
						player forceweaponfire [currentweapon player,"single"]; 
						uiSleep 0.09; 
						player setWeaponReloadingTime [player, currentweapon player, 0]; 
					};
				}; 
			}; 
		}; 
	}];
};

azm_perk_stamina = {
	params[
		["_prezzo",0,[0]]
	];
	private _soldi = player getVariable ["soldi",0];
	if (player getVariable ["azm_perk_buy_stamina",false]) exitWith {hint (["STR_PERK_ALREADY_OWN"]call azm_localize)};
	if (_soldi < GNUM("costo_perk_stamina")) exitWith {hint (["STR_PERK_NO_MONEY"]call azm_localize)};
	player setVariable ["azm_perk_buy_stamina",true];
	hint (["STR_PERK_STAMINA"] call azm_localize);
	_soldi = _soldi - GNUM("costo_perk_stamina");
	player setVariable ["soldi",_soldi,true];
	private _display = uiNamespace getVariable ["azm_gui",displayNull];
	(_display displayCtrl 1006) ctrlSetText "images\staminup.paa";
	(_display displayCtrl 1006) ctrlSetFade 1; 
	(_display displayCtrl 1006) ctrlCommit 0;
	(_display displayCtrl 1006) ctrlSetFade 0;
	(_display displayCtrl 1006) ctrlCommit 0.5;
	player enableFatigue false;
};
//this addAction ["PERK JUGGERNOUT<t color='#f00000'>   2000</t>",{call azm_perk_jug},[],30,false,true,"","",3];




azm_buy_weapon = { //  ["fow_w_g43",100,true] call azm_buy_weapon;
	/*
	_light = "#lightpoint" createvehicle (getPosATL this); 
	_light setlightbrightness 0.3; 
	_light setlightcolor [1,1,1];
	*/
	params[
		["_class","",[""]],
		["_price",0,[0]],
		["_primaria",true,[true]]
		];
	if (_class == "") exitWith {};
	private _soldi = player getVariable ["soldi",0];
	if (_soldi < _price) exitWith {hint format["%1",["STR_PERK_NO_MONEY"] call azm_localize]};
	//playSound "buySound";
	private _primary = primaryWeapon player;
	private _secondary = handgunWeapon player;
	
	if !(currentWeapon player isEqualTo "fow_w_p08") then {
		if (_primary != "" and _primaria) then
		{
			_magazineType = getArray(configFile >> "cfgWeapons" >> _primary >> "magazines") select 0;
			player removeMagazines _magazineType;
		};
	};

	_magazineType = getArray(configFile >> "cfgWeapons" >> _class >> "magazines") select 0;
	if !(currentWeapon player isEqualTo "fow_w_p08" AND _price isEqualTo 0) then {
		for "_i" from 0 to GNUM("number_magazines") do
		{
			player addMagazine _magazineType;
		};
		player addWeapon _class;
	};
	player setVariable ["soldi",(_soldi - _price)];
	if !(_price isEqualTo 0) then {
		systemChat format[(["STR_BUY_WEAPON"] call azm_localize), getText(configFile >> "cfgWeapons" >> _class >> "displayName"), _price];
	} else {
		systemChat format[(["STR_MAX_AMMO"]call azm_localize), getText(configFile >> "cfgWeapons" >> _class >> "displayName")];
	};
	
}; 

