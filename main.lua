local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
if not localPlayer then return end

-- Clean up older GUI instances
local oldGui = localPlayer:WaitForChild("PlayerGui"):FindFirstChild("CoolAttachGui")
if oldGui then oldGui:Destroy() end

--------------------------------------------------------------------------------
-- GUI CREATION & STYLING
--------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolAttachGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Main Container Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 360) -- Resized to accommodate Keybind option
mainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

-- Gradient Overlay
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 38)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

-- Neon Border Stroke
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 1.5
uiStroke.Color = Color3.fromRGB(80, 80, 110)
uiStroke.Transparency = 0.3
uiStroke.Parent = mainFrame

-- Header Bar
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "zepti's dick gui"
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -25, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
statusDot.Parent = header

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- Separator Line
local line = Instance.new("Frame")
line.Size = UDim2.new(1, -30, 0, 1)
line.Position = UDim2.new(0, 15, 0, 42)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.9
line.BorderSizePixel = 0
line.Parent = mainFrame

-- Helper UI Generator
local function createInputContainer(posY, placeholderText)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -30, 0, 36)
	container.Position = UDim2.new(0, 15, 0, posY)
	container.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
	container.BorderSizePixel = 0
	container.Parent = mainFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(60, 60, 80)
	stroke.Transparency = 0.5
	stroke.Parent = container

	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(1, -20, 1, 0)
	textBox.Position = UDim2.new(0, 10, 0, 0)
	textBox.PlaceholderText = placeholderText
	textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
	textBox.Text = ""
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.Font = Enum.Font.GothamMedium
	textBox.TextSize = 12
	textBox.BackgroundTransparency = 1
	textBox.TextXAlignment = Enum.TextXAlignment.Left
	textBox.Parent = container

	return container, textBox
end

-- Target Player Input Box
local _, playerBox = createInputContainer(54, "Target Player...")

-- Speed Input Box
local speedContainer, speedBox = createInputContainer(98, "Wave Speed (Default: 2)")
speedBox.Text = "2"

--------------------------------------------------------------------------------
-- CUSTOM MODE DROPDOWN
--------------------------------------------------------------------------------
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(1, -30, 0, 36)
dropdownBtn.Position = UDim2.new(0, 15, 0, 142)
dropdownBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
dropdownBtn.Text = "  Mode: Head (Front)"
dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
dropdownBtn.Font = Enum.Font.GothamMedium
dropdownBtn.TextSize = 12
dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
dropdownBtn.AutoButtonColor = false
dropdownBtn.Parent = mainFrame

local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 8)
dropdownCorner.Parent = dropdownBtn

local dropdownStroke = Instance.new("UIStroke")
dropdownStroke.Thickness = 1
dropdownStroke.Color = Color3.fromRGB(60, 60, 80)
dropdownStroke.Transparency = 0.5
dropdownStroke.Parent = dropdownBtn

local arrow = Instance.new("TextLabel")
arrow.Size = UDim2.new(0, 20, 1, 0)
arrow.Position = UDim2.new(1, -25, 0, 0)
arrow.Text = "▼"
arrow.TextColor3 = Color3.fromRGB(140, 140, 160)
arrow.Font = Enum.Font.GothamMedium
arrow.TextSize = 10
arrow.BackgroundTransparency = 1
arrow.Parent = dropdownBtn

-- Dropdown Menu Container
local dropdownMenu = Instance.new("Frame")
dropdownMenu.Size = UDim2.new(1, -30, 0, 0)
dropdownMenu.Position = UDim2.new(0, 15, 0, 182)
dropdownMenu.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
dropdownMenu.ClipsDescendants = true
dropdownMenu.ZIndex = 5
dropdownMenu.Visible = false
dropdownMenu.Parent = mainFrame

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 8)
menuCorner.Parent = dropdownMenu

local menuStroke = Instance.new("UIStroke")
menuStroke.Thickness = 1
menuStroke.Color = Color3.fromRGB(80, 80, 110)
menuStroke.Parent = dropdownMenu

local modes = {
	{Name = "Head (Front)", ID = "HeadFront"},
	{Name = "Humanoid (Back)", ID = "HRPBack"}
}

local currentMode = "HeadFront"
local isDropdownOpen = false

