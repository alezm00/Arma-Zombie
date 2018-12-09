azm_ee_radio = {
	private _display = uiNamespace getVariable ["azm_gui",displayNull];
	private _radio = missionNamespace getVariable ["azm_radio_collected",0];
	_radio = _radio + 1;
	missionNamespace setVariable["azm_radio_collected",_radio,true];
	[[],{
		private _display = uiNamespace getVariable ["azm_gui",displayNull];
		switch (missionNamespace getVariable ["azm_radio_collected",0]) do {
			case 0: {
				(_display displayCtrl 1009) ctrlSetText "";
				(_display displayCtrl 1010) ctrlSetText "";
				(_display displayCtrl 1011) ctrlSetText "";
			};
			case 1: {
				(_display displayCtrl 1009) ctrlSetText "images\ee_radio.paa";
				};
			case 2: {
				(_display displayCtrl 1009) ctrlSetText "images\ee_radio.paa";
				(_display displayCtrl 1010) ctrlSetText "images\ee_radio.paa";
				};
			case 3: {
				(_display displayCtrl 1009) ctrlSetText "images\ee_radio.paa";
				(_display displayCtrl 1010) ctrlSetText "images\ee_radio.paa";
				(_display displayCtrl 1011) ctrlSetText "images\ee_radio.paa";
				};
			default { };
		};
		//nothing here
		{
			(_display displayCtrl _x) ctrlSetFade 1; 
			(_display displayCtrl _x) ctrlCommit 0;
			(_display displayCtrl _x) ctrlSetFade 0;
			(_display displayCtrl _x) ctrlCommit 2;
		} forEach [1009,1010,1011];
	}] remoteExec ["call",0];
	[format[(["STR_EE_RADIO_COLLECT"]call azm_localize),name player]] remoteExec ["systemChat",0];
	if (_radio isEqualTo 3) then {
		"centoquindici" remoteExec ["playSound",0];
		[[],{
			private _display = uiNamespace getVariable ["azm_gui",displayNull];
			missionNamespace setVariable ["azm_radio_collected",0,true];
			(_display displayCtrl 1009) ctrlSetText "";
			(_display displayCtrl 1010) ctrlSetText "";
			(_display displayCtrl 1011) ctrlSetText "";
			{
				(_display displayCtrl _x) ctrlSetFade 1; 
				(_display displayCtrl _x) ctrlCommit 0;
				(_display displayCtrl _x) ctrlSetFade 0;
				(_display displayCtrl _x) ctrlCommit 2;
			} forEach [1009,1010,1011];
		}] remoteExec ["call",0];
	}
};