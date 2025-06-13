-- mobile_fly_gui.lua (Insanely Cool Mobile Fly GUI)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera
local RS = game:GetService("RunService")
local flying = false
local speed = 60

if player:FindFirstChild("PlayerGui"):FindFirstChild("MobileFlyGUI") then
	player.PlayerGui.MobileFlyGUI:Destroy()
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "MobileFlyGUI"

local function applyUICorner(obj, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = obj
end

local function createFancyButton(name, text, position)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 120, 0, 45)
	btn.Position = position
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.Text = text
	btn.AutoButtonColor = false
	btn.BackgroundTransparency = 0.25
	btn.Parent = gui
	applyUICorner(btn, 12)
	local uiStroke = Instance.new("UIStroke", btn)
	uiStroke.Thickness = 2
	uiStroke.Color = Color3.fromRGB(0, 170, 255)
	uiStroke.Transparency = 0.25
	return btn
end

local flyBtn = createFancyButton("FlyBtn", "Fly: OFF", UDim2.new(1, -135, 1, -60))
local plusBtn = createFancyButton("SpeedUp", "Speed+ (60)", UDim2.new(1, -275, 1, -60))
local minusBtn = createFancyButton("SpeedDown", "Speed- (60)", UDim2.new(1, -415, 1, -60))

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new()
bv.Velocity = Vector3.new()

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new()
bg.P = 9e4
bg.CFrame = hrp.CFrame

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyBtn.Text = "Fly: ON"
		bv.Parent = hrp
		bg.Parent = hrp
		bv.MaxForce = Vector3.new(999999, 999999, 999999)
		bg.MaxTorque = Vector3.new(999999, 999999, 999999)
	else
		flyBtn.Text = "Fly: OFF"
		bv.MaxForce = Vector3.new()
		bg.MaxTorque = Vector3.new()
		bv.Parent = nil
		bg.Parent = nil
	end
end)

plusBtn.MouseButton1Click:Connect(function()
	speed = speed + 10
	plusBtn.Text = "Speed+ ("..speed..")"
	minusBtn.Text = "Speed- ("..speed..")"
end)

minusBtn.MouseButton1Click:Connect(function()
	speed = math.max(10, speed - 10)
	plusBtn.Text = "Speed+ ("..speed..")"
	minusBtn.Text = "Speed- ("..speed..")"
end)

RS.RenderStepped:Connect(function()
	if flying then
		local moveDirection = cam.CFrame.LookVector
		bv.Velocity = moveDirection * speed
		bg.CFrame = cam.CFrame
	end
end)
