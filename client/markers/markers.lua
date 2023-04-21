-- Ici vous pouvez ajouter vos propres markers, ou en supprimer des existants

ZonesListe = {
    ["Bank"] = {
        Position = vector3(149.7503, -1040.4989, 29.3741),
        Blip = {
            Name = "Banque",
            Sprite = 431,
            Display = 4,
            Scale = 0.8,
            Color = 69
        },
        Action = function()
            OpenMenuBank()
        end
    },

    ["Bank2"] = {
        Position = vector3(-1212.980, -330.841, 37.787),
        Blip = {
            Name = "Banque",
            Sprite = 431,
            Display = 4,
            Scale = 0.8,
            Color = 69
        },
        Action = function()
            OpenMenuBank()
        end
    },

    ["Bank3"] = {
        Position = vector3(-2962.582, 482.627, 15.703),
        Blip = {
            Name = "Banque",
            Sprite = 431,
            Display = 4,
            Scale = 0.8,
            Color = 69
        },
        Action = function()
            OpenMenuBank()
        end
    },

    ["Bank4"] = {
        Position = vector3(314.187, -278.621, 54.170),
        Blip = {
            Name = "Banque",
            Sprite = 431,
            Display = 4,
            Scale = 0.8,
            Color = 69
        },
        Action = function()
            OpenMenuBank()
        end
    },

    ["Bank5"] = {
        Position = vector3(-351.534, -49.529, 49.042),
        Blip = {
            Name = "Banque",
            Sprite = 431,
            Display = 4,
            Scale = 0.8,
            Color = 69
        },
        Action = function()
            OpenMenuBank()
        end
    },

    ["Bank6"] = {
        Position = vector3(1175.064, 2706.643, 38.094),
        Blip = {
            Name = "Banque",
            Sprite = 431,
            Display = 4,
            Scale = 0.8,
            Color = 69
        },
        Action = function()
            OpenMenuBank()
        end
    },
    
        ["Bank7"] = {
            Position = vector3(-2072.41, -317.959, 13.315),
            Blip = {
                Name = "Banque",
                Sprite = 431,
                Display = 4,
                Scale = 0.8,
                Color = 69
            },
            Action = function()
                OpenMenuBank()
            end
        },
    
        ["Bank8"] = {
            Position = vector3(-2957.7, 481.5, 15.7),
            Blip = {
                Name = "Banque",
                Sprite = 431,
                Display = 4,
                Scale = 0.8,
                Color = 69
            },
            Action = function()
                OpenMenuBank()
            end
        },
    
        ["Bank9"] = {
            Position = vector3(241.727, 220.706, 106.286),
            Blip = {
                Name = "Banque",
                Sprite = 431,
                Display = 4,
                Scale = 0.8,
                Color = 69
            },
            Action = function()
                OpenMenuBank()
            end
        },
    
        ["Bank10"] = {
            Position = vector3(1174.532, 2705.278, 38.094),
            Blip = {
                Name = "Banque",
                Sprite = 431,
                Display = 4,
                Scale = 0.8,
                Color = 69
            },
            Action = function()
                OpenMenuBank()
            end
        },
    
        ["Bank11"] = {
            Position = vector3(110.75, 6640.46, 31.787),
            Blip = {
                Name = "Banque",
                Sprite = 431,
                Display = 4,
                Scale = 0.8,
                Color = 69
            },
            Action = function()
                OpenMenuBank()
            end
        }
}

function AddMarker(id, data)
    if not ZonesListe[id] then 
        ZonesListe[id] = data
    end
end

function RemoveMarker(id)
    ZonesListe[id] = nil
end

Citizen.CreateThread(function()
    for _,marker in pairs(ZonesListe) do
        if marker.Blip then
            local blip = AddBlipForCoord(marker.Position)

            SetBlipSprite(blip, marker.Blip.Sprite)
            SetBlipScale(blip, marker.Blip.Scale)
            SetBlipColour(blip, marker.Blip.Color)
            SetBlipDisplay(blip, marker.Blip.Display)
            SetBlipAsShortRange(blip, true)
    
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(marker.Blip.Name)
            EndTextCommandSetBlipName(blip)
        end
	end

    while true do
        local isProche = false
        for k,v in pairs(ZonesListe) do
                local dist = Vdist2(GetEntityCoords(PlayerPedId(), false), v.Position)

                if dist < 20 then
                    isProche = true
                    DrawMarker(3, v.Position.x, v.Position.y, v.Position.z+0.10, 0.0, 0.0, -90.0, -90.0, 0.0, 0.0, 0.55, 0.55, 0.55, 0, 150, 255, 255, false, false, 2, false, false, false, false)
                end
                if dist < 3 then
                    Draw3DText(v.Position.x, v.Position.y, v.Position.z, "Appuyez sur ~b~E~s~ pour accéder au menu")
                    if IsControlJustPressed(1,51) then
                        v.Action(v.Position)
                    end
                end
        end
        
		if isProche then
			Wait(0)
		else
			Wait(750)
		end
	end
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
	AddTextEntry(entryTitle, textEntry)
	DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', 100)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end

	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end