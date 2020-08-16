ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

itemprice, itemamount = 0, 0

RegisterNetEvent('np_selltonpc:dodeal')
AddEventHandler('np_selltonpc:dodeal', function(drugtype)
	local src = source
	drugitemname = drugtype .. '_pooch'
		
	-- Start with the most frequent drug.
	if drugtype == 'weed' then
		itemprice = math.random(Config.WeedPriceMin,Config.WeedPriceMax)
		itemamount = math.random(Config.WeedAmountMin, Config.WeedAmountMax)
	elseif drugtype == 'coke' then
		itemprice = math.random(Config.CokePriceMin,Config.CokePriceMax)
		itemamount = math.random(Config.CokeAmountMin, Config.CokeAmountMax)
	elseif drugtype == 'meth' then
		itemprice = math.random(Config.MethPriceMin,Config.MethPriceMax)
		itemamount = math.random(Config.MethAmountMin, Config.MethAmountMax)
	elseif drugtype == 'opium' then
		itemprice = math.random(Config.OpiumPriceMin,Config.OpiumPriceMax)
		itemamount = math.random(Config.OpiumAmountMin, Config.OpiumAmountMax)
	end
	
	local xPlayer = ESX.GetPlayerFromId(src)
    local inventoryamount = xPlayer.getInventoryItem(drugitemname).count

	if inventoryamount == 1 then
		itemamount = 1
	elseif inventoryamount == 2 then
		itemamount = 2
	elseif inventoryamount == 3 then
		itemamount = 3
	end
			
	if inventoryamount >= itemamount then
		xPlayer.removeInventoryItem(drugitemname, itemamount)
		local moneyamount = itemamount * itemprice
		xPlayer.addAccountMoney('black_money', moneyamount)
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. itemamount .. ' ' .. drugtype ..  ' for $' .. moneyamount, length = 4000 })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You do not have enough ' .. drugtype .. ' to sell.', length = 5000, })
	end
end)

RegisterNetEvent('checkC')
AddEventHandler('checkC', function()
	local xPlayers = ESX.GetPlayers()
	local cops = 0
	for i=1, #xPlayers, 1 do
 	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 	if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end
	TriggerClientEvent("checkC", source, cops)
end)

RegisterNetEvent('checkD')
AddEventHandler('checkD', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		-- Since this is the only way to not make the server check for an item 4 times in a row

		if Config.EnableWeed then
			local weed = xPlayer.getInventoryItem('weed_pooch').count
			if weed >= 1 then
				TriggerClientEvent("checkR", src, 'weed')
				return
			end
		end

		if Config.EnableCoke then
			local coke = xPlayer.getInventoryItem('coke_pooch').count
			if coke >= 1 then
				TriggerClientEvent("checkR", src, 'coke')
				return
			end
		end

		if Config.EnableMeth then
			local meth = xPlayer.getInventoryItem('meth_pooch').count
			if meth >= 1 then
				TriggerClientEvent("checkR", src, 'meth')
				return
			end
		end

		if Config.EnableOpium then
			local opium = xPlayer.getInventoryItem('opium_pooch').count
			if opium >= 1 then
				TriggerClientEvent("checkR", src, 'opium')
				return
			end
		end

		-- If they have nothing of the above, do this...
		TriggerClientEvent("checkR", src, nil)
	end
end)

RegisterServerEvent('np_selltonpc:saleInProgress')
AddEventHandler('np_selltonpc:saleInProgress', function(streetName)
	TriggerClientEvent('np_selltonpc:policeNotify', -1, 'Drug deal: An illegal sale has been spotted at ' ..streetName)
end)
