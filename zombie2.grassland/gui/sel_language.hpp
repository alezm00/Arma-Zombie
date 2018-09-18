class azm_spawn_sel {
    idd = 1001;
    name = "azm_spawn_sel";
    movingenable = false;
    enablesimulation = true;
    onload = "uiNamespace setVariable ['azm_spawn_sel',_this select 0];";
    class controlsBackground
    {
        class header : RscText
        {
            x = 0.415625 * safezoneW + safezoneX;
            y = 0.33300876338851 * safezoneH + safezoneY;
            h = 0.0262896786757546 * safezoneH;
            w = 0.16875 * safezoneW;
            text = "Made by Alezm <3";
            idc = -1;
            colorbackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])",0.7};
        };
        class sfondo : RscBackground
        {
            idc = 1001;
            x = 0.415625 * safezoneW + safezoneX;
            y = 0.365141187925998 * safezoneH + safezoneY;
            w = 0.16875 * safezoneW;
            h = 0.255598831548199 * safezoneH;
            colorbackground[] = {0,0,0,0.5};
        };
    };
    class controls
    {
        class conferma : RscButton
        {
            x = 0.419270833333333 * safezoneW + safezoneX;
            y = 0.529486449853943 * safezoneH + safezoneY;
            w = 0.161979166666667 * safezoneW;
            h = 0.0392160000000001 * safezoneH;
            idc = 1002;
            action = "call azm_btn_lingua";
            text = "Select";
            colorbackground[] = AZM_VERDE;
            colorbackgroundactive[] = AZM_VERDE_DARK;
            colorfocused[] = AZM_VERDE;
        };
        class lingua : RscCombo
        {
            x = 0.419270833333333 * safezoneW + safezoneX;
            y = 0.468381207400195 * safezoneH + safezoneY;
            w = 0.161458333333333 * safezoneW;
            h = 0.0350000000000001 * safezoneH;
            idc = 1003;
        };
        class text : RscStructuredText
        {
            x = 0.419270833333333 * safezoneW + safezoneX;
            y = 0.37682570593963 * safezoneH + safezoneY;
            h = 0.0856864654333009 * safezoneH;
            w = 0.161979166666667 * safezoneW;
            idc = 1004;
        };
    };
};

class azm_confirm_gui {
    idd = 1002;
    name = "azm_confirm_gui";
    movingenable = false;
    onload = "uiNamespace setVariable ['azm_confirm_gui',_this select 0];";
    enablesimulation = true;
    class controlsBackground
    {
        class header : RscText
        {
            x = 0.370833333333333 * safezoneW + safezoneX;
            y = 0.394352482960078 * safezoneH + safezoneY;
            h = 0.030184518013632 * safezoneH;
            w = 0.222916666666667 * safezoneW;
            text = "Made by Alezm <3";
            idc = -1;
            colorbackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.3843])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.7019])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.8862])",0.7};
        };
        class sfondo : RscBackground
        {
            idc = 1001;
            x = 0.370833333333333 * safezoneW + safezoneX;
            y = 0.429406037000974 * safezoneH + safezoneY;
            w = 0.222916666666667 * safezoneW;
            h = 0.167964946445959 * safezoneH;
            colorbackground[] = {0,0,0,0.5};
        };
    };
    class controls
    {
        class text : RscStructuredText
        {
            x = 0.375520833333333 * safezoneW + safezoneX;
            y = 0.438169425511198 * safezoneH + safezoneY;
            h = 0.0954235637779942 * safezoneH;
            w = 0.213020833333333 * safezoneW;
            idc = 1002;
            text = "";
        };
        class confirm : RscButton
        {
            x = 0.375520833333333 * safezoneW + safezoneX;
            y = 0.547091123661149 * safezoneH + safezoneY;
            w = 0.213020833333333 * safezoneW;
            h = 0.0392160000000001 * safezoneH;
            idc = 1003;
            colorbackground[] = AZM_VERDE;
            colorbackgroundactive[] = AZM_VERDE_DARK;
            colorfocused[] = AZM_VERDE;
            text = "";
            action = "blur ppEffectAdjust [0];blur ppEffectCommit 0.01;closedialog 0;missionNamespace setVariable ['azm_online',true];	removeAllActions cursorObject;";
        };
        class close : RscButton
        {
            x = 0.577083333333333 * safezoneW + safezoneX;
            y = 0.394352482960078 * safezoneH + safezoneY;
            w = 0.0166666666666667 * safezoneW;
            h = 0.030184518013632 * safezoneH;
            idc = 1004;
            text = "X";
            action = "closedialog 0;blur ppEffectAdjust [0]; blur ppEffectCommit 0.01;";
            colorbackground[] = AZM_ROSSO;
            colorbackgroundactive[] = AZM_ROSSO_DARK;
            colorfocused[] = AZM_ROSSO;
        };
    };
};
