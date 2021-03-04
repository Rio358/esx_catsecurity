local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData, CurrentActionData, blipscatsecurity, currentTask = {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, hasAlreadyJoined = false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
local isCrafting = false

ESX = nil

Citizen.CreateThread(function() 
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'catsecurity' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

cleanPed = function(ped)
	SetPedArmour(ped, 0)
	ClearPedBloodDamage(ped)
	ResetPedVisibleDamage(ped)
	ClearPedLastWeaponDamage(ped)
	ResetPedMovementClipset(ped, 0)
end

setUniform = function(job, ped)
    TriggerEvent('skinchanger:getSkin', function(skin) 
        if skin.sex == 0 then
            if Config.Uniforms[job].male then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
            else
                exports['mythic_notify']:SendAlert('error', 'No outfit available')
            end
        else
            if Config.Uniforms[job].female then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
            else
                exports['mythic_notify']:SendAlert('error', 'No outfit available')
            end
        end
    end)
end

OpenCraftMenu = function()
    local ped = PlayerPedId()
    local elements = {
        {label = 'Vest', value = 'vest'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'craft', {
        title = 'Craft Menu',
        align = 'top-left',
        elements = elements
    }, function(data, menu) 
            isCrafting = true
            exports['progressBars']:startUI(5000, 'Crafting Bullet Proof')
            TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent('esx_catsecurity:removeItemAddItem', 'bulletproof')
            isCrafting = false
    end, function(data, menu)
        menu.close()
        CurrentAction = 'menu_craft'
        CurrentActionData = {}
    end)
end

RegisterNetEvent('esx_catsecurity:useBulletproof')
AddEventHandler('esx_catsecurity:useBulletproof', function() 
    local playerPed = GetPlayerPed(-1)
    RequestAnimDict("clothingshirt")
    while not HasAnimDictLoaded("clothingshirt") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(PlayerId()), "clothingshirt", "try_shirt_positive_d", 1.0, -1, -1, 50, 0, 0, 0, 0)
    exports['progressBars']:startUI(2000, "Putting on Vest")
    Citizen.Wait(2000)
    SetPedArmour(playerPed, 100)
    StopAnimTask(PlayerPedId(), 'clothingshirt', 'try_shirt_positive_d', 1.0)
    SetPedComponentVariation(GetPlayerPed(-1), 9, 27, 6, 0)
    exports['mythic_notify']:SendAlert('inform', 'Used vest')
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
        if isCrafting then
            DisableAllControlActions(0)
        end
    end
end)

function OpenVaultMenu()

    local elements = {
      {label = "Resource of Bulletproof 7000$", value = 'komatialexisferou'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = ('Shop'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
	  local valor = 0
    
    if data.current.value == "komatialexisferou" then
			valor = 7000
        end
        		
		TriggerServerEvent('esx_catsecurity:shop', data.current.value, valor)
      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = "Press ~INPUT_CONTEXT~ to buy resources"
        CurrentActionData = {}
      end
    )

end

function OpenSocietyActionsMenu()

    local elements = {}
  
    table.insert(elements, {label = ('billing'),    value = 'billing'})
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'catsecurity_actions',
      {
        title    = "Billing",
        align    = 'top-left',
        elements = elements
      },
      function(data, menu)
  
        if data.current.value == 'billing' then
          OpenBillingMenu()
        end    
      end,
      function(data, menu)
  
        menu.close()
  
      end
    )
  
end

function OpenBillingMenu()

    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
      title = ('Billing Amount')
    }, function(data, menu)
      local amount = tonumber(data.value)
  
      if amount == nil or amount < 0 then
        exports['mythic_notify']:SendAlert('error', 'Amount Is Invalid')
      else
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer == -1 or closestDistance > 3.0 then
            exports['mythic_notify']:SendAlert('error', 'No players nearby')
        else
          menu.close()
          TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_catsecurity', ('catsecurity'), amount)
        end
      end
    end, function(data, menu)
      menu.close()
    end)
end

OpenBossActions = function()
    ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'catsecurity', function(data, menu)
		menu.close()

		CurrentAction     = 'menu_boss_actions'
        CurrentActionData = {}
    end, {wash = false})
end