local function createMenuOption(posY, modeData)
	local optBtn = Instance.new("TextButton")
	optBtn.Size = UDim2.new(1, 0, 0, 32)
	optBtn.Position = UDim2.new(0, 0, 0, posY)
	optBtn.BackgroundTransparency = 1
	optBtn.Text = "   " .. modeData.Name
	optBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	optBtn.Font = Enum.Font.GothamMedium
	optBtn.TextSize = 12
	optBtn.TextXAlignment = Enum.TextXAlignment.Left
	optBtn.ZIndex = 6
	optBtn.Parent = dropdownMenu

	optBtn.MouseEnter:Connect(function()
		TweenService:Create(optBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.9}):Play()
	end)
	optBtn.MouseLeave:Connect(function()
		TweenService:Create(optBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 200), BackgroundTransparency = 1}):Play()
	end)

	optBtn.MouseButton1Click:Connect(function()
		currentMode = modeData.ID
		dropdownBtn.Text = "  Mode: " .. modeData.Name
		
		isDropdownOpen = false
		TweenService:Create(dropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -30, 0, 0)}):Play()
		TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
		task.wait(0.2)
		dropdownMenu.Visible = false
	end)
end

for i, modeData in ipairs(modes) do
	createMenuOption((i - 1) * 32, modeData)
end

dropdownBtn.MouseButton1Click:Connect(function()
	isDropdownOpen = not isDropdownOpen
	if isDropdownOpen then
		dropdownMenu.Visible = true
		TweenService:Create(dropdownMenu, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -30, 0, 64)}):Play()
		TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
	else
		TweenService:Create(dropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -30, 0, 0)}):Play()
		TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
		task.wait(0.2)
		if not isDropdownOpen then dropdownMenu.Visible = false end
	end
end)

--------------------------------------------------------------------------------
-- KEYBIND BUTTON UI
--------------------------------------------------------------------------------
local keybindBtn = Instance.new("TextButton")
keybindBtn.Size = UDim2.new(1, -30, 0, 36)
keybindBtn.Position = UDim2.new(0, 15, 0, 186)
keybindBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
keybindBtn.Text = "  Toggle Keybind: [ E ]"
keybindBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
keybindBtn.Font = Enum.Font.GothamMedium
keybindBtn.TextSize = 12
keybindBtn.TextXAlignment = Enum.TextXAlignment.Left
keybindBtn.AutoButtonColor = false
keybindBtn.Parent = mainFrame

local keybindCorner = Instance.new("UICorner")
keybindCorner.CornerRadius = UDim.new(0, 8)
keybindCorner.Parent = keybindBtn

local keybindStroke = Instance.new("UIStroke")
keybindStroke.Thickness = 1
keybindStroke.Color = Color3.fromRGB(60, 60, 80)
keybindStroke.Transparency = 0.5
keybindStroke.Parent = keybindBtn

--------------------------------------------------------------------------------
-- TOGGLE BUTTON
--------------------------------------------------------------------------------
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -30, 0, 42)
toggleBtn.Position = UDim2.new(0, 15, 0, 290)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 70)
toggleBtn.Text = "ENABLE"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleBtn

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 40, 60))
})
toggleGradient.Parent = toggleBtn

--------------------------------------------------------------------------------
-- CORE ATTACHMENT & EMOTE LOGIC
--------------------------------------------------------------------------------
local isActive = false
local waveSpeed = 2
local renderConn = nil
local originalCFrame = nil
local activeAnimTrack = nil
local ANIM_ID = "124874696448567"

local currentKeybind = Enum.KeyCode.E
local isListeningForKey = false

-- Keybind listener setting
keybindBtn.MouseButton1Click:Connect(function()
	if isListeningForKey then return end
	isListeningForKey = true
	keybindBtn.Text = "  Toggle Keybind: [ Press Key... ]"
end)

-- Helper to stop and clean up animation track
local function stopEmote()
	if activeAnimTrack then
		activeAnimTrack:Stop()
		activeAnimTrack:Destroy()
		activeAnimTrack = nil
	end
end

-- Clean up on death
local function setupDeathCleanup(char)
	local humanoid = char:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.Died:Connect(function()
			if renderConn then renderConn:Disconnect() end
			stopEmote()
			screenGui:Destroy()
		end)
	end
end

