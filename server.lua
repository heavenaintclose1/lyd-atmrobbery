--[[
    Resource: Lyd-ATMRobbery
    Author: Lyds (HeavenAintClose)
    Version: 1.0.0
    Description: ATM Robbery script with okokBanking integration and ps-ui minigames.
    
    License: Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
    - You must give appropriate credit (Attribution).
    - If you remix, transform, or build upon the material, you must distribute 
      your contributions under the same license (ShareAlike).
    - Commercial use is permitted under CC BY-SA 4.0 terms.
--]]

local QBCore = exports['qb-core']:GetCoreObject()
local atmCooldowns = {}

QBCore.Functions.CreateCallback('atmRobbery:checkCooldown', function(source, cb, coords)
    local atmId = string.format("x%dy%d", math.floor(coords.x), math.floor(coords.y))
    if atmCooldowns[atmId] and os.time() < atmCooldowns[atmId] then
        cb(false)
    else
        cb(true)
    end
end)

function GetPoliceCount()
    local copsOnDuty = 0
    local players = QBCore.Functions.GetPlayers()

    for _, playerId in ipairs(players) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        -- Using 'leo' type check as per your request
        if Player and Player.PlayerData.job.type == 'leo' and Player.PlayerData.job.onduty then
            copsOnDuty = copsOnDuty + 1
        end
    end
    return copsOnDuty
end

QBCore.Functions.CreateCallback('atmRobbery:getPoliceCount', function(source, cb)
    local count = GetPoliceCount()
    cb(count)
end)

--[[ Sonoran CAD Integration
RegisterNetEvent('atmRobbery:sendAlert', function(coords, streetName)
    local src = source
    -- We use the Sonoran export to find the nearest postal
    exports.sonorancad:RetrievePostal(coords, function(postal)
        local data = {
            ['title'] = "ATM Robbery in Progress",
            ['message'] = "Electronic tampering detected at ATM near postal " .. postal,
            ['postal'] = postal,
            ['location'] = streetName, -- Use the street name passed from client
        }
        TriggerEvent("sonorancad:v2:dispatchNotify", data)
    end)
end)
--]]

RegisterNetEvent('atmRobbery:removeItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local x = math.random(1,100) --debug, remove when done
    if x <= 50 then
        if Player.Functions.RemoveItem("electronickit", 1) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["electronickit"], "remove")
            TriggerClientEvent('QBCore:Notify', src, "The electronic kit short-circuited!", "error")
            print("Math: " .. x) --debug
        end
    end
end)

RegisterNetEvent('atmRobbery:success', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local atmId = string.format("x%dy%d", math.floor(coords.x), math.floor(coords.y))
    local amount = math.random(500, 1250)

    Player.Functions.AddMoney('cash', amount)
    atmCooldowns[atmId] = os.time() + 1800 -- 30 mins

    TriggerClientEvent('QBCore:Notify', src, "You grabbed $" .. amount .. " from the machine.", "success")
end)