class azm_gui {
    idd = 1000;
    name = "azm_gui";
    movingenable = false;
    enablesimulation = true;
    duration = 9999999999;
    onLoad = "uiNamespace setVariable ['azm_gui',_this select 0]";
    class controlsBackground
    {
    };
    class controls
    {
        class sfondomoney : RscPicture
        {
            x = 0.823958 * safezoneW + safezoneX;
            y = 0.749783 * safezoneH + safezoneY;
            w = 0.121875 * safezoneW;
            h = 0.046711 * safezoneH;
            idc = 1000;
            text = "";
        };
        class round : RscStructuredText
        {
            x = 0.02552 * safezoneW + safezoneX;
            y = 0.85281 * safezoneH + safezoneY;
            h = 0.16355 * safezoneH;
            w = 0.1015625 * safezoneW;
            idc = 1001;
            text = "";
        };
        class powerup : RscPicture
        {
            x = 0.471354 * safezoneW + safezoneX;
            y = 0.921129 * safezoneH + safezoneY;
            h = 0.077858 * safezoneH;
            w = 0.046871 * safezoneW;
            idc = 1002;
            text = "";
        };
        class money : RscStructuredText
        {
            x = 0.83801 * safezoneW + safezoneX;
            y = 0.755000 * safezoneH + safezoneY;
            h = 0.04671 * safezoneH;
            w = 0.06458 * safezoneW;
            idc = 1003;
            text = "";
            style = 2;
        };
        class perk1 : RscPicture
        {
            x = 0.05572875 * safezoneW + safezoneX;
            y = 0.734152872444012 * safezoneH + safezoneY;
            w = 0.0312508333333333 * safezoneW;
            h = 0.0516309639727361 * safezoneH;
            idc = 1004;
            text = "";
        };
        class perk2 : RscPicture
        {
            x = 0.08697875 * safezoneW + safezoneX;
            y = 0.734152872444012 * safezoneH + safezoneY;
            w = 0.0312508333333333 * safezoneW;
            h = 0.0516309639727361 * safezoneH;
            idc = 1005;
            text = "";
        };
        class perk3 : RscPicture
        {
            x = 0.11822875 * safezoneW + safezoneX;
            y = 0.734152872444012 * safezoneH + safezoneY;
            w = 0.0312508333333333 * safezoneW;
            h = 0.0516309639727361 * safezoneH;
            idc = 1006;
            text = "";
        };
        class perk4 : RscPicture
        {
            x = 0.148957916666667 * safezoneW + safezoneX;
            y = 0.734152872444012 * safezoneH + safezoneY;
            w = 0.0312508333333333 * safezoneW;
            h = 0.0516309639727361 * safezoneH;
            idc = 1007;
            text = "";
        };
        class interraction : RscStructuredText
        {
            x = 0.5507291 * safezoneW + safezoneX;
            y = 0.5428310 * safezoneH + safezoneY;
            h = 0.1372663 * safezoneH;
            w = 0.2078125 * safezoneW;
            idc = 1008;
        };
        class ee1 : RscPicture
        {
            x = 0.83801 * safezoneW + safezoneX;
            y = 0.811075949367089 * safezoneH + safezoneY;
            w = 0.021875 * safezoneW;
            h = 0.0428675754625122 * safezoneH;
            idc = 1009;
            text = "";
        };
        class ee2 : RscPicture
        {
            x = 0.860416666666667 * safezoneW + safezoneX;
            y = 0.811075949367089 * safezoneH + safezoneY;
            w = 0.021875 * safezoneW;
            h = 0.0428675754625122 * safezoneH;
            idc = 1010;
            text = "";
        };
        class ee3 : RscPicture
        {
            x = 0.883333333333333 * safezoneW + safezoneX;
            y = 0.811075949367089 * safezoneH + safezoneY;
            w = 0.021875 * safezoneW;
            h = 0.0428675754625122 * safezoneH;
            idc = 1011;
            text = "";
        };
    };
};

