-- Sync Block Script

local syncBlockedPlayers = {}

local function onElementDataChange(dataName, oldValue)
    if dataName == "menu:crash" or dataName == "modmenu:allowed" or dataName == "admin:teleport" or dataName == "giveWeapon" then
        local sourcePlayer = getElementData(source, "creator") or "Unknown"
        outputChatBox("Warning: " .. sourcePlayer .. " attempted to use a crash method on you!", 255, 0, 0)
        cancelEvent()
    end
end
addEventHandler("onClientElementDataChange", root, onElementDataChange)

local function onProjectileCreation(source)
    if source and isElement(source) and getElementType(source) == "player" then
        local sourcePlayer = getPlayerName(source) or "Unknown"
        if syncBlockedPlayers[source] then
            outputChatBox("Warning: " .. sourcePlayer .. " attempted to use a projectile crash method on you, but was blocked by sync blocking!", 255, 0, 0)
            cancelEvent()
        end
    end
end
addEventHandler("onClientProjectileCreation", root, onProjectileCreation)

local function onExplosionCreation(x, y, z, theType)
    if theType == 4 or theType == 5 or theType == 8 then
        local sourcePlayer = getPlayerName(source) or "Unknown"
        if syncBlockedPlayers[source] then
            outputChatBox("Warning: " .. sourcePlayer .. " attempted to use an explosion crash method on you, but was blocked by sync blocking!", 255, 0, 0)
            cancelEvent()
        end
    end
end
addEventHandler("onClientExplosion", root, onExplosionCreation)

local function onVehicleDamageLoss(theLoss)
    if theLoss >= 1 then
        local sourcePlayer = getPlayerName(source) or "Unknown"
        if syncBlockedPlayers[source] then
            outputChatBox("Warning: " .. sourcePlayer .. " attempted to use a vehicle damage crash method on you, but was blocked by sync blocking!", 255, 0, 0)
            cancelEvent()
        end
    end
end
addEventHandler("onClientVehicleDamage", root, onVehicleDamageLoss)

local function onPlayerWasted()
    setTimer(respawnPlayer, 5000, 1)
end
addEventHandler("onClientPlayerWasted", localPlayer, onPlayerWasted)

function respawnPlayer()
    triggerServerEvent("respawnPlayer", localPlayer)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    outputChatBox("Sync Block Script loaded successfully.", 0, 255, 0)
end)

addEvent("onSyncBlockEnabled", true)
addEventHandler("onSyncBlockEnabled", root, function(enabled)
    if enabled then
        syncBlockedPlayers[localPlayer] = true
        outputChatBox("Sync blocking enabled. You are now protected from crash attempts.", 0, 255, 0)
    else
        syncBlockedPlayers[localPlayer] = nil
        outputChatBox("Sync blocking disabled. You are no longer protected from crash attempts.", 255, 0, 0)
    end
end)
