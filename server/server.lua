ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('np_selltonpc:dodeal')
AddEventHandler('np_selltonpc:dodeal', function(weedprice, weedamount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		xPlayer.removeInventoryItem('weed_pooch', weedamount)
		local moneyamount = weedamount * weedprice
		xPlayer.addAccountMoney('black_money', moneyamount)
	end
end)

RegisterNetEvent('checkD')
AddEventHandler('checkD', function()

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local weed = xPlayer.getInventoryItem('weed_pooch').count

		if weed >= 1 then
			TriggerClientEvent("checkR", source, true)
		else
			TriggerClientEvent("checkR", source, false)
		end
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