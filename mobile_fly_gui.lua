local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera

local flying = false
local speed = 50
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Remove old GUI if exists
local oldGui = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("SleekFlyGui")
if oldGui then oldGui:Destroy() end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SleekFlyGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 120)
mainFrame.Position = UDim2.new(0.75, 0, 0.75, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- white
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 255, 255) -- cyan border
stroke.Thickness = 3

-- Title Bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
titleBar.ZIndex = 20

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Sleek Fly"
titleLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar
titleLabel.ZIndex = 25

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -36, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 22
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar
closeButton.ZIndex = 25
closeButton.AutoButtonColor = true

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Fly toggle button
local flyToggle = Instance.new("TextButton")
flyToggle.Size = UDim2.new(0, 200, 0, 40)
flyToggle.Position = UDim2.new(0, 20, 0, 50)
flyToggle.BackgroundColor3 = Color3.fromRGB(220, 255, 255)
flyToggle.TextColor3 = Color3.fromRGB(0, 70, 70)
flyToggle.Font = Enum.Font.GothamBold
flyToggle.TextSize = 20
flyToggle.Text = "Fly: OFF"
flyToggle.BorderSizePixel = 0
flyToggle.Parent = mainFrame
flyToggle.AutoButtonColor = true

local uicornerBtn = Instance.new("UICorner", flyToggle)
uicornerBtn.CornerRadius = UDim.new(0, 14)

-- Speed display label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 200, 0, 24)
speedLabel.Position = UDim2.new(0, 20, 0, 95)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(0, 100, 100)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 16
speedLabel.Text = "Speed: "..speed
speedLabel.TextXAlignment = Enum.TextXAlignment.Center
speedLabel.Parent = mainFrame

-- Speed adjustment buttons ( + and - )
local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.new(0, 30, 0, 30)
plusButton.Position = UDim2.new(0, 225, 0, 90)
plusButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(10, 10, 10)
plusButton.Font = Enum.Font.GothamBold
plusButton.TextSize = 24
plusButton.BorderSizePixel = 0
plusButton.Parent = mainFrame
plusButton.AutoButtonColor = true
local plusCorner = Instance.new("UICorner", plusButton)
plusCorner.CornerRadius = UDim.new(0, 8)

local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.new(0, 30, 0, 30)
minusButton.Position = UDim2.new(0, 190, 0, 90)
minusButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
minusButton.Text = "-"
minusButton.TextColor3 = Color3.fromRGB(10, 10, 10)
minusButton.Font = Enum.Font.GothamBold
minusButton.TextSize = 24
minusButton.BorderSizePixel = 0
minusButton.Parent = mainFrame
minusButton.AutoButtonColor = true
local minusCorner = Instance.new("UICorner", minusButton)
minusCorner.CornerRadius = UDim.new(0, 8)

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Fly mechanics from FlyGuiV3:
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local UIS = UserInputService
local flying = false
local ctrl = {W = false, A = false, S = false, D = false, Space = false, LeftControl = false}

local bg = Instance.new("BodyGyro")
local bv = Instance.new("BodyVelocity")

bg.P = 9e4
bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bv.Velocity = Vector3.new(0,0,0)

local function startFly()
	bg.Parent = hrp
	bv.Parent = hrp
	flying = true
end

local function stopFly()
	flying = false
	bg.Parent = nil
	bv.Parent = nil
end

flyToggle.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		flyToggle.Text = "Fly: OFF"
	else
		startFly()
		flyToggle.Text = "Fly: ON"
	end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then
		ctrl.W = true
	elseif input.KeyCode == Enum.KeyCode.A then
		ctrl.A = true
	elseif input.KeyCode == Enum.KeyCode.S then
		ctrl.S = true
	elseif input.KeyCode == Enum.KeyCode.D then
		ctrl.D = true
	elseif input.KeyCode == Enum.KeyCode.Space then
		ctrl.Space = true
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		ctrl.LeftControl = true
	end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then
		ctrl.W = false
	elseif input.KeyCode == Enum.KeyCode.A then
		ctrl.A = false
	elseif input.KeyCode == Enum.KeyCode.S then
		ctrl.S = false
	elseif input.KeyCode == Enum.KeyCode.D then
		ctrl.D = false
	elseif input.KeyCode == Enum.KeyCode.Space then
		ctrl.Space = false
	elseif input.KeyCode == Enum.KeyCode.LeftControl then
		ctrl.LeftControl = false
	end
end)

RunService.Heartbeat:Connect(function()
	if flying then
		bg.CFrame = workspace.CurrentCamera.CFrame
		local vel = Vector3.new()
		if ctrl.W then
			vel = vel + workspace.CurrentCamera.CFrame.LookVector
		end
		if ctrl.S then
			vel = vel - workspace.CurrentCamera.CFrame.LookVector
		end
		if ctrl.A then
			vel = vel - workspace.CurrentCamera.CFrame.RightVector
		end
		if ctrl.D then
			vel = vel + workspace.CurrentCamera.CFrame.RightVector
		end
		if ctrl.Space then
			vel = vel + Vector3.new(0,1,0)
		end
		if ctrl.LeftControl then
			vel = vel - Vector3.new(0,1,0)
		end

		if vel.Magnitude > 0 then
			vel = vel.Unit * speed
		end

		bv.Velocity = vel
	else
		bv.Velocity = Vector3.new(0,0,0)
	end
end)

plusButton.MouseButton1Click:Connect(function()
	speed += 10
	speedLabel.Text = "Speed: "..speed
end)

minusButton.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	speedLabel.Text = "Speed: "..speed
end)
