local firstSpawn = true
local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }


Keys = {
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



isDead, isSearched, medic = false, false, 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	firstSpawn = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
	isDead = false

	if firstSpawn then
		firstSpawn = false

		if Config.SaveDeathStatus then
			while not ESX.PlayerLoaded do
				Wait(1000)
			end

			ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
				if shouldDie then
					Wait(1000)
					SetEntityHealth(PlayerPedId(), 0)
				end
			end)
		end
	end
end)



-- Disable most inputs when dead
Citizen.CreateThread(function()
	DecorRegister(deadDecor, 1)
	while true do
		Citizen.Wait(5)

		if isDead then
			if not not IsGameplayCamShaking() then
				ShakeGameplayCam("DRUNK_SHAKE", 7.0)
			end
			DisableAllControlActions(0)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['H'], true)
			EnableControlAction(0, Keys['ESC'], true)
			EnableControlAction(0, 303, true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, Keys['LEFT'], true)
			EnableControlAction(0, Keys['RIGHT'], true)
			EnableControlAction(0, Keys['TOP'], true)
			EnableControlAction(0, Keys['ALT'], true)
			EnableControlAction(0, Keys['DOWN'], true)
			EnableControlAction(0, Keys['ENTER'], true)
			EnableControlAction(0, Keys['NENTER'], true)
			EnableControlAction(0, Keys['N'], true)
			EnableControlAction(0, Keys['F2'], true)
			EnableControlAction(0, Keys['ESC'], true)
			EnableControlAction(0, 48, true)
			EnableControlAction(1, 289, true)
			EnableControlAction(1, 18, true)
			EnableControlAction(0, 201, true)
			EnableControlAction(1, 170, true)
			EnableControlAction(1, 201, true)
			EnableControlAction(1, 177, true)
			EnableControlAction(1, 176, true)
			EnableControlAction(0, 20, true)
			EnableControlAction(1, 20, true)
			EnableControlAction(0, 1, true)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:clsearch')
AddEventHandler('esx_ambulancejob:clsearch', function(medicId)
	local playerPed = PlayerPedId()

	if isDead then
		local coords = GetEntityCoords(playerPed)
		local playersInArea = ESX.Game.GetPlayersInArea(coords, 50.0)

		for i=1, #playersInArea, 1 do
			local player = playersInArea[i]
			if player == GetPlayerFromServerId(medicId) then
				medic = tonumber(medicId)
				isSearched = true
				break
			end
		end
	end
end)

