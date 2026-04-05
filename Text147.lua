-- ======================
-- X-RAY CONFIGURABLE
-- SIN GUN / COINS / PLAYERS
-- ======================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- CONFIG
getgenv().XRAY_TRANSPARENCY = getgenv().XRAY_TRANSPARENCY or 0.5
getgenv().XRAY_ENABLED = not (getgenv().XRAY_ENABLED or false)

-- Si ya existe loop anterior, apagarlo
if getgenv().XRAY_CONNECTION then
    getgenv().XRAY_CONNECTION = false
end

-- Desactivar y restaurar
if not getgenv().XRAY_ENABLED then
    if getgenv().XRAY_ORIGINAL then
        for obj, trans in pairs(getgenv().XRAY_ORIGINAL) do
            if obj and obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = trans
            end
        end
    end

    getgenv().XRAY_ORIGINAL = {}
    return
end

local ignoreNames = {"GunDrop"}
local ignoreContains = {"coin"}

getgenv().XRAY_ORIGINAL = getgenv().XRAY_ORIGINAL or {}
getgenv().XRAY_CONNECTION = true

local function shouldIgnore(obj)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and obj:IsDescendantOf(player.Character) then
            return true
        end
    end

    for _, name in ipairs(ignoreNames) do
        if obj.Name == name then
            return true
        end
    end

    local lowerName = obj.Name:lower()
    for _, str in ipairs(ignoreContains) do
        if lowerName:find(str) then
            return true
        end
    end

    return false
end

local function applyXRay(obj)
    if not obj:IsA("BasePart") then
        return
    end

    if shouldIgnore(obj) then
        return
    end

    if getgenv().XRAY_ORIGINAL[obj] == nil then
        getgenv().XRAY_ORIGINAL[obj] = obj.LocalTransparencyModifier
    end

    obj.LocalTransparencyModifier = getgenv().XRAY_TRANSPARENCY
end

task.spawn(function()
    while getgenv().XRAY_ENABLED and getgenv().XRAY_CONNECTION do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            applyXRay(obj)
        end
        task.wait(1)
    end
end)
