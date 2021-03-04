Config = {}
Config.DrawDistance = 100.0
Config.MarkerType = 20
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor = { r = 255, g = 0, b = 0}


Config.NeededItem = 'komatialexisferou'
Config.NeededItemAmount = 1
Config.AuthorizedWeapons = {
    {name = 'WEAPON_PISTOL',       price = 22000},
    {name = 'WEAPON_SNSPISTOL',     price = 16500},
    {name = 'WEAPON_STUNGUN', price = 1000}
}

Config.KeyToOpenCarGarage = 38			-- default 38 is E
Config.KeyToOpenHeliGarage = 38			-- default 38 is E
Config.KeyToOpenBoatGarage = 38			-- default 38 is E
Config.KeyToOpenExtraGarage = 38		-- default 38 is E

Config.catsecurityDatabaseName = 'catsecurity'	-- set the exact name from your jobs database for catsecurity

-- catsecurity Car Garage Marker Settings:
Config.catsecurityCarMarker = 2 												-- marker type
Config.catsecurityCarMarkerColor = { r = 50, g = 50, b = 204, a = 100 } 			-- rgba color of the marker
Config.catsecurityCarMarkerScale = { x = 0.5, y = 0.5, z = 1.0 }  				-- the scale for the marker on the x, y and z axis
Config.CarDraw3DText = "Press [E] To open the garage"			-- set your desired text here

--discord logs
Config.DiscordLogs = "WEBHOOK"
-- catsecurity Cars:
Config.catsecurityVehicles = {
		{ model = 'dubsta', label = 'Dubsta'}
}

-- ESX.ShowNotifications:
Config.VehicleParked = "your vehicle is put away!"
Config.NoVehicleNearby = "you don't have a vehicle!"
Config.CarOutFromPolGar = "You took out a ~b~Vehicle~s~ from ~y~catsecurity Garage~s~!"
Config.VehRepNotify = "Your ~b~vehicle~s~ is being ~y~repaired~s~, please wait!"
Config.VehRepDoneNotify = "Your ~b~vehicle~s~ has been ~y~repaired~s~!"
Config.VehCleanNotify = "Your ~b~vehicle~s~ is being ~y~cleaned~s~, please wait!"
Config.VehCleanDoneNotify = "Your ~b~vehicle~s~ has been ~y~cleaned~s~!"

Config.VehicleLoadText = "Wait for vehicle to spawn"			-- text on screen when vehicle model is being loaded

-- Distance from garage marker to the point where /fix and /clean shall work
Config.Distance = 20

Config.DrawDistance      = 100.0
Config.TriggerDistance 	 = 3.0
Config.Marker 			 = {Type = 27, r = 0, g = 127, b = 22}


Config.CarZones = {
	catsecurityCarGarage = {
		Pos = {
			{x = -74.29,  y = -823.31, z = 36.82}
		}
	}
}

Config.catsecurity = {
    House = {
        Blip = {
            Coords = vector3(-65.09, -799.58, 44.23),
            Sprite = 487,
            Display = 4,
            Scale = 1.2,
            Colour = 32
        },
        Cloakrooms = {
            vector3(-82.1, -809.6, 243.39)
        },
        Craft = {
            vector3(-79.95, -811.2, 243.39)
        },
        BossActions = {
            vector3(-81.06, -802.41, 243.4)
        },
        Vault = {
            vector3(-82.42, -806.75, 243.39)
        },
        Armories = {
            vector3(-63.02, -814.64, 243.39)
        },
        Travel = {
            {
                From = vector3(-69.83, -800.63, 44.23),
                To = {coords = vector3(-77.05, -828.33, 243.39), heading = 341.89},
                Marker = {type = 20, x = 0.3, y = 0.2, z = 0.3, r = 255, g = 0, b = 0, a = 100, rotate = true}
            },
            {
                From = vector3(-84.71, -824.47, 36.03),
                To = {coords = vector3(-77.05, -828.33, 243.39), heading = 341.89},
                Marker = {type = 20, x = 0.3, y = 0.2, z = 0.3, r = 255, g = 0, b = 0, a = 100, rotate = true}
            },
            {
                From = vector3(-76.42, -830.06, 243.39),
                To = {coords = vector3(-84.31, -822.89, 36.03), heading = 345.17},
                Marker = {type = 20, x = 0.3, y = 0.2, z = 0.3, r = 255, g = 0, b = 0, a = 100, rotate = true}
            },
            {
                From = vector3(-78.83, -833.13, 243.39),
                To = {coords = vector3(-60.63, -791.09, 44.23), heading = 328.16},
                Marker = {type = 20, x = 0.3, y = 0.2, z = 0.3, r = 255, g = 0, b = 0, a = 100, rotate = true}
            }
        }
    }
}

Config.Uniforms = {
    recruit_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 50,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 65,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        }
    },
    boss_wear = {
        male = {
            ['tshirt_1'] = 7,  ['tshirt_2'] = 2,
			['torso_1'] = 11,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 11,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        }
    }
}