local d = 453432689
local currentAnim = 'ragdoll'
function OnPlayerDeath()
   d = 453432689
   while GetEntitySpeed(PlayerPedId()) > 0.5 do 
	   Citizen.Wait(1)
   end
   currentAnim = 'ragdoll'
   isDead = true
   d = GetPedCauseOfDeath(PlayerPedId())
   DecorSetInt(PlayerPedId(), deadDecor, 1)
   TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
   StartDeathTimer()

   math.randomseed(GetGameTimer())
   local vehPlyIn = nil
   local vehPlySeat = nil
   d = 453432689
   if IsPedSittingInAnyVehicle(PlayerPedId()) then
	   vehPlyIn = GetVehiclePedIsIn(PlayerPedId(), true)

	   for i = -1, GetVehicleMaxNumberOfPassengers(vehPlyIn) do
		   if GetPedInVehicleSeat(vehPlyIn, i) == PlayerPedId() then
			   vehPlySeat = i 

			   break
		   end
	   end
   end

   NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), false, false, false)
	SetEntityInvincible(PlayerPedId(), true)
	SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))


	if vehPlyIn ~= nil then
		TaskWarpPedIntoVehicle(PlayerPedId(), vehPlyIn, vehPlySeat)
	end

	Citizen.Wait(100)

	StartScreenEffect("SuccessTrevor", 0, false)
	StopScreenEffect("SuccessTrevor")
	
	if IsPedSittingInAnyVehicle(PlayerPedId()) then
		DeathDic = "veh@low@front_ps@idle_duck"
		DeathAnim = "sit"
 
	
		PlayAnimation(DeathDic, DeathAnim)
	elseif IsEntityInWater(PlayerPedId()) then
	else

		ClearPedTasksImmediately(PlayerPedId())
		
		Citizen.Wait(100)

		DeathDic = "dead"
		DeathAnim = "dead_d"

		local ForwardVector = GetEntityForwardVector(PlayerPedId())

		--exports.pNotify:SendNotification({text = "Kręci Ci się w głowie...", type = "info", layout = "centerLeft", timeout = 8000})
	end	



	while isDead do
		Wait(5)

		if not DecorExistOn(PlayerPedId(), deadDecor) then
			DecorSetInt(PlayerPedId(), deadDecor, 1)
		end
		if IsPedInAnyVehicle(PlayerPedId()) then
			if IsPedRagdoll(PlayerPedId()) then
				ClearPedTasksImmediately(PlayerPedId())
			end
			if not IsEntityPlayingAnim(PlayerPedId(), 'missarmenian2', 'corpse_search_exit_ped', 3) then
				PlayAnimation('veh@low@front_ps@idle_duck', 'sit')
			end
		end
		if currentAnim == 'ragdoll' then
			if not IsEntityInWater(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
			end
		elseif currentAnim == 'unconscious' then
			if IsPedRagdoll(PlayerPedId()) then
				ClearPedTasksImmediately(PlayerPedId())
			end
			if not IsEntityInWater(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId()) then
				if not IsEntityPlayingAnim(PlayerPedId(), 'missarmenian2', 'corpse_search_exit_ped', 3) then
					PlayAnimation('missarmenian2', 'corpse_search_exit_ped')
				end
			end
		elseif currentAnim == 'injured' then
			if IsPedRagdoll(PlayerPedId()) then
				ClearPedTasksImmediately(PlayerPedId())
			end
			if not IsEntityInWater(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId())  then
				if not IsEntityPlayingAnim(PlayerPedId(), 'random@dealgonewrong', 'idle_a', 3) then
					PlayAnimation('random@dealgonewrong', 'idle_a')
				end
			end
		end
	end
	DecorRemove(PlayerPedId(), deadDecor)
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			RemoveAnimDict(lib)

			Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			RemoveAnimDict(lib)

			Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

function StartDistressSignal()
	CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and isDead do
			Wait(0)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlJustReleased(0, 47) then
				SendDistressSignal()
				break
			end
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	ESX.ShowNotification(_U('distress_sent'))
	TriggerServerEvent('esx_ambulancejob:onPlayerDistress')
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function checkArray (array, val)
	for name, value in ipairs(array) do
		if value == val then
			return true
		end
	end

	return false
end

function StartDeathTimer()
	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)-- gdy gosc moze sie tepnac na szpital
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000) -- gdy gosc moze wstac
	if checkArray(Melee, d) then
		bleedoutTimer = 60
	end
	SendNUIMessage({
        type = "showui"
      })
	Citizen.CreateThread(function()
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
				SendNUIMessage({
					type = "updateearlySpawnTimer",
					time = earlySpawnTimer
				  })
			end
		end
	end)

	Citizen.CreateThread(function()
		while isDead do
			Wait(5)
				if bleedoutTimer == 0 and isDead then
					if IsControlPressed(0, Keys['H']) then
						d = 453432689
						isDead = false
						TriggerEvent('ambu:walkRevive2')
						break
					end
				end
				if earlySpawnTimer == 0 and isDead then
					if IsControlPressed(0, Keys['E'])  then
						TriggerServerEvent('esx_ambulancejob:payFine')
						RemoveItemsAfterRPDeath()
						isDead = false
						break
					end
				end
		end
		SendNUIMessage({
			type = "hideui"
		  })
	end)

	Citizen.CreateThread(function()
		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
				SendNUIMessage({
					type = "updatebleedoutTimer",
					time = bleedoutTimer
				  })
			end
		end
	end)

	RegisterNetEvent('ambu:walkRevive2')
