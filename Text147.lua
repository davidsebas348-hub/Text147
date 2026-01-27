-- ======================
-- X-RAY SIN AFECTAR GUN/COINS/JUGADORES
-- Toggle por ejecución
-- ======================

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Toggle global
if _G.XRayActive == nil then
    _G.XRayActive = false
end

-- Si ya estaba activo, desactivar y restaurar
if _G.XRayActive then
    _G.XRayActive = false

    -- Restaurar todas las transparencias
    if _G._XRayOriginalTransparency then
        for obj, trans in pairs(_G._XRayOriginalTransparency) do
            if obj and obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = trans
            end
        end
        _G._XRayOriginalTransparency = nil
    end

    print("❌ X-RAY desactivado")
    return
end

-- Activar X-RAY
_G.XRayActive = true
print("✅ X-RAY activado")

-- Nombres que ignoraremos
local ignoreNames = {"GunDrop"}
local ignoreContains = {"coin"}

-- Guardar transparencias originales
_G._XRayOriginalTransparency = {}

-- Función para saber si ignorar
local function shouldIgnore(obj)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and obj:IsDescendantOf(player.Character) then
            return true
        end
    end

    for _, name in ipairs(ignoreNames) do
        if obj.Name == name then return true end
    end

    for _, str in ipairs(ignoreContains) do
        if obj.Name:lower():find(str) then return true end
    end

    return false
end

-- Función aplicar X-RAY
local function applyXRay(obj)
    if not obj:IsA("BasePart") then return end
    if shouldIgnore(obj) then return end

    if not _G._XRayOriginalTransparency[obj] then
        _G._XRayOriginalTransparency[obj] = obj.LocalTransparencyModifier or 0
    end
    obj.LocalTransparencyModifier = 0.5
end

-- Loop principal
task.spawn(function()
    while _G.XRayActive do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            applyXRay(obj)
        end
        task.wait(2.5)
    end
end)
