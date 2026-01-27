-- ======================
-- ESP SOLO MURDER (TOGGLE POR EJECUCIÓN)
-- ======================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ======================
-- TOGGLE GLOBAL
-- ======================
_G.MurderESP = not _G.MurderESP

-- ======================
-- FUNCIÓN LIMPIAR TODO
-- ======================
local function ClearESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			local h = plr.Character:FindFirstChild("MurderESP")
			if h then h:Destroy() end

			local g = plr.Character:FindFirstChild("MurderLabel")
			if g then g:Destroy() end
		end
	end
end

-- ======================
-- SI SE DESACTIVA
-- ======================
if not _G.MurderESP then
	if _G.MurderESPConnection then
		_G.MurderESPConnection:Disconnect()
		_G.MurderESPConnection = nil
	end
	ClearESP()
	warn("❌ ESP MURDER DESACTIVADO")
	return
end

warn("✅ ESP MURDER ACTIVADO")

-- ======================
-- FUNCIONES
-- ======================
local function isMurder(player)
	local function check(container)
		if not container then return false end
		for _, t in ipairs(container:GetChildren()) do
			if t:IsA("Tool") and t.Name == "Knife" then
				return true
			end
		end
	end
	return check(player.Character) or check(player:FindFirstChild("Backpack"))
end

local function applyESP(player)
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
	txt.TextScaled = true
	txt.Font = Enum.Font.SourceSansBold
	txt.Parent = gui
end

-- ======================
-- LOOP ÚNICO Y CONTROLADO
-- ======================
_G.MurderESPConnection = RunService.RenderStepped:Connect(function()
	if not _G.MurderESP then return end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			if isMurder(plr) then
				applyESP(plr)
			else
				local h = plr.Character:FindFirstChild("MurderESP")
				if h then h:Destroy() end
				local g = plr.Character:FindFirstChild("MurderLabel")
				if g then g:Destroy() end
			end
		end
	end
end)