AddEventHandler('ambu:walkRevive2', function(health)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local health = GetEntityHealth(PlayerPedId())
    local new = health + 2
	isDead = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	d = 453432689
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		
		RespawnPed(playerPed, formattedCoords, 0.0)
		
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		SetEntityHealth(PlayerPedId(), new)
	end)
end)

	
RegisterNetEvent('ambu:walkRevive')
AddEventHandler('ambu:walkRevive', function(health)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	isDead = false
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	d = 453432689
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		
		RespawnPed(playerPed, formattedCoords, 0.0)
		
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		SetEntityHealth(PlayerPedId(), math.floor(health * 2))
	end)
end)

	CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Wait(0)
			-- text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Wait(0)
			-- text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if not Config.EarlyRespawnFine then
				-- text = text .. _U('respawn_bleedout_prompt')

				if IsControlPressed(0, 38) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end
			elseif Config.EarlyRespawnFine and canPayFine then
				-- text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)
		end

		if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function GetClosestRespawnPoint()
	local PlyCoords = GetEntityCoords(PlayerPedId())
	local ClosestDist, ClosestHospital, ClosestCoord = 10000, {}, nil

	for k,v in pairs(Config.RespawnPoints) do
		local Distance = #(PlyCoords - vector3(v.coords.x, v.coords.y, v.coords.z))
		if Distance <= ClosestDist then
			ClosestDist = Distance
			ClosestHospital = v
			ClosestCoord = vector3(v.coords.x, v.coords.y, v.coords.z)
		end
	end

	return ClosestCoord, ClosestHospital
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	CreateThread(function()
		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local RespawnCoords, ClosestHospital = GetClosestRespawnPoint()
			
			ESX.SetPlayerData('loadout', {})

			DoScreenFadeOut(800)
			RespawnPed(PlayerPedId(), RespawnCoords, ClosestHospital.heading)
			while not IsScreenFadedOut() do
			Wait(0)
			end
			AnimpostfxStop('DeathFailOut')
			DoScreenFadeIn(800)
		end)
	end)
end


function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
	ESX.UI.Menu.CloseAll()
	SendNUIMessage({
        type = "hideui"
      })
