class RscTitles {

	class Default {
       idd = -1;
       fadein = 0;
       fadeout = 0;
       duration = 0;
	};
	class OT_stashHUD
	{
		idd=746;
		movingEnable =  0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration     =  10e10;
        fadein       =  0;
        fadeout      =  0;
		name = "OT_stashHUD";
		onLoad = "with uiNameSpace do { OT_stashHUD = _this select 0 }";
			
		class controls
		{
			////////////////////////////////////////////////////////
			// GUI EDITOR OUTPUT START (by ARMAzac, v1.063, #Jeduvu)
			////////////////////////////////////////////////////////

			class RscListbox_1500: RscListbox
			{
				idc = 1500;
				x = 0.247344 * safezoneW + safezoneX;
				y = 0.225 * safezoneH + safezoneY;
				w = 0.402187 * safezoneW;
				h = 0.55 * safezoneH;
				colorBackground[] = {0,0,0,0.9};
			};
			class RscPicture_1200: RscPicture
			{
				idc = 1200;
				text = "";
				x = 0.654688 * safezoneW + safezoneX;
				y = 0.225 * safezoneH + safezoneY;
				w = 0.237187 * safezoneW;
				h = 0.165 * safezoneH;
				colorBackground[] = {0,0,0,0};
			};
			class RscButton_1600: RscButton
			{
				idc = 1600;
				text = "Buy"; //--- ToDo: Localize;
				x = 0.752656 * safezoneW + safezoneX;
				y = 0.676 * safezoneH + safezoneY;
				w = 0.139219 * safezoneW;
				h = 0.099 * safezoneH;	
				colorBackground[] = {0,0,0,0.8};			
				action = "[] call buy;";
			};
			class RscStructuredText_1100: RscStructuredText
			{
				idc = 1100;
				x = 0.654688 * safezoneW + safezoneX;
				y = 0.4 * safezoneH + safezoneY;
				w = 0.237187 * safezoneW;
				h = 0.265 * safezoneH;
				colorBackground[] = {0,0,0,0.3};
			};
			////////////////////////////////////////////////////////
			// GUI EDITOR OUTPUT END
			////////////////////////////////////////////////////////



		};
	};
    class OT_statsHUD {
        idd = 745;
        movingEnable =  0;
        enableSimulation = 1;
        enableDisplay = 1;
        duration     =  10e10;
        fadein       =  0;
        fadeout      =  0;
        name = "OT_statsHUD";
		onLoad = "with uiNameSpace do { OT_statsHUD = _this select 0 }";
		class controls {
		    class structuredText {
                access = 0;
                type = 13;
                idc = 1001;
                style = 0x00;
                lineSpacing = 1;
				x = safezoneX + (0.8 * safezoneW);
				y = safezoneY + (0.15 * safezoneH);
				w = 0.19 * safezoneW;
				h = 0.1 * safezoneH;
                size = 0.055;//0.020
                colorBackground[] = {0,0,0,0.2};
                colorText[] = {0.34,0.33,0.33,0};//{1,1,1,1}
                text = "";
                font = "PuristaMedium";
					class Attributes {
						font = "PuristaMedium";
						color = "#C1C0BB";//"#FFFFFF";
						align = "RIGHT";
						valign = "top";
						shadow = true;
						shadowColor = "#000000";
						underline = false;
						size = "4";//4
					};
            };
		};
	};
};