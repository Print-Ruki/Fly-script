local player = game.Players.LocalPlayer
local guiName = "FreshFlyUI"

if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild(guiName) then
	player.PlayerGui[guiName]:Destroy()
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local cam = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60

-- ScreenGui setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Circular toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "🛫"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 28
toggleBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.AutoButtonColor = true
toggleBtn.Parent = screenGui
toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
local toggleUICorner = Instance.new("UICorner", toggleBtn)
toggleUICorner.CornerRadius = UDim.new(1, 0) -- fully round circle

-- Main control panel (starts hidden, positioned left offscreen)
local mainPanel = Instance.new("Frame")
mainPanel.Size = UDim2.new(0, 250, 0, 180)
mainPanel.Position = UDim2.new(-1, 0, 0.5, -90)
mainPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainPanel.BorderSizePixel = 0
mainPanel.Parent = screenGui
mainPanel.AnchorPoint = Vector2.new(0, 0.5)
local panelCorner = Instance.new("UICorner", mainPanel)
panelCorner.CornerRadius = UDim.new(0, 18)
local panelShadow = Instance.new("ImageLabel", mainPanel)
panelShadow.Size = UDim2.new(1, 20, 1, 20)
panelShadow.Position = UDim2.new(0, -10, 0, -10)
panelShadow.BackgroundTransparency = 1
panelShadow.Image = "rbxassetid://1316045217" -- subtle shadow image
panelShadow.ImageColor3 = Color3.new(0,0,0)
panelShadow.ImageTransparency = 0.85
panelShadow.ZIndex = 0

-- Panel header (for dragging)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
header.BorderSizePixel = 0
header.Parent = mainPanel
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 18)

local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(1, -40, 1, 0)
headerLabel.Position = UDim2.new(0, 20, 0, 0)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "Fly Controller"
headerLabel.Font = Enum.Font.GothamBold
headerLabel.TextSize = 18
headerLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
headerLabel.TextXAlignment = Enum.TextXAlignment.Left
headerLabel.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Parent = header
closeBtn.AutoButtonColor = true

closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0.5, -90)}):Play()
end)

toggleBtn.MouseButton1Click:Connect(function()
	if mainPanel.Position.X.Scale < 0 then
		TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0.5, -90)}):Play()
	else
		TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0.5, -90)}):Play()
	end
end)

-- Fly toggle switch label
local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(0, 150, 0, 35)
flyLabel.Position = UDim2.new(0, 20, 0, 50)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly:"
flyLabel.Font = Enum.Font.GothamBold
flyLabel.TextSize = 18
flyLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.Parent = mainPanel

local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0, 60, 0, 30)
flyToggle.Position = UDim2.new(0, 180, 0, 50)
flyToggle.BackgroundColor3 = Color3.fromRGB(220, 255, 255)
flyToggle.BorderSizePixel = 0
flyToggle.TextColor3 = Color3.fromRGB(0, 50, 50)
flyToggle.Text = "OFF"
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 18
flyToggle.Parent = mainPanel
local flyToggleCorner = Instance.new("UICorner", flyToggle)
flyToggleCorner.CornerRadius = UDim.new(0, 10)

flyToggle.MouseButton1Click:Connect(function()
	flying = not flying
	flyToggle.Text = flying and "ON" or "OFF"
	if flying then
		bv.Parent = hrp
		bg.Parent = hrp
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	else
		bv.MaxForce = Vector3.new()
		bg.MaxTorque = Vector3.new()
		bv.Parent = nil
		bg.Parent = nil
	end
end)

-- Speed slider UI
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 220, 0, 30)
speedLabel.Position = UDim2.new(0, 20, 0, 100)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..speed
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainPanel

local speedSliderBG = Instance.new("Frame")
speedSliderBG.Size = UDim2.new(0, 210, 0, 12)
speedSliderBG.Position = UDim2.new(0, 20, 0, 140)
speedSliderBG.BackgroundColor3 = Color3.fromRGB(220, 255, 255)
speedSliderBG.BorderSizePixel = 0
speedSliderBG.Parent = mainPanel
local speedSliderCorner = Instance.new("UICorner", speedSliderBG)
speedSliderCorner.CornerRadius = UDim.new(1, 0)

local speedSliderFill = Instance.new("Frame")
speedSliderFill.Size = UDim2.new(speed/150, 0, 1, 0)
speedSliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
speedSliderFill.BorderSizePixel = 0
speedSliderFill.Parent = speedSliderBG
local speedFillCorner = Instance.new("UICorner", speedSliderFill)
speedFillCorner.CornerRadius = UDim.new(1, 0)

local draggingSlider = false
speedSliderBG.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
	end
end)
speedSliderBG.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = false
	end
end)
speedSliderBG.InputChanged:Connect(function(input)
	if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local x = math.clamp(input.Position.X - speedSliderBG.AbsolutePosition.X, 0, speedSliderBG.AbsoluteSize.X)
		local ratio = x / speedSliderBG.AbsoluteSize.X
		speed = math.floor(ratio * 140) + 10 -- min 10, max 150
		speedSliderFill.Size = UDim2.new(ratio, 0, 1, 0)
		speedLabel.Text = "Speed: "..speed
	end
end)

-- Movable panel dragging
local draggingPanel = false
local dragInputPanel
local dragStartPanel
local startPosPanel

local function updatePanel(input)
	local delta = input.Position - dragStartPanel
	mainPanel.Position = UDim2.new(startPosPanel.X.Scale, startPosPanel.X.Offset + delta.X, startPosPanel.Y.Scale, startPosPanel.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingPanel = true
		dragStartPanel = input.Position
		startPosPanel = mainPanel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingPanel = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInputPanel = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInputPanel and draggingPanel then
		updatePanel(input)
	end
end)

-- BodyVelocity and BodyGyro for flying
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")
bv.MaxForce = Vector3.new()
bv.Velocity = Vector3.new()
bg.MaxTorque = Vector3.new()
bg.P = 9e4
bg.CFrame = hrp.CFrame

local keysDown = {}

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.W or key == Enum.KeyCode.Up then
		keysDown["forward"] = true
	elseif key == Enum.KeyCode.S or key == Enum.KeyCode.Down then
		keysDown["backward"] = true
	elseif key == Enum.KeyCode.A or key == Enum.KeyCode.Left then
		keysDown["left"] = true
	elseif key == Enum.KeyCode.D or key == Enum.KeyCode.Right then
		keysDown["right"] = true
	elseif input.UserInputType == Enum.UserInputType.Touch then
		-- For mobile: map touch controls here if needed
	end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
	if gpe then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.W or key == Enum.KeyCode.Up then
		keysDown["forward"] = false
	elseif key == Enum.KeyCode.S or key == Enum.KeyCode.Down then
		keysDown["backward"] = false
	elseif key == Enum.KeyCode.A or key == Enum.KeyCode.Left then
		keysDown["left"] = false
	elseif key == Enum.KeyCode.D or key == Enum.KeyCode.Right then
		keysDown["right"] = false
	end
end)

RunService.RenderStepped:Connect(function()
	if flying then
		local camCFrame = cam.CFrame
		local moveVec = Vector3.new()
		if keysDown["forward"] then moveVec += camCFrame.LookVector end
		if keysDown["backward"] then moveVec -= camCFrame.LookVector end
		if keysDown["left"] then moveVec -= camCFrame.RightVector end
		if keysDown["right"] then moveVec += camCFrame.RightVector end

		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit * speed
		else
			moveVec = Vector3.new()
		end

		bv.Velocity = moveVec
		bg.CFrame = camCFrame
	end
end)