end

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ambulance',
		number     = 'ambulance',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAABp5JREFUWIW1l21sFNcVhp/58npn195de23Ha4Mh2EASSvk0CPVHmmCEI0RCTQMBKVVooxYoalBVCVokICWFVFVEFeKoUdNECkZQIlAoFGMhIkrBQGxHwhAcChjbeLcsYHvNfsx+zNz+MBDWNrYhzSvdP+e+c973XM2cc0dihFi9Yo6vSzN/63dqcwPZcnEwS9PDmYoE4IxZIj+ciBb2mteLwlZdfji+dXtNU2AkeaXhCGteLZ/X/IS64/RoR5mh9tFVAaMiAldKQUGiRzFp1wXJPj/YkxblbfFLT/tjq9/f1XD0sQyse2li7pdP5tYeLXXMMGUojAiWKeOodE1gqpmNfN2PFeoF00T2uLGKfZzTwhzqbaEmeYWAQ0K1oKIlfPb7t+7M37aruXvEBlYvnV7xz2ec/2jNs9kKooKNjlksiXhJfLqf1PXOIU9M8fmw/XgRu523eTNyhhu6xLjbSeOFC6EX3t3V9PmwBla9Vv7K7u85d3bpqlwVcvHn7B8iVX+IFQoNKdwfstuFtWoFvwp9zj5XL7nRlPXyudjS9z+u35tmuH/lu6dl7+vSVXmDUcpbX+skP65BxOOPJA4gjDicOM2PciejeTwcsYek1hyl6me5nhNnmwPXBhjYuGC699OpzoaAO0PbYJSy5vgt4idOPrJwf6QuX2FO0oOtqIgj9pDU5dCWrMlyvXf86xsGgHyPeLos83Brns1WFXLxxgVBorHpW4vfQ6KhkbUtCot6srns1TLPjNVr7+1J0PepVc92H/Eagkb7IsTWd4ZMaN+yCXv5zLRY9GQ9xuYtQz4nfreWGdH9dNlkfnGq5/kdO88ekwGan1B3mDJsdMxCqv5w2Iq0khLs48vSllrsG/Y5pfojNugzScnQXKBVA8hrX51ddHq0o6wwIlgS8Y7obZdUZVjOYLC6e3glWkBBVHC2RJ+w/qezCuT/2sV6Q5VYpowjvnf/iBJJqvpYBgBS+w6wVB5DLEOiTZHWy36nNheg0jUBs3PoJnMfyuOdAECqrZ3K7KcACGQp89RAtlysCphqZhPtRzYlcPx+ExklJUiq0le5omCfOGFAYn3qFKS/fZAWS7a3Y2wa+GJOEy4US+B3aaPUYJamj4oI5LA/jWQBt5HIK5+JfXzZsJVpXi/ac8+mxWIXWzAG4Wb4g/jscNMp63I4U5FcKaVvsNyFALokSA47Kx8PVk83OabCHZsiqwAKEpjmfUJIkoh/R+L9oTpjluhRkGSPG4A7EkS+Y3HZk0OXYpIVNy01P5yItnptDsvtIwr0SunqoVP1GG1taTHn1CloXm9aLBEIEDl/IS2W6rg+qIFEYR7+OJTesqJqYa95/VKBNOHLjDBZ8sDS2998a0Bs/F//gvu5Z9NivadOc/U3676pEsizBIN1jCYlhClL+ELJDrkobNUBfBZqQfMN305HAgnIeYi4OnYMh7q/AsAXSdXK+eH41sykxd+TV/AsXvR/MeARAttD9pSqF9nDNfSEoDQsb5O31zQFprcaV244JPY7bqG6Xd9K3C3ALgbfk3NzqNE6CdplZrVFL27eWR+UASb6479ULfhD5AzOlSuGFTE6OohebElbcb8fhxA4xEPUgdTK19hiNKCZgknB+Ep44E44d82cxqPPOKctCGXzTmsBXbV1j1S5XQhyHq6NvnABPylu46A7QmVLpP7w9pNz4IEb0YyOrnmjb8bjB129fDBRkDVj2ojFbYBnCHHb7HL+OC7KQXeEsmAiNrnTqLy3d3+s/bvlVmxpgffM1fyM5cfsPZLuK+YHnvHELl8eUlwV4BXim0r6QV+4gD9Nlnjbfg1vJGktbI5UbN/TcGmAAYDG84Gry/MLLl/zKouO2Xukq/YkCyuWYV5owTIGjhVFCPL6J7kLOTcH89ereF1r4qOsm3gjSevl85El1Z98cfhB3qBN9+dLp1fUTco+0OrVMnNjFuv0chYbBYT2HcBoa+8TALyWQOt/ImPHoFS9SI3WyRajgdt2mbJgIlbREplfveuLf/XXemjXX7v46ZxzPlfd8YlZ01My5MUEVdIY5rueYopw4fQHkbv7/rZkTw6JwjyalBCHur9iD9cI2mU0UzD3P9H6yZ1G5dt7Gwe96w07dl5fXj7vYqH2XsNovdTI6KMrlsAXhRyz7/C7FBO/DubdVq4nBLPaohcnBeMr3/2k4fhQ+Uc8995YPq2wMzNjww2X+vwNt1p00ynrd2yKDJAVN628sBX1hZIdxXdStU9G5W2bd9YHR5L3f/CNmJeY9G8WAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Wait(50)
	end

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	RespawnPed(playerPed, formattedCoords, 0.0)

	AnimpostfxStop('DeathFailOut')
	DoScreenFadeIn(800)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	RequestIpl('Coroner_Int_on') -- Morgue
end
