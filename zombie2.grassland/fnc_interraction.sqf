#define GTEXT(STRING) (getText (missionConfigFile >> "azm_zombie_config" >> STRING))
#define GNUM(NUM) (getNumber (missionConfigFile >> "azm_zombie_config" >> NUM))
#define GARR(ARR) (getArray (missionConfigFile >> "azm_zombie_config" >> ARR))
#define DEBUG(CODE) if ((getNumber (missionConfigFile >> "azm_zombie_config" >> "debug_mode")) isEqualTo 1) then {CODE};
waituntil {!(IsNull (findDisplay 46))};




(findDisplay 46) displayAddEventHandler ["KeyDown",{
	if (_this select 1 == 33) then {call azm_key_pressed};
}];

azm_key_pressed = {
	/*
	//   weapon
		this setVariable ["azm_interraction",true];
		this setVariable ["azm_type","weapon"];
		this setVariable ["azm_w_price",10];
		this setVariable ["azm_w_class","fow_w_k98"];
		this setVariable ["azm_w_name","K98"];		
	//////////////////////////////////////////////////////
	//	area				this addAction ["Sblocca area<t color='#f00000'>  750</t>",{[_this select 1,750,1] call azm_open_zone},[],30,false,true,"","",10];
		this setVariable ["azm_interraction",true];
		this setVariable ["azm_type","area"];
		this setVariable ["azm_a_price",10];
		this setVariable ["azm_a_zone",1];
	//////////////////////////////////////////////////////
	//	perk
		this setVariable ["azm_interraction",true];
		this setVariable ["azm_type","perk"];
		this setVariable ["azm_p_perk","Stamina"];

		/// types of perk   "Double Tap"		"Juggernout"		"Stamina"
	//////////////////////////////////////////////////////
	// random crate
		this setVariable ["azm_interraction",true];
		this setVariable ["azm_type","rc"];
	//////////////////////////////////////////////////////
	// Easter Egg
		this setVariable ["azm_interraction",true];
		this setVariable ["azm_type","ee"];
		this setVariable ["azm_e_type","radio"];
	//////////////////////////////////////////////////////
	*/
	private _cursor = cursorObject;
	if !(active) exitWith {};
	if !(_cursor getVariable["azm_interraction",false]) exitWith {};
	switch (_cursor getvariable["azm_type",""]) do {
		case "weapon": { //_objw setVariable ["azm_w_fromcrate",true];
			if ((primaryWeapon player) == (_cursor getVariable ["azm_w_class",""])) then {
				[_cursor getVariable["azm_w_class",""],round((_cursor getVariable["azm_w_price",0]) * 0.4)] call azm_buy_weapon;
			} else {
				[_cursor getVariable["azm_w_class",""],_cursor getVariable["azm_w_price",0]] call azm_buy_weapon;
			};
		};
		case "area": {
			[player,_cursor getVariable ["azm_a_price",0],_cursor getVariable ["azm_a_zone",0],_cursor] call azm_open_zone;
		};
		case "perk": {
			switch (_cursor getvariable["azm_p_perk",""]) do {
				case "Double Tap": {
					[GNUM("costo_perk_dt")] call azm_perk_dt;
				};
				case "Juggernout": {
					[GNUM("costo_perk_jug")] call azm_perk_jug;
				};
				case "Stamina": {
					[GNUM("costo_perk_stamina")] call azm_perk_stamina;
				};
				default {};
			};
		};
		case "ee": {
			_cursor setVariable ["azm_interraction",false,true];
			switch (_cursor getvariable ["azm_e_type",""]) do {
				case "radio": {
					call azm_ee_radio;
					deleteVehicle _cursor;
				};
				default {};
			};
		};
		case "rc": {
			_cursor setVariable ["azm_interraction",false,true];
			[_cursor] spawn azm_crate_start;
		};
		case "weapon_crate": {
			[_cursor] call azm_buy_w_crate;
		};
		default {if (true) exitWith {}};
	};
	[] spawn {
		interraction_off = true;
		sleep 3;
		interraction_off = false; 
	};
};





