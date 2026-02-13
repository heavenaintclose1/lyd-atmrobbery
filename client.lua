--[[
    Resource: Lyd-ATMRobbery
    Author: Lyds (HeavenAintClose)
    Version: 1.0.0
    Description: ATM Robbery script with okokBanking integration and ps-ui minigames.
    
    License: Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
--]]

local QBCore = exports['qb-core']:GetCoreObject()
local OkokConfig = Config
local atmModels = {}

-- Get nearest road for CAD
local function GetStreet(coords)
    local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(s1)
    if s2 ~= 0 then streetName = streetName .. " / " .. GetStreetNameFromHashKey(s2) end
    return streetName
end

CreateThread(function()
    Wait(200)
    if OkokConfig and OkokConfig.ATM then
        for _, v in pairs(OkokConfig.ATM) do
            table.insert(atmModels, v.model)
        end
        print("^2[Lyd-ATMRobbery] Success! " .. #atmModels .. " models loaded from okokBanking.^7")
    else
        atmModels = { -870868698, -1126237515, -1364697528, 506770882, -1352984963 }
        print("^3[Lyd-ATMRobbery] Integration failed, using default list.^7")
    end

    exports.ox_target:addModel(atmModels, {
        {
            name = 'rob_atm',
            label = 'Break into ATM',
            icon = 'fas fa-user-secret',
            items = { 'electronickit', 'lockpick' },
            distance = 1.5,
            canInteract = function()
                local p = QBCore.Functions.GetPlayerData()
                local job = p.job.name
                if job == "police" or job == "highway" or job == "sheriff" then
                    return false
                end
                return true
            end,
            onSelect = function(data)
                local entity = data.entity
                local coords = GetEntityCoords(entity)

                QBCore.Functions.TriggerCallback('atmRobbery:getPoliceCount', function(copsOnDuty)
                    if copsOnDuty >= 0 then 
                        QBCore.Functions.TriggerCallback('atmRobbery:checkCooldown', function(isAvailable)
                            if isAvailable then
                                exports['ps-ui']:Scrambler(function(success)
                                    if success then
                                        StartAtmRobbery(entity, coords)
                                    else
                                        QBCore.Functions.Notify("System Lockdown! Hack failed.", "error")
                                        TriggerServerEvent('atmRobbery:removeItem')
                                        local street = GetStreet(coords)
                                        SetTimeout(math.random(2500, 7500), function()
                                            TriggerServerEvent('atmRobbery:sendAlert', coords, street)
                                            print("^1[Lyd-ATMRobbery] Failed hack at " .. street .. "^7")
                                        end)
                                    end
                                end, "numeric", 20, 0)
                            else
                                QBCore.Functions.Notify("This ATM is out of cash.", "error")
                            end
                        end, coords)
                    else
                        QBCore.Functions.Notify("The security systems are too quiet... (Not enough Police)", "error")
                    end
                end)
            end
        }
    })
end)

function StartAtmRobbery(entity, coords)
    local streetName = GetStreet(coords)

    SetTimeout(math.random(7500, 15000), function()
        TriggerServerEvent('atmRobbery:sendAlert', coords, streetName)
        print("^2[Lyd-ATMRobbery] Robbery started at " .. streetName .. "^7")
    end)

    QBCore.Functions.Progressbar("robbing_atm", "Bypassing Security Layers...", 30000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function()
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        TriggerServerEvent('atmRobbery:success', coords)
    end, function()
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        QBCore.Functions.Notify("Robbery cancelled!", "error")
    end)
end