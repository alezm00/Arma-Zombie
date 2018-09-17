#define GTEXT(STRING) (getText (missionConfigFile >> "azm_zombie_config" >> STRING))
#define GNUM(NUM) (getNumber (missionConfigFile >> "azm_zombie_config" >> NUM))
#define GARR(ARR) (getArray (missionConfigFile >> "azm_zombie_config" >> ARR))
#define DEBUG(CODE) if ((getNumber (missionConfigFile >> "azm_zombie_config" >> "debug_mode")) isEqualTo 1) then {CODE};

/*
this setVariable ["azm_interraction",true]; 
this setVariable ["azm_type","rc"];
   */


azm_spawn_crate = { // C_IDAP_supplyCrate_F
	private _crate_spawns = [crate_spawn_1,crate_spawn_2,crate_spawn_3];
	private _selected = selectRandom _crate_spawns;
	DEBUG(systemChat str(_selected));
	private _cassa = createVehicle ["C_IDAP_supplyCrate_F",(getPosATL _selected), [], 0, "CAN_COLLIDE"];
	_cassa setDir (getDir _selected);
	clearItemCargoGlobal _cassa;
	_cassa setVariable ["azm_interraction",true,true]; 
	_cassa setVariable ["azm_type","rc",true];
	_cassa setVariable ["azm_cassa_utilizzi",(round(random[3,5,7])),true];
};
azm_crate_start = {
	private _arr_weapons = GARR("random_weapons");
	private _crate = _this select 0;
	private _soldi = player getVariable ["soldi",0];
	if (_soldi < GNUM("random_crate_price")) exitWith {hint "Non hai abbastanza punti"};
	player setVariable ["soldi",(_soldi - GNUM("random_crate_price"))];
	if (_crate getVariable ["azm_cassa_utilizzi",0] isEqualTo 0) exitWith {
		deleteVehicle _crate;
		call azm_spawn_crate;
	};
	_crate setVariable ["azm_cassa_utilizzi",((_crate getVariable["azm_cassa_utilizzi",0]) - 1),true];
	private _win_w = selectRandom _arr_weapons;
	private _random_display = [];
	for "_i" from 0 to 9 do {
		_random_display = _random_display + [(selectRandom _arr_weapons)];
	};
	{
		private _objw = createVehicle [(_x select 0),getPosATL player, [], 0, "CAN_COLLIDE"];
		_objw attachTo [_crate,[0,0,0.5]];
		_objw setVectorDirAndUp [[0,0,1],[0,1,0]];
		_objw setDamage 1;
		_objw enableSimulationGlobal false;
		sleep 0.7;
		deleteVehicle _objw;
	} forEach _random_display;
	private _time = time;
	private _objw = createVehicle [(_win_w select 0),[0,0,0], [], 0, "CAN_COLLIDE"];
	_objw setDamage 1;
	_objw enableSimulationGlobal false;
	_objw attachTo [_crate,[0,0,0.5]];
	_objw setVectorDirAndUp [[0,0,1],[0,1,0]];
	_objw setVariable ["azm_interraction",true,true];
	_objw setVariable ["azm_type","weapon_crate",true];
	_objw setVariable ["azm_w_class",(_win_w select 1),true];
	private _name = (getText (configfile >> "CfgWeapons" >> (_win_w select 1) >> "displayName"));
	if (_name isEqualTo "") then {
		_objw setVariable ["azm_w_name",(_win_w select 2),true];
	} else {
		_objw setVariable ["azm_w_name",_name,true];
	};
	_objw setVariable ["azm_rc_raccolta",false,true];
	waitUntil {(_time + GNUM("time_to_take_weapon")) < time || _objw getVariable ["azm_rc_raccolta",false]};
	deleteVehicle _objw;
	sleep 3;
	_crate setVariable ["azm_interraction",true,true];
};
 

azm_buy_w_crate = {
	params["_cursor"];
	if (_cursor getVariable["azm_w_class",""] == "") exitWith {};
	//playSound "buySound";
	private _primary = primaryWeapon player;
	_cursor setVariable ["azm_rc_raccolta",true,true];
	if !(currentWeapon player isEqualTo "fow_w_p08") then {
		if (_primary != "") then
		{
			_magazineType = getArray(configFile >> "cfgWeapons" >> _primary >> "magazines") select 0;
			player removeMagazines _magazineType;
			hint "primaria";
		};
	};

	_magazineType = getArray(configFile >> "cfgWeapons" >> (_cursor getVariable["azm_w_class",""]) >> "magazines") select 0;
	for "_i" from 0 to GNUM("number_magazines") do
	{
		player addMagazine _magazineType;
	};
	player addWeapon (_cursor getVariable["azm_w_class",""]);
	systemChat format["Hai ottenuto una %1", getText(configFile >> "cfgWeapons" >> (_cursor getVariable["azm_w_class",""]) >> "displayName")];
	
}; 




