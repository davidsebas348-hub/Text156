-- =========================
-- MINI FLING FULL con GETGENV
-- =========================

-- Poner aquí el nombre del jugador (parcial o con errores)
-- getgenv().TargetPlayerName = "seb"cambia wl nombre o copia para hacer fling

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Buscar jugador por Name o DisplayName parcialmente
local function findPlayer(name)
    name = name:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if string.find(player.Name:lower(), name) or string.find(player.DisplayName:lower(), name) then
            return player
        end
    end
    return nil
end

-- Función de fling
local function miniFling(playerToFling)
    if not playerToFling or not playerToFling.Character then
        warn("Jugador no válido o muerto")
        return
    end

    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local targetCharacter = playerToFling.Character
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")

    if not hrp or not humanoid or not targetHRP then return end

    -- Guardar posición original
    getgenv().OldPos = hrp.CFrame

    -- Crear BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(1e8, 1e8, 1e8)
    bv.Parent = hrp

    -- Cambiar cámara para seguir al objetivo
    workspace.CurrentCamera.CameraSubject = targetHRP

    -- Loop: mueve alrededor hasta que salga disparado
    repeat
        -- posiciones locas alrededor del jugador
        hrp.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
        task.wait(0.03)
        hrp.CFrame = targetHRP.CFrame + Vector3.new(0,-3,0)
        task.wait(0.03)
        hrp.CFrame = targetHRP.CFrame + Vector3.new(3,0,3)
        task.wait(0.03)
        hrp.CFrame = targetHRP.CFrame + Vector3.new(-3,0,-3)
        task.wait(0.03)
    until targetHRP.Velocity.Magnitude > 500 or not targetHRP.Parent or humanoid.Health <= 0

    -- Destruir BodyVelocity y devolver a la posición original
    bv:Destroy()
    hrp.CFrame = getgenv().OldPos
    workspace.CurrentCamera.CameraSubject = humanoid

    -- Reiniciar velocidades
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Velocity = Vector3.new()
            part.RotVelocity = Vector3.new()
        end
    end
end

-- Ejecutar
local target = findPlayer(getgenv().TargetPlayerName)
if target then
    miniFling(target)
else
    warn("No se encontró ningún jugador con ese nombre")
end