OpenArmoryActions = function()
    local elements = {
        {label = 'Get Weapon', value = 'get_weapon'},
        {label = 'Put Weapon', value = 'put_weapon'},
        { label = 'Withdraw Stock', value = 'get_stock'},
        { label = 'Deposit Stock', value = 'put_stock'},
    }

    if PlayerData.job.grade_name == 'boss' then
        table.insert(elements, {label = ('Buy Weapons'), value = 'buy_weapons'})
      end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title = 'Security Armory',
        align = 'top-left',
        elements = elements
    }, function(data, menu) 
        if data.current.value == 'get_stock' then
            OpenGetStocksMenu()
        elseif data.current.value == 'put_stock' then
            OpenPutStocksMenu()
        elseif data.current.value == 'put_weapon' then
            OpenPutWeaponMenu()
        elseif data.current.value == 'get_weapon' then
            OpenGetWeaponMenu()
        elseif data.current.value == 'buy_weapons' then
            OpenBuyWeaponsMenu()
        end
    end, function(data,menu) 
        menu.close()
        CurrentAction = 'menu_armory'
        CurrentActionData = {station = station}
    end) 
end

Citizen.CreateThread(function()
   while true do
  
     Citizen.Wait(0)

    if IsControlJustReleased(0,  Keys['F6']) and IsJobTrue() and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'catsecurity_actions') then
            OpenSocietyActionsMenu()
    end   
  end
end)

OpenGetStocksMenu = function()
	ESX.TriggerServerCallback('esx_catsecurity:server:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Stock Menu',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = 'Quantity'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					exports['mythic_notify']:SendAlert('Invalid quantity')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_catsecurity:server:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenArmoryActions()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

OpenPutStocksMenu = function()
    ESX.TriggerServerCallback('esx_catsecurity:server:getPlayerInventory', function(inventory) 
        local elements = {}

        for i=1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, {
                    label = item.label .. ' x' .. item.count,
                    type = 'item_standard', 
                    value = item.name
                })
            end
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title = 'Inventory',
            align = 'top-left',
            elements = elements
        }, function(data, menu) 
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                title = 'Quantity'
            }, function(data2, menu2) 
                local count = tonumber(data2.value)

                if not count then
                    exports['mythic_notify']:SendAlert('Invalid quantity')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('esx_catsecurity:server:putStockItems', itemName, count)
                    Citizen.Wait(300)
                    OpenArmoryActions()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu) 
            menu.close()
        end)
    end)
end


