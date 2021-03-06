class CfgOverthrowMissions
{
    class MedicalSupplies
    {
        target = "Town";
        repeatable = 1;
        condition = "params['_inSpawnDistance','_stability'];_inSpawnDistance && _stability < 50";
        script = "\overthrow_main\missions\medicalsupplies.sqf";
        chance = 100;
    };

    class Informant
    {
        target = "Global";
        repeatable = 1;
        condition = "params['_numAbandoned'];_numAbandoned > 0";
        script = "\overthrow_main\missions\informant.sqf";
        chance = 15;
    };

    class FactionWeapons
    {
        target = "Faction";
        repeatable = 1;
        condition = "params['_inSpawnDistance','_standing'];_standing < 50";
        script = "\overthrow_main\missions\factionweapons.sqf";
        chance = 100;
    };

    class Fugitive
    {
        target = "Faction";
        repeatable = 1;
        condition = "params['_inSpawnDistance','_standing'];_inSpawnDistance";
        script = "\overthrow_main\missions\fugitive.sqf";
        chance = 10;
    };
};
