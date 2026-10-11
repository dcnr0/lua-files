-- LocalScript inside StarterPlayer -> StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- WalkSpeed settings
local NORMAL_SPEED = 16
local SLOW_SPEED = 0.01 -- Set to 0.01 WalkSpeed

-- Toggle State & Default Keybind
local isSlowModeActive = false
local boundKey = Enum.KeyCode.E

--------------------------------------------------------------------------------
-- Character Handling
--------------------------------------------------------------------------------
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function applySpeed()
	if humanoid then
		humanoid.WalkSpeed = isSlowModeActive and SLOW_SPEED or NORMAL_SPEED
	end
end

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	applySpeed()
end)

--------------------------------------------------------------------------------
-- GUI Setup
--------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SlowModeGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.85, 0, 0.75, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Toggle Button / Status Indicator
local statusBtn = Instance.new("TextButton")
statusBtn.Size = UDim2.new(0.9, 0, 0.38, 0)
statusBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
statusBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
statusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
statusBtn.Text = "Slow Mode: OFF"
statusBtn.Font = Enum.Font.SourceSansBold
statusBtn.TextSize = 16
statusBtn.Parent = frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusBtn

-- Keybind Change Button
local rebindBtn = Instance.new("TextButton")
rebindBtn.Size = UDim2.new(0.9, 0, 0.38, 0)
rebindBtn.Position = UDim2.new(0.05, 0, 0.52, 0)
rebindBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rebindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rebindBtn.Text = "Keybind: [ E ] (Click)"
rebindBtn.Font = Enum.Font.SourceSans
rebindBtn.TextSize = 13
rebindBtn.Parent = frame

local rebindCorner = Instance.new("UICorner")
rebindCorner.CornerRadius = UDim.new(0, 6)
rebindCorner.Parent = rebindBtn

--------------------------------------------------------------------------------
-- Controls & Events
--------------------------------------------------------------------------------
local isRebinding = false

local function toggleSlowMode()
	isSlowModeActive = not isSlowModeActive
	if isSlowModeActive then
		statusBtn.Text = "Slow Mode: ON"
		statusBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
	else
		statusBtn.Text = "Slow Mode: OFF"
		statusBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	end
	applySpeed()
end

-- Click button to toggle
statusBtn.MouseButton1Click:Connect(toggleSlowMode)

-- Keyboard Input
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if isRebinding and input.UserInputType == Enum.UserInputType.Keyboard then
		boundKey = input.KeyCode
		rebindBtn.Text = "Keybind: [ " .. boundKey.Name .. " ]"
		isRebinding = false
		return
	end
	
	if input.KeyCode == boundKey then
		toggleSlowMode()
	end
end)

-- Click to rebind
rebindBtn.MouseButton1Click:Connect(function()
	isRebinding = true
	rebindBtn.Text = "Press Any Key..."
end)

-- Enforce active speed state
RunService.RenderStepped:Connect(applySpeed)
