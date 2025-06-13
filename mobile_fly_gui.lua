-- Improved Fly GUI (mobile friendly, sleek design)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
local RS = game:GetService("RunService")

local flying = false
local speed = 60

-- Remove old GUI
if player:FindFirstChild("PlayerGui"):FindFirstChild("FlyGuiV3") then
	player.PlayerGui.FlyGuiV3:Destroy()
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyGuiV3"
gui.ResetOnSpawn = false

-- Helper: add rounded corners
local function applyUICorner(inst, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = inst
end

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(1, -300, 1, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
applyUICorner(mainFrame, 14)

-- Shadow/glow effect
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 150, 255)
uiStroke.Parent = mainFrame
uiStroke.LineJoinMode = Enum.LineJoinMode.Round

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Fly GUI V3"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.Parent = mainFrame

-- Fly toggle button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0, 240, 0, 45)
flyBtn.Position = UDim2.new(0, 20, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextScaled = true
flyBtn.Text = "Fly: OFF"
flyBtn.Parent = mainFrame
applyUICorner(flyBtn, 10)

-- Speed+ button
local speedUpBtn = Instance.new("TextButton")
speedUpBtn.Size = UDim2.new(0, 110, 0, 45)
speedUpBtn.Position = UDim2.new(0, 20, 0, 95)
speedUpBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
speedUpBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
speedUpBtn.Font = Enum.Font.GothamBold
speedUpBtn.TextScaled = true
speedUpBtn.Text = "Speed + (" .. speed .. ")"
speedUpBtn.Parent = mainFrame
applyUICorner(speedUpBtn, 10)

-- Speed- button
local speedDownBtn = Instance.new("TextButton")
speedDownBtn.Size = UDim2.new(0, 110, 0, 45)
speedDownBtn.Position = UDim2.new(0, 150, 0, 95)
speedDownBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
speedDownBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
speedDownBtn.Font = Enum.Font.GothamBold
speedDownBtn.TextScaled = true
speedDownBtn.Text = "Speed - (" .. speed .. ")"
speedDownBtn.Parent = mainFrame
applyUICorner(speedDownBtn, 10)

-- Toggle button (show/hide GUI)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(1, -50, 1, -270)
toggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
toggleBtn.TextColor3 = Color3.fromRGB(0, 150, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.Text = "☰"
toggleBtn.Parent = gui
applyUICorner(toggleBtn, 12)

-- BodyVelocity and BodyGyro for flying
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new()
bv.Velocity = Vector3.new()

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new()
bg.P = 9e4
bg.CFrame = hrp.CFrame

-- Fly toggle logic
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

-- Speed controls
speedUpBtn.MouseButton1Click:Connect(function()
	speed += 10
	speedUpBtn.Text = "Speed + (" .. speed .. ")"
	speedDownBtn.Text = "Speed - (" .. speed .. ")"
end)

speedDownBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	speedUpBtn.Text = "Speed + (" .. speed .. ")"
	speedDownBtn.Text = "Speed - (" .. speed .. ")"
end)

-- Toggle GUI visibility
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Flying control
RS.RenderStepped:Connect(function()
	if flying then
		local moveDir = cam.CFrame.LookVector
		bv.Velocity = moveDir * speed
		bg.CFrame = cam.CFrame
	end
end)