function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_catsecurity:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = ('Get Weapon'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_catsecurity:removeArmoryWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end
  
function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'armory_put_weapon',
    {
      title    = ('Put Weapon'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_catsecurity:addArmoryWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenBuyWeaponsMenu()

  ESX.TriggerServerCallback('esx_catsecurity:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #Config.AuthorizedWeapons, 1 do

      local weapon = Config.AuthorizedWeapons[i]
      local count  = 1

      for i=1, #weapons, 1 do
        if weapons[i].name == weapon.name then
          count = weapons[i].count
          break
        end
      end

      table.insert(elements, {label = 'x' .. count .. ' ' .. ESX.GetWeaponLabel(weapon.name) .. ' $' .. weapon.price, value = weapon.name, price = weapon.price})

    end
  
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_buy_weapons',
      {
        title    = ('Buy Weapon'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        ESX.TriggerServerCallback('esx_catsecurity:buy', function(hasEnoughMoney)

          if hasEnoughMoney then
            ESX.TriggerServerCallback('esx_catsecurity:addArmoryWeapon', function()
              OpenBuyWeaponsMenu(station)
            end, data.current.value)
          else
            exports['mythic_notify']:SendAlert('error', 'Not enough money')
          end

        end, data.current.price)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

OpenCloakroomMenu = function()
    local ped = PlayerPedId()
    local grade = PlayerData.job.grade

    local elements = {
        { label = 'Personal Outfit', value = 'citizen_wear'},
        { label = 'Recruit', value = 'recruit_wear'},
    }
    if grade == 2 then
        table.insert(elements, { label = 'Boss Suit', value = 'boss_wear' })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
        title = 'Locker Room',
        align = 'top-left',
        elements = elements
    }, function(data, menu) 
        cleanPed(ped)
        clothes = data.current.value

        if clothes == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin) 
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        elseif clothes == 'recruit_wear' or clothes == 'boss_wear' then
            setUniform(clothes, ped)
        end
    end, function(data, menu) 
        menu.close()
        CurrentAction = 'menu_cloakroom'
        CurrentActionData = {}
    end)
end


Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)

        if PlayerData.job and PlayerData.job.name == 'catsecurity' then
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            local isInMarker, hasExited  = false, false
            local currentStation, currentPart, currentPartNum

            for k,v in pairs(Config.catsecurity) do
                for i=1, #v.Cloakrooms, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true)

                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
                    end
                end
                for i=1, #v.Craft, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.Craft[i], true)
    
                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.Craft[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Craft', i
                    end
                end
                for i=1, #v.BossActions, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.BossActions[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
                    end
                end
                for i=1, #v.Vault, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.Vault[i], true)

                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.Vault[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vault', i
                    end
                end
                for i=1, #v.Armories, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.Armories[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ArmoryActions', i
                    end
                end
            end
            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_catsecurity:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_catsecurity:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_catsecurity:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)

        if CurrentAction then
            ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'catsecurity' then
                if CurrentAction == 'menu_cloakroom' then
                    OpenCloakroomMenu()
                elseif CurrentAction == 'menu_craft' then
                    OpenCraftMenu()
                elseif CurrentAction == 'menu_boss_actions' then
                    OpenBossActions()
                elseif CurrentAction == 'menu_vault' then
                    OpenVaultMenu()
                elseif CurrentAction == 'menu_armory' then
                    OpenArmoryActions()
                end
            end
        end
    end
end)


AddEventHandler('esx_catsecurity:hasEnteredMarker', function(station, part, partNum) 
    if part == 'Cloakroom' then
        CurrentAction = 'menu_cloakroom'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Cloakroom~s~.'
        CurrentActionData = {}
    elseif part == 'Craft' then
        CurrentAction = 'menu_craft'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Craft~s~.'
        CurrentActionData = {}
    elseif part == 'BossActions' then
        CurrentAction = 'menu_boss_actions'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Computer~s~.'
        CurrentActionData = {}
    elseif part == 'Vault' then
        CurrentAction = 'menu_vault'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Shop~s~.'
        CurrentActionData = {}
    elseif part == 'ArmoryActions' then
        CurrentAction = 'menu_armory'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Armory~s~.'
        CurrentActionData = {}
    end
end)

AddEventHandler('esx_catsecurity:hasExitedMarker', function(station, part, partNum) 
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) 
    PlayerData.job = job
    Citizen.Wait(5000)
    TriggerServerEvent('esx_catsecurity:forceCreateBlips')
end)

function Travel(coords, heading)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Citizen.Wait(500)
    end

    ESX.Game.Teleport(playerPed, coords, function() 
        DoScreenFadeIn(800)

        if heading then
            SetEntityHeading(playerPed, heading)
        end
    end)
end

--Travel
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.catsecurity.House.Travel) do
				local distance = #(playerCoords - v.From)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false

					if distance < v.Marker.x then
						Travel(v.To.coords, v.To.heading)
					end
				end
		end
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

-- Blip on Map for Car Garages:
Citizen.CreateThread(function()
	if Config.EnableCarGarageBlip == true then	
		for k,v in pairs(Config.CarZones) do
			for i = 1, #v.Pos, 1 do
				local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
				SetBlipSprite(blip, Config.CarGarageSprite)
				SetBlipDisplay(blip, Config.CarGarageDisplay)
				SetBlipScale  (blip, Config.CarGarageScale)
				SetBlipColour (blip, Config.CarGarageColour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.CarGarageName)
				EndTextCommandSetBlipName(blip)
			end
		end
	end	
end)

local insideMarker = false

-- Core Thread Function:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords = GetEntityCoords(PlayerPedId())
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		local pedInVeh = IsPedInAnyVehicle(PlayerPedId(), true)
		
		if (ESX.PlayerData.job and ESX.PlayerData.job.name == Config.catsecurityDatabaseName) then
			for k,v in pairs(Config.CarZones) do
				for i = 1, #v.Pos, 1 do
					local distance = Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)
					if (distance < 10.0) and insideMarker == false then
						DrawMarker(Config.catsecurityCarMarker, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z-0.97, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.catsecurityCarMarkerScale.x, Config.catsecurityCarMarkerScale.y, Config.catsecurityCarMarkerScale.y, Config.catsecurityCarMarkerColor.r,Config.catsecurityCarMarkerColor.g,Config.catsecurityCarMarkerColor.b,Config.catsecurityCarMarkerColor.a, false, true, 2, true, false, false, false)						
					end
					if (distance < 2.5 ) and insideMarker == false then
						DrawText3Ds(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, Config.CarDraw3DText)
						if IsControlJustPressed(0, Config.KeyToOpenCarGarage) then
							catsecurityGarage('car')
							insideMarker = true
							Citizen.Wait(500)
						end
					end
				end
			end
		end
	end
end)

