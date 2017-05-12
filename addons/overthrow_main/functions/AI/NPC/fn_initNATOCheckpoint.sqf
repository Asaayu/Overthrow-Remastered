private _group = _this;

private _start = getpos ((units _group) select 0);

private _outerRange = 100;
private _innerRange = 20;

private _inrange = [];
private _searching = [];
private _searched = [];
private _gone = [];
private _vehs = [];

private _bargates = _start nearobjects ["Land_BarGate_F",50];

while {!(isNil "_group") and count (units _group) > 0} do {
	_vehs = [];
	_friendly = [];

	private _leader = leader _group;
	{
		_unit = _x;
		_iscar = false;
		if(_unit isKindOf "LandVehicle" and !(side _x == west)) then {
			_unit = driver _unit;
			_iscar = true;
			_f = false;

			if (_vehs find _x == -1) then {
				_vehs pushBack _x;
			};
		};
		if(_unit isKindOf "LandVehicle" and (side _x == west)) then {
			_friendly pushback _x;
		};
		if !(_unit in _inrange or _unit in _searching or _unit in _searched) then {
			if(_unit call unitSeenNATO) then {

				if((isPlayer _unit) and (captive _unit)) then {
					if(_iscar) then {
						_leader globalchat "Please approach the checkpoint slowly, do NOT exit your vehicle";
						_inrange pushback _unit;
					}else{
						[_unit] spawn OT_fnc_NATOsearch;
						_searching pushback _unit;
					};
				};
			};
		};
	}foreach(_start nearentities [["CaManBase","LandVehicle"],_outerRange]);

	if((count _vehs) > 0 or (count _friendly) > 0) then {
		{
			_x animate ["Door_1_rot",1];
		}foreach(_bargates);
	}else{
		{
			_x animate ["Door_1_rot",0];
		}foreach(_bargates);
	};

	_gone = [];
	{
		private _foundillegal = false;
		private _foundweapons = false;
		if(_x distance _start > _outerRange) then {
			//Unit has left the area
			_gone pushback _x;
			if(isPlayer _x and !(_x in _searched)) then {
				_x setCaptive false;
				_x spawn revealToNATO;
			};
		}else{
			_iscar = false;
			_veh = false;

			if(_x distance _start < _innerRange) then {
				if !(_x in _searching or _x in _searched) then {
					if(isPlayer _x) then {
						_searching pushback _x;
						_leader globalchat "Please wait... personal items will be stored in your vehicle";
						if(vehicle _x != _x) then {
							_v = vehicle _x;
							_v setVelocity [0,0,0];
							{
								[_x,_v,true] call dumpStuff;
							}foreach(units _v);
						};
					};
				}else{
					if(isPlayer _x and !(_x in _searched)) then {
						_msg = "Search complete, be on your way";
						_items = [];
						_unit = _x;
						if(vehicle _x != _x) then {
							_v = vehicle _x;
							_v setVelocity [0,0,0];
						};

						_items = (vehicle _x) call OT_fnc_unitStock;

						{
							_cls = _x select 0;
							if(_cls in OT_allWeapons + OT_allMagazines + OT_illegalHeadgear + OT_illegalVests + OT_allStaticBackpacks + OT_allOptics) then {
								_foundweapons = true;
							};
							if(_cls in OT_illegalItems) then {
								_count = _x select 1;
								if(vehicle _unit != _unit) then {
									[_unit,_cls,_count] call CBA_fnc_removeItemCargo;
								}else{
									for "_i" from 1 to _count do {
										_unit removeItem _cls;
									};
								};
								_foundillegal = true;
							};
						}foreach(_items);

						if(primaryWeapon _unit != "") then {_foundweapons = true};
						if(secondaryWeapon _unit != "") then {_foundweapons = true};
						if(handgunWeapon _unit != "") then {_foundweapons = true};

						if(_foundillegal or _foundweapons) then {
							if(_foundweapons) then {
								_msg = "What's this??!?";
								_unit setCaptive false;
								{
									if(side _x == west) then {
										_x reveal [_unit,1.5];
										sleep 0.2;
									};
								}foreach(_unit nearentities ["Man",500]);
							}else{
								_msg = "We found some illegal items and confiscated them, be on your way";
							};
						};
						_msg remoteExec ["OT_fnc_notifyMinor",_x,true];
						_searched pushback _x;
						_searching deleteAt(_searching find _x);
					};
				};
			}else{
				if (_x in _searching and isPlayer _x) then {
					"Return to the checkpoint immediately and wait while you are searched" remoteExec ["OT_fnc_notifyMinor",_x,true];
					_searching deleteAt(_searching find _x);
				}
			};
		};
	}foreach(_inrange);

	{
		_inrange deleteAt (_inrange find _x);
		if(_x in _searched) then {
			_searched deleteAt (_searched find _x);
		};
	}foreach(_gone);
	sleep 2;
};