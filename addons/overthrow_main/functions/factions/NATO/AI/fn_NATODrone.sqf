_this spawn {
    private _drone = _this;
    private _targets = [];
    while {sleep 10; alive _drone} do {
        {
            if((damage _x) < 1) then {
                [_x,_drone,_targets] call {
                    params ["_x","_drone","_targets"];
                    private _ty = typeof _x;
                    if((_x isKindOf "StaticWeapon") && (side _x != west)) exitWith {
                        if(([_drone, "VIEW"] checkVisibility [position _drone,position _x]) > 0) then {
                            _targets pushback ["SW",position _x,100,_x];
                        };
                    };
                    if(_ty isEqualTo OT_flag_IND) exitWith {
                        _targets pushback ["FOB",position _x,0,_x];
                    };
                    if(_ty isEqualTo OT_warehouse) exitWith {
                        if(_x call OT_fnc_hasOwner) then {
                            _targets pushback ["WH",position _x,80,_x];
                        };
                    };
                    if(_ty isEqualTo OT_policeStation) exitWith {
                        _targets pushback ["PS",position _x,90,_x];
                    };
                    if(_ty isEqualTo OT_workshopBuilding) exitWith {
                        _targets pushback ["WS",position _x,50,_x];
                    };
                    if(((_x isKindOf "Car") || (_x isKindOf "Air") || (_x isKindOf "Ship")) && !(_ty in (OT_allVehicles+OT_allBoats+OT_helis))) exitWith {
                        if !(side _x isEqualTo west) then {
                            if(([_drone, "VIEW"] checkVisibility [position _drone,position _x]) > 0) then {
                                _targets pushback ["V",position _x,0,_x];
                            };
                        };
                    };
                    if(_ty isEqualTo OT_item_Storage) exitWith {
                        if(([_drone, "VIEW"] checkVisibility [position _drone,position _x]) > 0) then {
                            _targets pushback ["AMMO",position _x,25,_x];
                        };
                    };
                };
            };
        }foreach((_drone nearObjects ["Static",500]) + (_drone nearObjects ["AllVehicles",500]));
        _drone setVariable ["OT_seenTargets",_targets,false];
    };
};