-- catsecurity Garage Menu:
catsecurityGarage = function(type)
	local elements = {
		{ label = 'Store a Car', action = "store_vehicle" },
		{ label = 'Spawn a Car', action = "get_vehicle" },
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_catsecurityGarage_menu",
		{
			title    = 'CatSecurity Garage',
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		local action = data.current.action
		if action == "get_vehicle" then
			if type == 'car' then
				VehicleMenu('car')
			elseif type == 'helicopter' then
				VehicleMenu('helicopter')
			elseif type == 'boat' then
				VehicleMenu('boat')
			end
		elseif data.current.action == 'store_vehicle' then
			local veh,dist = ESX.Game.GetClosestVehicle(playerCoords)
			if dist < 3 then
				DeleteEntity(veh)
				ESX.ShowNotification(Config.VehicleParked)
			else
				ESX.ShowNotification(Config.NoVehicleNearby)
			end
			insideMarker = false
		end
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

-- Vehicle Spawn Menu:
VehicleMenu = function(type)
	local storage = nil
	local elements = {}
	local ped = GetPlayerPed(-1)
	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(ped)
	
	if type == 'car' then
		for k,v in pairs(Config.catsecurityVehicles) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'car'})
		end
	elseif type == 'helicopter' then
		for k,v in pairs(Config.catsecurityHelicopters) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'helicopter'})
		end
	elseif type == 'boat' then
		for k,v in pairs(Config.catsecurityBoats) do
			table.insert(elements,{label = v.label, name = v.label, model = v.model, price = v.price, type = 'boat'})
		end
	end
		
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_catsecurityGarage_vehicle_garage",
		{
			title    = 'CatSecurity Garage',
			align    = "center",
			elements = elements
		},
	function(data, menu)
		menu.close()
		insideMarker = false
		local plate = exports['esx_vehicleshop']:GeneratePlate()
		VehicleLoadTimer(data.current.model)
		local veh = CreateVehicle(data.current.model,pos.x,pos.y,pos.z,GetEntityHeading(playerPed),true,false)
		SetPedIntoVehicle(GetPlayerPed(-1),veh,-1)
		SetVehicleNumberPlateText(veh,plate)
		
		if type == 'car' then
			ESX.ShowNotification(Config.CarOutFromPolGar)
		elseif type == 'helicopter' then
			ESX.ShowNotification(Config.HeliOutFromPolGar)
		elseif type == 'boat' then
			ESX.ShowNotification(Config.BoatOutFromPolGar)
		end
		
		TriggerEvent("fuel:setFuel",veh,100.0)
		SetVehicleDirtLevel(veh, 0.1)		
	end, function(data, menu)
		menu.close()
		insideMarker = false
	end, function(data, menu)
	end)
end

-- Load Timer Function for Vehicle Spawn:
function VehicleLoadTimer(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)

			drawLoadingText(Config.VehicleLoadText, 255, 255, 255, 255)
		end
	end
end

-- Loading Text for Vehicles Function:
function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end



-- catsecurity Extra Menu:
function OpenExtraMenu()
	local elements = {}
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) 

			if state then
				table.insert(elements, {
					label = "Extra: "..id.." | "..('<span style="color:green;">%s</span>'):format("On"),
					value = id,
					state = not state
				})
			else
				table.insert(elements, {
					label = "Extra: "..id.." | "..('<span style="color:red;">%s</span>'):format("Off"),
					value = id,
					state = not state
				})
			end
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_actions', {
		title    = Config.TitlecatsecurityExtra,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		SetVehicleExtra(vehicle, data.current.value, not data.current.state)
		local newData = data.current
		if data.current.state then
			newData.label = "Extra: "..data.current.value.." | "..('<span style="color:green;">%s</span>'):format("On")
		else
			newData.label = "Extra: "..data.current.value.." | "..('<span style="color:red;">%s</span>'):format("Off")
		end
		newData.state = not data.current.state

		menu.update({value = data.current.value}, newData)
		menu.refresh()
	end, function(data, menu)
		menu.close()
	end)
end

-- Blips
Citizen.CreateThread(function() 
    for k,v in pairs(Config.catsecurity) do
        local blip = AddBlipForCoord(v.Blip.Coords)
        SetBlipSprite(blip, v.Blip.Sprite)
        SetBlipDisplay(blip, v.Blip.Display)
        SetBlipScale(blip, v.Blip.Scale)
        SetBlipColour(blip, v.Blip.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Cat Security')
        EndTextCommandSetBlipName(blip)
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource) 
    if resource == GetCurrentResourceName() then
        ESX.UI.Menu.CloseAll()
    end
end)