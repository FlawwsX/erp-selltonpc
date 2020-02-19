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
			itemamount = math.random(1,5)
			itemprice = Config.weedprice
		elseif drugtype == 'coke' then
			itemamount = math.random(1,5)
			itemprice = Config.cokeprice
		elseif drugtype == 'meth' then
			itemamount = math.random(1,5)
			itemprice = Config.methprice
		elseif drugtype == 'opium' then
			itemamount = math.random(1,5)
			itemprice = Config.opiumprice
		end
		itemprice = itemprice * itemamount
		-- Checking to see if they have enough weed to stop going negative...
		if xPlayer.getInventoryItem(drugitemname).count >= itemamount then
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. itemamount .. ' ' .. drugtype ..  ' for $' .. itemprice, length = 4000 })
			Citizen.Wait(50) -- Because why not.
			xPlayer.removeInventoryItem(drugitemname, itemamount)
			local moneyamount = itemamount * itemprice
			xPlayer.addAccountMoney('black_money', moneyamount)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You do not have enough' .. ' ' .. drugtype .. ' to sell.', length = 5000, })
		end
	end
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
