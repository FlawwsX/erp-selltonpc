local drugtype, selling, numberofcops = nil, false, 0
ESX = nil

Citizen.CreateThread(function()
  	while ESX == nil do
    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(250)
  	end

  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(250)
	end
	
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if ped ~= 0 and not IsPedDeadOrDying(ped) and not IsPedInAnyVehicle(ped) then 
            local pedType = GetPedType(ped)
			if ped ~= oldped and not selling and (IsPedAPlayer(ped) == false and pedType ~= 28) then
				TriggerServerEvent('checkD')
				if drugtype ~= nil then
						
					if Config.NumberOfCops > 0 then
						TriggerServerEvent('checkC')
					end
						
					if numberofcops >= Config.NumberOfCops then
						local pos = GetEntityCoords(ped)
						DrawText3Ds(pos.x, pos.y, pos.z, 'Press E to sell ' .. drugtype)
						if IsControlJustPressed(1, 86) then
							interact(drugtype)
						end
					end
				else
					Wait(5000)
				end
			else
				Citizen.Wait(500)
			end
		end
	end
end)

RegisterNetEvent('checkR')
AddEventHandler('checkR', function(drug)
  drugtype = drug
end)

RegisterNetEvent('checkC')
AddEventHandler('checkC', function(cops)
  numberofcops = cops
end)

Citizen.CreateThread(function()
	while true do
		local playerPed = GetPlayerPed(-1)

		if not IsPedInAnyVehicle(playerPed) or not IsPedDeadOrDying(playerPed) then
			ped = GetPedInFront()
		else
			Citizen.Wait(1000)
		end
			
		Citizen.Wait(1000)
    end
end)

function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end

function interact(type)

	oldped, selling, drugtype = ped, true, nil
	SetEntityAsMissionEntity(ped)
	TaskStandStill(ped, 9.0)

	exports['progressBars']:startUI(3500, "Attempting to secure a sale...")
	Citizen.Wait(3500)

	-- Checks if they're a police officer
	
	if not Config.IgnorePolice then
		if ESX.PlayerData.job.name == 'police' then
			exports['mythic_notify']:SendAlert('error', 'The buyer has seen you before, they know you\'re a cop!', 4000)
			SetPedAsNoLongerNeeded(oldped)
			selling = false
			return
		end
	end

	-- Checks the distance between the PED and the seller before continuing.
	if Config.DistanceCheck then
		if ped ~= oldped then
			exports['mythic_notify']:SendAlert('error', 'You acted sketchy (moved far away) and the buyer was no longer interested.', 5000)
			SetPedAsNoLongerNeeded(oldped)
			selling = false
			return
		end
	end
	
	-- It all begins.
	local percent = math.random(1, 11)

	if percent <= 3 then
		exports['mythic_notify']:SendAlert('error', 'The buyer was not interested.', 4000)
	elseif percent <= 10 then

		if Config.EnableAnimation then
			TriggerEvent('animation')
		end

		Wait(1500)
		TriggerServerEvent('np_selltonpc:dodeal', type)
	else
		local playerCoords = GetEntityCoords(PlayerPedId())
		streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		streetName = GetStreetNameFromHashKey(streetName)

		exports['mythic_notify']:SendAlert('inform', 'The buyer is calling the police!', 4000)
		TriggerServerEvent('np_selltonpc:saleInProgress', streetName)
	end
	
	selling = false
	SetPedAsNoLongerNeeded(oldped)
end

RegisterNetEvent('animation')
AddEventHandler('animation', function()
  	local pid = PlayerPedId()
  	RequestAnimDict("amb@prop_human_bum_bin@idle_b")
  	while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do Citizen.Wait(0) end
	TaskPlayAnim(pid,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    Wait(1500)
	StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b","idle_d", 1.0)
end)

RegisterNetEvent('np_selltonpc:policeNotify')
AddEventHandler('np_selltonpc:policeNotify', function(alert)
	if ESX.PlayerData.job.name == 'police' then
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(48, 145, 255, 0.616); border-radius: 10px;">{0}</div>',
			args = { alert }
		})
	end
end)