if localPlayer.Character then setupDeathCleanup(localPlayer.Character) end
localPlayer.CharacterAdded:Connect(setupDeathCleanup)

local function findTargetPlayer(name)
	if name == "" then return nil end
	name = string.lower(name)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= localPlayer then
			if string.find(string.lower(p.Name), name) or string.find(string.lower(p.DisplayName), name) then
				return p
			end
		end
	end
	return nil
end

local function getTriangleWave(t, period)
	local p = (t % period) / period
	return p < 0.5 and (p * 2) or (2 - p * 2)
end

local function toggleState()
	isActive = not isActive
	local subjectChar = localPlayer.Character
	local subjectHRP = subjectChar and subjectChar:FindFirstChild("HumanoidRootPart")
	local subjectHumanoid = subjectChar and subjectChar:FindFirstChildOfClass("Humanoid")

	if isActive then
		if subjectHRP then originalCFrame = subjectHRP.CFrame end

		-- Load and Play the Custom Animation
		if subjectHumanoid then
			local animator = subjectHumanoid:FindFirstChildOfClass("Animator") or subjectHumanoid:WaitForChild("Animator", 2)
			if animator then
				local anim = Instance.new("Animation")
				anim.AnimationId = "rbxassetid://" .. ANIM_ID
				
				activeAnimTrack = animator:LoadAnimation(anim)
				activeAnimTrack.Priority = Enum.AnimationPriority.Action4
				activeAnimTrack.Looped = true
				activeAnimTrack:Play()
			end
		end

		-- Visual state update (ON)
		toggleBtn.Text = "DISABLE"
		toggleGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 200, 120)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 140, 80))
		})
		TweenService:Create(statusDot, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 220, 120)}):Play()

		renderConn = RunService.RenderStepped:Connect(function()
			local targetPlayer = findTargetPlayer(playerBox.Text)
			local char = localPlayer.Character
			if not targetPlayer or not targetPlayer.Character or not char then return end

			local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp or not targetHRP then return end

			-- Disable collision during effect
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end

			local alpha = getTriangleWave(workspace:GetServerTimeNow() * waveSpeed, 1)
			local finalCFrame = CFrame.new()

			if currentMode == "HeadFront" then
				local targetHead = targetPlayer.Character:FindFirstChild("Head")
				if not targetHead then return end
				
				-- Align bottom edge of HumanoidRootPart to target's head
				local hrpBottomEdgeOffset = hrp.Size.Y / 2
				local headFrontOffset = targetHead.Size.Z / 2
				local zPos = -headFrontOffset - (alpha * 3)

				finalCFrame = targetHead.CFrame 
					* CFrame.new(0, hrpBottomEdgeOffset, zPos) 
					* CFrame.Angles(0, math.pi, 0)

			elseif currentMode == "HRPBack" then
				local hrpBackOffset = targetHRP.Size.Z / 2
				local zPos = hrpBackOffset + (alpha * 3)

				finalCFrame = targetHRP.CFrame * CFrame.new(0, 0, zPos)
			end

			hrp.CFrame = finalCFrame
		end)
	else
		-- Visual state update (OFF)
		toggleBtn.Text = "ENABLE"
		toggleGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 90)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 40, 60))
		})
		TweenService:Create(statusDot, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 60, 80)}):Play()

		if renderConn then
			renderConn:Disconnect()
			renderConn = nil
		end

		-- Stop the Animation
		stopEmote()

		-- Teleport back and restore collisions
		if subjectChar and subjectHRP and originalCFrame then
			subjectHRP.CFrame = originalCFrame
			for _, part in ipairs(subjectChar:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = true
				end
			end
		end
	end
end

toggleBtn.MouseButton1Click:Connect(toggleState)

--------------------------------------------------------------------------------
-- KEYBOARD INPUT HANDLING
--------------------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if isListeningForKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			currentKeybind = input.KeyCode
			keybindBtn.Text = "  Toggle Keybind: [ " .. input.KeyCode.Name .. " ]"
			isListeningForKey = false
		end
		return
	end

	-- Ignore keybind triggers when typing in textboxes
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKeybind then
		toggleState()
	end
end)

speedBox:GetPropertyChangedSignal("Text"):Connect(function()
	local val = tonumber(speedBox.Text)
	if val then waveSpeed = val end
end)
