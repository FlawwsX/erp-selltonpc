ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

itemprice = nil
itemamount = nil

RegisterNetEvent('np_selltonpc:dodeal')
AddEventHandler('np_selltonpc:dodeal', function(drugtype)

	drugitemname = drugtype .. '_pooch'

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		-- Start with the most frequent drug.
		if drugtype == 'weed' then
			itemprice = Config.WeedPrice
			itemamount = Config.WeedAmount
		elseif drugtype == 'coke' then
			itemprice = Config.CokePrice
			itemamount = Config.CokeAmount
		elseif drugtype == 'meth' then
			itemprice = Config.MethPrice
			itemamount = Config.MethAmount
		elseif drugtype == 'opium' then
			itemprice = Config.OpiumPrice
			itemamount = Config.OpiumAmount
		end

		if xPlayer.getInventoryItem(drugitemname).count == 1 then
			itemamount = 1
		elseif xPlayer.getInventoryItem(drugitemname).count == 2 then
			itemamount = 2
		elseif xPlayer.getInventoryItem(drugitemname).count == 3 then
			itemamount = 3
		end
			
		if xPlayer.getInventoryItem(drugitemname).count >= itemamount then
			xPlayer.removeInventoryItem(drugitemname, itemamount)
			local moneyamount = itemamount * itemprice
			xPlayer.addAccountMoney('black_money', moneyamount)
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. itemamount .. ' ' .. drugtype ..  ' for $' .. moneyamount, length = 4000 })
		elseif 
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You do not have enough ' .. drugtype .. ' to sell.', length = 5000, })
		end
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
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		-- Since this is the only way to not make the server check for an item 4 times in a row

		if Config.EnableWeed then
			local weed = xPlayer.getInventoryItem('weed_pooch').count
			if weed >= 1 then
				TriggerClientEvent("checkR", source, 'weed')
				return
			end
		end

		if Config.EnableCoke then
			local coke = xPlayer.getInventoryItem('coke_pooch').count
			if coke >= 1 then
				TriggerClientEvent("checkR", source, 'coke')
				return
			end
		end

		if Config.EnableMeth then
			local meth = xPlayer.getInventoryItem('meth_pooch').count
			if meth >= 1 then
				TriggerClientEvent("checkR", source, 'meth')
				return
			end
		end

		if Config.EnableOpium then
			local opium = xPlayer.getInventoryItem('opium_pooch').count
			if opium >= 1 then
				TriggerClientEvent("checkR", source, 'opium')
				return
			end
		end

		-- If they have nothing of the above, do this...
		TriggerClientEvent("checkR", source, false)
	end
end)

RegisterServerEvent('np_selltonpc:saleInProgress')
AddEventHandler('np_selltonpc:saleInProgress', function(streetName, playerGender)
	if playerGender == 0 then
		playerGender = 'Female'
	else
		playerGender = 'Male'
	end

	TriggerClientEvent('np_selltonpc:policeNotify', -1, 'Drug deal in progress: A ' .. playerGender .. ' has been spotted selling drugs at ' .. streetName)
end)
