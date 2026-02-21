-- ======================
-- ESP SOLO MURDER (OPTIMIZADO Y CORREGIDO)
-- ======================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ======================
-- TOGGLE GLOBAL
-- ======================
_G.MurderESP = not _G.MurderESP

-- ======================
-- LIMPIAR ESP
-- ======================
local function clearESP(player)
	if player.Character then
		local h = player.Character:FindFirstChild("MurderESP")
		if h then h:Destroy() end

		local g = player.Character:FindFirstChild("MurderLabel")
		if g then g:Destroy() end
	end
end

if not _G.MurderESP then
	for _, plr in ipairs(Players:GetPlayers()) do
		clearESP(plr)
	end
	warn("❌ ESP DESACTIVADO")
	return
end

warn("✅ ESP ACTIVADO")

-- ======================
-- CREAR ESP
-- ======================
local function applyESP(player)
	if not _G.MurderESP then return end
	if not player.Character then return end
	if player.Character:FindFirstChild("MurderESP") then return end

	local hl = Instance.new("Highlight")
	hl.Name = "MurderESP"
	hl.Adornee = player.Character
	hl.FillColor = Color3.fromRGB(255,0,0)
	hl.OutlineColor = Color3.fromRGB(255,0,0)
	hl.FillTransparency = 0.5
	hl.Parent = player.Character

	local gui = Instance.new("BillboardGui")
	gui.Name = "MurderLabel"
	gui.Adornee = player.Character:FindFirstChild("Head")
	gui.Size = UDim2.new(0,100,0,40)
	gui.StudsOffset = Vector3.new(0,2,0)
	gui.AlwaysOnTop = true
	gui.Parent = player.Character

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = "MURDER"
	txt.TextColor3 = Color3.fromRGB(255,0,0)
	txt.TextStrokeColor3 = Color3.fromRGB(0,0,0) -- borde negro
	txt.TextStrokeTransparency = 0
	txt.TextScaled = true
	txt.Font = Enum.Font.SourceSansBold
	txt.Parent = gui
end

-- ======================
-- VERIFICAR KNIFE
-- ======================
local function hasKnife(player)

	local function check(container)
		if not container then return false end
		for _, item in ipairs(container:GetChildren()) do
			if item:IsA("Tool") and item.Name == "Knife" then
				return true
			end
		end
		return false
	end

	return check(player.Character) or check(player:FindFirstChild("Backpack"))
end

-- ======================
-- ACTUALIZAR ESTADO
-- ======================
local function updatePlayer(player)
	if not _G.MurderESP then return end
	if player == LocalPlayer then return end
	if not player.Character then return end

	if hasKnife(player) then
		applyESP(player)
	else
		clearESP(player)
	end
end

-- ======================
-- MONITOREAR JUGADOR
-- ======================
local function monitorPlayer(player)
	if player == LocalPlayer then return end

	local function connectContainer(container)
		if not container then return end

		container.ChildAdded:Connect(function()
			updatePlayer(player)
		end)

		container.ChildRemoved:Connect(function()
			updatePlayer(player)
		end)
	end

	-- Backpack
	connectContainer(player:WaitForChild("Backpack"))

	-- Character
	if player.Character then
		connectContainer(player.Character)
		updatePlayer(player)
	end

	player.CharacterAdded:Connect(function(char)
		connectContainer(char)
		task.wait(0.2)
		updatePlayer(player)
	end)

	-- Check inicial
	updatePlayer(player)
end

-- ======================
-- APLICAR A TODOS
-- ======================
for _, plr in ipairs(Players:GetPlayers()) do
	monitorPlayer(plr)
end

Players.PlayerAdded:Connect(monitorPlayer)