interraction_off = false;
while {true} do {
	_display = uiNamespace getVariable ["azm_gui",displayNull];
	_control = _display displayCtrl 1008;
	if !(interraction_off) then {
		typex = "nothing";
		cursor = cursorObject;
		active = false;
		if (player distance cursor < 3) then {
			if (cursor getVariable["azm_interraction",false]) then {
				switch (cursor getvariable["azm_type",""]) do {			//[""] call azm_localize
					case "area": {
						price = cursor getVariable ["azm_a_price",0];
						textx = parseText format [(["STR_AREA_UNLOCK_TEXT"] call azm_localize),price];
						active = true;
					};
					case "weapon": { //
						namex = (getText (configfile >> "CfgWeapons" >> (cursor getVariable["azm_w_class",""]) >> "displayName"));
						if (namex isEqualTo "") then {
							namex = cursor getVariable["azm_w_name",""];	
						};
						if !(cursor getVariable ["azm_w_fromcrate",false]) then {
							if (primaryWeapon player == cursor getVariable ["azm_w_class",""]) then {
								price = round((cursor getVariable["azm_w_price",0]) * 0.4);
								textx = parseText format [(["STR_WEAPON_BUY_AMMO_TEXT"] call azm_localize),namex,price];
							} else {
								price = round(cursor getVariable["azm_w_price",0]);		
								textx = parseText format [(["STR_WEAPON_BUY_TEXT"] call azm_localize),namex,price];					
							};
						} else {
							price = round(cursor getVariable["azm_w_price",0]);		
							textx = parseText format [(["STR_WEAPON_BUY_TEXT"] call azm_localize),namex,price];
						};
						active = true;
					};
					case "perk": {
						switch (cursor getvariable["azm_p_perk",""]) do {
							case "Double Tap": {
								namex = cursor getvariable["azm_p_perk",""];
								price = GNUM("costo_perk_dt");
							};
							case "Juggernout": {
								namex = cursor getvariable["azm_p_perk",""];
								price = GNUM("costo_perk_jug");
							};
							case "Stamina": {
								namex = cursor getvariable["azm_p_perk",""];
								price = GNUM("costo_perk_stamina");
							};
							default {textx = parseText format[""]; active = false;};
						};
						textx = parseText format [(["STR_PERK_BUY_TEXT"] call azm_localize),namex,price];
						active = true;
					};
					case "ee": {
						switch (cursor getvariable["azm_e_type",""]) do {
							case "radio": {
								textx = parseText format [(["STR_EE_RADIO_TEXT"] call azm_localize)];
							};
							default {textx = parseText format[""]; active = false;};
						};
						active = true;
					};
					case "rc": {
						textx = parseText format [(["STR_RC_CRATE_TEXT"] call azm_localize),GNUM("random_crate_price")];
						active = true;
					};
					case "weapon_crate": {
						textx = parseText format [(["STR_WEAPON_CRATE_TEXT"] call azm_localize)];
						active = true;
					};
					default {textx = parseText format[""]; active = false;};
				};
			};
		} else {textx = parseText format[""]; active = false;};
	} else {
		textx = parseText format[""]; active = false;
	};
	_control ctrlSetStructuredText textx;
	sleep 0.2;
};

/*
_light = "#lightpoint" createvehicle (getPos this); 
_light setlightbrightness 0.3; 
_light setlightcolor [1,1,1];
this addAction ["PERK DOUBLE TAP<t color='#f00000'>   1500</t>",{call azm_perk_dt},[],30,false,true,"","",3];
this addAction ["PERK STAMINA<t color='#f00000'>   2000</t>",{call azm_perk_stamina},[],30,false,true,"","",3];
this addAction ["PERK JUGGERNOUT<t color='#f00000'>   2000</t>",{call azm_perk_jug},[],30,false,true,"","",3];
*/

