ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('np_selltonpc:dodeal')
AddEventHandler('np_selltonpc:dodeal', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local weedprice = math.random(150, 500)
		local weedamount = math.random(1, 5)

		local finalamount = weedprice * weedamount

		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You sold ' .. weedamount .. ' weed for $' .. finalamount, length = 4000 })
		xPlayer.removeInventoryItem('weed_pooch', weedamount)
		xPlayer.addAccountMoney('black_money', finalamount)
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