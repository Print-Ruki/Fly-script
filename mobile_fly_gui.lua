local player = game.Players.LocalPlayer
local guiName = "FlyGuiV3"

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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 130) -- more compact size
mainFrame.Position = UDim2.new(0.7, 0, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- white
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 255, 255) -- cyan
stroke.Thickness = 3
stroke.Transparency = 0

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255) -- cyan
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Fly GUI V3"
titleText.TextColor3 = Color3.fromRGB(20, 20, 20)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 17
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.Parent = titleBar
closeBtn.AutoButtonColor = true

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 38)
	btn.Position = UDim2.new(0, 20, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(220, 255, 255)
	btn.BorderSizePixel = 0
	btn.TextColor3 = Color3.fromRGB(0, 50, 50)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.AutoButtonColor = true
	btn.Parent = mainFrame
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)
	return btn
end

local flyBtn = createButton("Fly: OFF", 40)
local speedUpBtn = createButton("Speed + (60)", 85)
local speedDownBtn = createButton("Speed - (60)", 130)

local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")
bv.MaxForce = Vector3.new()
bv.Velocity = Vector3.new()
bg.MaxTorque = Vector3.new()
bg.P = 9e4
bg.CFrame = hrp.CFrame

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

speedUpBtn.MouseButton1Click:Connect(function()
	speed += 10
	speedUpBtn.Text = "Speed + ("..speed..")"
	speedDownBtn.Text = "Speed - ("..speed..")"
end)

speedDownBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	speedUpBtn.Text = "Speed + ("..speed..")"
	speedDownBtn.Text = "Speed - ("..speed..")"
end)

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
		local forward = Vector3.new()
		if keysDown["forward"] then forward += camCFrame.LookVector end
		if keysDown["backward"] then forward -= camCFrame.LookVector end
		if keysDown["left"] then forward -= camCFrame.RightVector end
		if keysDown["right"] then forward += camCFrame.RightVector end

		forward = forward.Unit * speed
		if forward ~= forward then forward = Vector3.new() end

		bv.Velocity = forward
		bg.CFrame = camCFrame
	end
end)
