ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx_society:registerSociety', 'catsecurity', 'catsecurity', 'society_catsecurity', 'society_catsecurity', 'society_catsecurity', {type = 'public'})

RegisterNetEvent('esx_catsecurity:removeItemAddItem')
AddEventHandler('esx_catsecurity:removeItemAddItem', function(item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasItem = xPlayer.getInventoryItem(item)
    local gammaQuantity = xPlayer.getInventoryItem('komatialexisferou').count
	
    if item == 'bulletproof' then
            if hasItem.limit ~= -1 and (hasItem.count + Config.NeededItemAmount) > hasItem.limit then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="You dont have enough space!"})
			elseif gammaQuantity < 1 then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="You dont have resource of bulletproof"})
            else
                xPlayer.addInventoryItem(item, 1)
                xPlayer.removeInventoryItem(Config.NeededItem, Config.NeededItemAmount)
                TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="inform", text="You used x1 resource to craft the bulletproof"})
            end
    end
end)

RegisterServerEvent('esx_catsecurity:giveWeapon')
AddEventHandler('esx_catsecurity:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

ESX.RegisterUsableItem('bulletproof', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasItem = xPlayer.getInventoryItem('bulletproof')
    if hasItem then
        xPlayer.removeInventoryItem('bulletproof', 1)
        TriggerClientEvent('esx_catsecurity:useBulletproof', source)
    end
end)

RegisterServerEvent('esx_catsecurity:Billing')
AddEventHandler('esx_catsecurity:Billing', function(money, player)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(player)
  local valor = money

    if xTarget.getMoney() >= valor then
      xTarget.removeMoney(valor)
      xPlayer.addMoney(valor)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, "O seu cliente nao tem esse dinheiro, valor: " ..valor)
	  TriggerClientEvent('esx:showNotification', xTarget.source, "Voce nao tem esse dinheiro, valor: " ..valor)
    end
end)

RegisterNetEvent('esx_catsecurity:server:getStockItem')
AddEventHandler('esx_catsecurity:server:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	local playerName1 = xPlayer.getName()
	
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_catsecurity', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="Invalid quantity"})
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				PerformHttpRequest(Config.DiscordLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="Security Discord Logs",description="\nSteam Name: "..playerName1.."\nWithdrawn an item : "..itemName.."\nQuantity of item :"..count.."",color= 56108}}}), { ['Content-Type'] = 'application/json' })
                TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="inform", text="You have withdrawn x" .. count .. " " .. inventoryItem.label})
				TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="Invalid quantity"})
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="Invalid quantity"})
		end
	end)
end)

RegisterNetEvent('esx_catsecurity:server:putStockItems')
AddEventHandler('esx_catsecurity:server:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	local playerName1 = xPlayer.getName()
	
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_catsecurity', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			PerformHttpRequest(Config.DiscordLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="Security Discord Logs",description="\nSteam Name: "..playerName1.."\nPut an item : "..itemName.."\nQuantity of item :"..count.."",color= 56108}}}), { ['Content-Type'] = 'application/json' })
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type="inform", text="You have deposited x" .. count .. " " .. inventoryItem.label})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type="error", text="Invalid quantity"})
		end
	end)
end)

ESX.RegisterServerCallback('esx_catsecurity:server:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_catsecurity', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_catsecurity:server:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('esx_catsecurity:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_catsecurity', function(store)
  
	  local weapons = store.get('weapons')
  
	  if weapons == nil then
		weapons = {}
	  end
  
	  cb(weapons)
  
	end)
  
  end)
  
  ESX.RegisterServerCallback('esx_catsecurity:addArmoryWeapon', function(source, cb, weaponName)
  
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerName1 = xPlayer.getName()
	PerformHttpRequest(Config.DiscordLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="Security Discord Logs",description="\nSteam Name: "..playerName1.."\nAdded a weapon : "..weaponName.."",color= 56108}}}), { ['Content-Type'] = 'application/json' })
	xPlayer.removeWeapon(weaponName)
  
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_catsecurity', function(store)
  
	  local weapons = store.get('weapons')
  
	  if weapons == nil then
		weapons = {}
	  end
  
	  local foundWeapon = false
  
	  for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
		  weapons[i].count = weapons[i].count + 1
		  foundWeapon = true
		end
	  end
  
	  if not foundWeapon then
		table.insert(weapons, {
		  name  = weaponName,
		  count = 1
		})
	  end
  
	   store.set('weapons', weapons)
  
	   cb()
  
	end)
  
  end)
  
  ESX.RegisterServerCallback('esx_catsecurity:removeArmoryWeapon', function(source, cb, weaponName)
  
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerName1 = xPlayer.getName()
	PerformHttpRequest(Config.DiscordLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="Security Discord Logs",description="\nSteam Name: "..playerName1.."\nRemoved a weapon : "..weaponName.."",color= 56108}}}), { ['Content-Type'] = 'application/json' })

	xPlayer.addWeapon(weaponName, 100)
  
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_catsecurity', function(store)
  
	  local weapons = store.get('weapons')
  
	  if weapons == nil then
		weapons = {}
	  end
  
	  local foundWeapon = false
  
	  for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
		  weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
		  foundWeapon = true
		end
	  end
  
	  if not foundWeapon then
		table.insert(weapons, {
		  name  = weaponName,
		  count = 0
		})
	  end
  
	   store.set('weapons', weapons)
  
	   cb()
  
	end)
  
  end)
  
  ESX.RegisterServerCallback('esx_catsecurity:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_catsecurity', function(account)
  
	  if account.money >= amount then
		account.removeMoney(amount)
		cb(true)
	  else
		cb(false)
	  end
  
	end)
  
  end)

RegisterServerEvent('esx_catsecurity:shop')
AddEventHandler('esx_catsecurity:shop', function(item, valor)

    local _source = source
    local xPlayer           = ESX.GetPlayerFromId(_source)
	local comida = item
	local preco = valor
	local playerName1 = xPlayer.getName()

	if xPlayer.getMoney() >= preco then
        xPlayer.removeMoney(preco)
		xPlayer.addInventoryItem(comida, 1)
		PerformHttpRequest(Config.DiscordLogs, function(err, text, headers) end, 'POST', json.encode({embeds={{title="Security Discord Logs",description="\nSteam Name: "..playerName1.."\nBought resource for vest : "..comida.."\nPrice of item :"..valor.."",color= 56108}}}), { ['Content-Type'] = 'application/json' })
	end
end)