_me = _this select 0;
_killer = _me getVariable "ace_medical_lastDamageSource";

if(isNil "_killer") then {_killer = _this select 1};

if((vehicle _killer) != _killer) then {_killer = driver _killer};

if(_killer call unitSeen) then {
	_killer setVariable ["lastkill",time,true];
};
_town = (getpos _me) call OT_fnc_nearestTown;

if(isPlayer _me) exitWith {};

_civ = _me getvariable "civ";
_garrison = _me getvariable "garrison";
_employee = _me getvariable "employee";
_vehgarrison = _me getvariable "vehgarrison";
_polgarrison = _me getvariable "polgarrison";
_airgarrison = _me getvariable "airgarrison";
_criminal = _me getvariable "criminal";
_crimleader = _me getvariable "crimleader";
_mobster = _me getvariable "mobster";
_mobboss = _me getvariable "mobboss";
_hvt = _me getvariable "hvt_id";

_standingChange = 0;

call {
	if(!isNil "_civ") exitWith {
		_standingChange = -10;
		[_town,-1] call stability;
	};
	if(!isNil "_hvt") exitWith {
		_idx = 0;
		{
			if((_x select 0) == _hvt) exitWith {};
			_idx = _idx + 1;
		}foreach(OT_NATOhvts);
		OT_NATOhvts deleteAt _idx;
		format["A high-ranking NATO officer has been killed"] remoteExec ["OT_fnc_notifyMinor",0,false];
		server setvariable ["NATOresources",0,true];
		[_killer,250] call OT_fnc_experience;
	};
	if(!isNil "_mobboss") exitWith {
		_killer setVariable ["OPFkills",(_killer getVariable ["BLUkills",0])+1,true];
		_mobsterid = _garrison;
		server setVariable [format["mobleader%1",_mobsterid],false,true];
		_active = server getVariable ["activemobsters",[]];
		_t = 0;
		{
			if((_x select 1) == _mobsterid) exitWith {};
			_t = _t + 1;
		}foreach(_active);
		_active deleteAt _t;
		server setVariable ["activemobsters",_active,false];

		_standingChange = 50;
		[_killer,1500] call rewardMoney;
		[_killer,100] call OT_fnc_experience;

		format["The crime leader %1 is dead, camp is cleared",(getpos _me) call BIS_fnc_locationDescription] remoteExec ["OT_fnc_notifyMinor",0,true];
		deleteMarker format ["mobster%1",_mobsterid];
	};
	if(!isNil "_employee") exitWith {
		_pop = server getVariable format["employ%1",_employee];
		if(_pop > 0) then {
			server setVariable [format["employ%1",_mobsterid],_pop - 1,true];
		};
		format["An employee of %1 has died",_employee] remoteExec ["OT_fnc_notifyMinor",0,false];
	};
	if(!isNil "_mobster") exitWith {
		_killer setVariable ["OPFkills",(_killer getVariable ["BLUkills",0])+1,true];
		_mobsterid = _me getVariable "garrison";
		_pop = server getVariable format["crimgarrison%1",_mobsterid];
		if(_pop > 0) then {
			server setVariable [format["crimgarrison%1",_mobsterid],_pop - 1,true];
		};
		_standingChange = 10;
		[_killer,150] call rewardMoney;
		[_killer,25] call OT_fnc_experience;
	};
	if(!isNil "_criminal") exitWith {
		_killer setVariable ["OPFkills",(_killer getVariable ["BLUkills",0])+1,true];
		_pop = server getVariable format["numcrims%1",_town];
		if(_pop > 0) then {
			server setVariable [format["numcrims%1",_town],_pop - 1,true];
		};
		if((random 100) > 50) then {
			[_town,1] call stability;
			format["%1 (+1 Stability)",_town] remoteExec ["OT_fnc_notifyMinor",0,false];
		};
		_standingChange = 1;
		[_killer,10] call rewardMoney;
		[_killer,10] call OT_fnc_experience;
	};
	if(!isNil "_crimleader") exitWith {
		_killer setVariable ["OPFkills",(_killer getVariable ["BLUkills",0])+1,true];
		[_town,10] call stability;
		format["%1 (+10 Stability)",_town] remoteExec ["OT_fnc_notifyMinor",0,false];

		_standingChange = 10;
		_bounty =  server getVariable [format["CRIMbounty%1",_town],0];
		if(_bounty > 0) then {
			[_killer,_bounty] call rewardMoney;
			if(isPlayer _killer) then {
				if(isMultiplayer) then {
					format["%1 has claimed the bounty in %2",name _killer,_town] remoteExec ["OT_fnc_notifyMinor",0,false];
				}else{
					format["You claimed the bounty in %1",_town] call OT_fnc_notifyMinor;
				};
			}else{
				if(side _killer == west) then {
					format["NATO has removed the bounty in %1",_town] remoteExec ["OT_fnc_notifyMinor",0,true];
				}else{
					format["The gang leader in %1 is dead",_town] remoteExec ["OT_fnc_notifyMinor",0,true];
				};
			};
			server setVariable [format["CRIMbounty%1",_town],0,true];
		};

		_leader = server getVariable [format["crimleader%1",_town],false];
		if (typename _leader == "ARRAY") then {
			server setVariable [format["crimleader%1",_town],false,true];
		};
		[_killer,50] call OT_fnc_experience;
	};
	if(!isNil "_polgarrison") exitWith {
		_pop = server getVariable format["police%1",_polgarrison];
		if(_pop > 0) then {
			server setVariable [format["police%1",_polgarrison],_pop - 1,true];
		};
		[_town,-1] call stability;
	};
	if(!isNil "_garrison" or !isNil "_vehgarrison" or !isNil "_airgarrison") then {
		_killer setVariable ["BLUkills",(_killer getVariable ["BLUkills",0])+1,true];
		if(!isNil "_garrison") then {
			server setVariable ["NATOresourceGain",(server getVariable ["NATOresourceGain",0])+1,true];
			_pop = server getVariable [format["garrison%1",_garrison],0];
			if(_pop > 0) then {
				_pop = _pop -1;
				server setVariable [format["garrison%1",_garrison],_pop,true];
			};
			if(_garrison in OT_allTowns) then {
				_town = _garrison;
				[_killer,10] call OT_fnc_experience;
			}else{
				[_killer,25] call OT_fnc_experience;
			};
			if(isPlayer _killer) then {
				_standingChange = -1;
			};
			_townpop = server getVariable [format["population%1",_town],0];
			_stab = -1;
			if(_townpop < 350 and (random 100) > 50) then {
				_stab = -2;
			};
			if(_townpop < 100) then {
				_stab = -3;
			};
			if (_garrison in OT_allTowns) then {
				[_garrison,_stab] call stability;
			};
		};

		if(!isNil "_vehgarrison") then {
			_vg = server getVariable format["vehgarrison%1",_vehgarrison];
			_vg deleteAt (_vg find (typeof _me));
			server setVariable [format["vehgarrison%1",_vehgarrison],_vg,false];
		};

		if(!isNil "_airgarrison") then {
			_vg = server getVariable format["airgarrison%1",_airgarrison];
			_vg deleteAt (_vg find (typeof _me));
			server setVariable [format["airgarrison%1",_airgarrison],_vg,false];
		};
	}else{
		if(side _me == west) then {
			[_town,-1] call stability;
		};
		if(side _me == east) then {
			[_town,1] call stability;
		};
	};
};

if((_killer call unitSeen) or (_standingChange < -9)) then {
	_killer setCaptive false;
	if(vehicle _killer != _killer) then {
		{
			_x setCaptive false;
		}foreach(units vehicle _killer);
	};
};
if(isPlayer _killer) then {
	if (_standingChange == -10) then {
		[_town,_standingChange,"You killed a civilian"] remoteExec ["standing",_killer,true];
	}else{
		[_town,_standingChange] remoteExec ["standing",_killer,true];
	};
};