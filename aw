-- Auto Teleport Script - WORKING VERSION
-- Place as LocalScript in StarterPlayer > StarterCharacterScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleportPoint = nil
local canTeleport = true
local TELEPORT_COOLDOWN = 1

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTeleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0, 15, 0, 15)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 200, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚡ AUTO TELEPORT"
titleLabel.BorderSizePixel = 0
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = "Press P to set point"
statusLabel.Parent = mainFrame

-- Set teleport point
local function setPoint()
	teleportPoint = humanoidRootPart.Position + Vector3.new(0, 3, 0)
	statusLabel.Text = "✓ POINT SET - Grab tool to TP"
	statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	print("[TELEPORT] Point saved at:", teleportPoint)
end

-- Do teleport
local function teleport()
	if not teleportPoint then
		print("[TELEPORT] No point set! Press P")
		return
	end
	
	if not canTeleport then return end
	
	canTeleport = false
	humanoidRootPart.CFrame = CFrame.new(teleportPoint)
	statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
	print("[TELEPORT] TELEPORTED!")
	
	wait(TELEPORT_COOLDOWN)
	canTeleport = true
end

-- Key to set point
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.P then
		setPoint()
	end
end)

-- Main detection loop - check if holding tool every frame
RunService.RenderStepped:Connect(function()
	if not character or not humanoidRootPart then return end
	
	for _, item in pairs(character:GetChildren()) do
		if item:IsA("Tool") then
			-- Found a tool! Teleport
			teleport()
		end
	end
end)

-- Handle respawn
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	statusLabel.Text = "Respawned - Press P to set point"
	statusLabel.TextColor3 = Color3.fromRGB(200, 200, 100)
	print("[TELEPORT] Character respawned")
end)

print("[TELEPORT] Script loaded!")
print("[TELEPORT] Press P to set teleport point")
print("[TELEPORT] Grab ANY tool to auto teleport")
