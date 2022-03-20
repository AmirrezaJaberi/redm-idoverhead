
local Text = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, playerId in ipairs(GetActivePlayers()) do
			local ped = GetPlayerPed(playerId)
			local bone = GetPedBoneCoords(ped, 12844, 0.0, 0.0, 0.0)
			local coords = GetEntityCoords(PlayerPedId())
			if ped ~= PlayerPedId() then
				if #(coords - bone) <= Config.DrawDistance and not Citizen.InvokeNative(0xD5FE956C70FF370B, ped) then -- GetPedCrouchMovement (https://vespura.com/doc/natives/?_0xD5FE956C70FF370B)
					if Text == nil or not Text then
						local text = GetPlayerServerId(playerId)
						if Citizen.InvokeNative(0xEF6F2A35FAAF2ED7, playerId) then -- N_0xef6f2a35faaf2ed7 (https://vespura.com/doc/natives/?_0xEF6F2A35FAAF2ED7)
							text = "~d~Talking~s~("..GetPlayerServerId(playerId)..")"
						end
						DrawText3D(bone.x, bone.y, bone.z + 1.3, ''..text..'')
					end
				end
			end
		end
	end
end)

--------------- function's ---------------

-- Draw Text
function DrawText3D(x, y, z, text)
	local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)
	local dist = #(GetFinalRenderedCamCoord()- vector3(x, y, z))

	local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

	if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
		SetTextFontForCurrentCommand(1)
		SetTextColor(255, 255, 255, 223)
		SetTextCentre(1)
		DisplayText(CreateVarString(10, "LITERAL_STRING", text), screenX, screenY)
    end
end

function CreateVarString(p0, p1, variadic)
    return Citizen.InvokeNative(0xFA925AC00EB830B9, p0, p1, variadic, Citizen.ResultAsLong()) -- VarString (https://vespura.com/doc/natives/?_0xFA925AC00EB830B9)
end
