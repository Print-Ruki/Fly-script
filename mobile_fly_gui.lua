local player = game.Players.LocalPlayer
local guiName = "FlyGuiV3"

-- Remove old GUI if exists
if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild(guiName) then
	player.PlayerGui[guiName]:Destroy()
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame (Movable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 180)
mainFrame.Position = UDim2.new(0.7, 0, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true -- Needed for drag

-- UI corner for smooth edges
local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 16)

-- UI stroke for subtle border glow
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 140, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3

-- Title bar for drag
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Fly GUI V3"
titleText.TextColor3 = Color3.fromRGB(170, 220, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.Parent = titleBar
closeBtn.AutoButtonColor = true

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Helper function to create buttons
local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 280, 0, 45)
	btn.Position = UDim2.new(0, 20, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.BorderSizePixel = 0
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.AutoButtonColor = true
	btn.Parent = mainFrame
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)
	return btn
end

local flyBtn = createButton("Fly: OFF", 50)
local speedUpBtn = createButton("Speed + (60)", 100)
local speedDownBtn = createButton("Speed - (60)", 150)

-- BodyVelocity and BodyGyro for flying
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")
bv.MaxForce = Vector3.new()
bv.Velocity = Vector3.new()
bg.MaxTorque = Vector3.new()
bg.P = 9e4
bg.CFrame = hrp.CFrame

-- Flying toggle logic
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyBtn.Text = "Fly: ON"
		bv.Parent = hrp
		bg.Parent = hrp
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	else
		flyBtn.Text = "Fly: OFF"
		bv.MaxForce = Vector3.new()
		bg.MaxTorque = Vector3.new()
		bv.Parent = nil
		bg.Parent = nil
	end
end)

-- Speed change buttons
speedUpBtn.MouseButton1Click:Connect(function()
	speed = speed + 10
	speedUpBtn.Text = "Speed + ("..speed..")"
	speedDownBtn.Text = "Speed - ("..speed..")"
end)

speedDownBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	speedUpBtn.Text = "Speed + ("..speed..")"
	speedDownBtn.Text = "Speed - ("..speed..")"
end)

-- Drag functionality
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

-- Update velocity each frame when flying
RunService.RenderStepped:Connect(function()
	if flying then
		local camCFrame = cam.CFrame
		bv.Velocity = camCFrame.LookVector * speed
		bg.CFrame = camCFrame
	end
end)
