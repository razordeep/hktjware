getgenv().Aimbot = {
    Status = true,
    Keybind  = 'C',
    Hitpart = 'HumanoidRootPart',
    ['Prediction'] = {
        X = 0.1,  -- Changed starting value to 0.1
        Y = 0.1,
    },
}

if getgenv().AimbotRan then
    return
else
    getgenv().AimbotRan = true
end

local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Player = nil -- target player

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Enabled = true -- Ensure GUI is visible
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 300, 0, 500)
MenuFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MenuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MenuFrame.BorderSizePixel = 2
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Red outline
MenuFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MenuFrame.Parent = ScreenGui

-- Rounded corners for MenuFrame
local MenuCorner = Instance.new("UICorner", MenuFrame)
MenuCorner.CornerRadius = UDim.new(0, 15)

-- Header
local Header = Instance.new("TextLabel", MenuFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Header.Text = "hktjware"
Header.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text
Header.TextScaled = true
Header.BorderSizePixel = 2
Header.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Red outline
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 15)

-- Prediction X label
local PredXLabel = Instance.new("TextLabel", MenuFrame)
PredXLabel.Size = UDim2.new(0, 250, 0, 50)
PredXLabel.Position = UDim2.new(0.5, -125, 0, 60)
PredXLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
PredXLabel.Text = "Prediction X"
PredXLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text
local PredXLabelCorner = Instance.new("UICorner", PredXLabel)
PredXLabelCorner.CornerRadius = UDim.new(0, 15)

-- Prediction X box
local PredXBox = Instance.new("TextBox", MenuFrame)
PredXBox.Size = UDim2.new(0, 250, 0, 100)
PredXBox.Position = UDim2.new(0.5, -125, 0, 110)
PredXBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark grey
PredXBox.Text = tostring(Aimbot['Prediction'].X)
PredXBox.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text
PredXBox.BorderSizePixel = 2
PredXBox.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Red outline
local PredXBoxCorner = Instance.new("UICorner", PredXBox)
PredXBoxCorner.CornerRadius = UDim.new(0, 15)
PredXBox.FocusLost:Connect(function()
    Aimbot['Prediction'].X = tonumber(PredXBox.Text) or Aimbot['Prediction'].X
end)

-- Prediction Y label
local PredYLabel = Instance.new("TextLabel", MenuFrame)
PredYLabel.Size = UDim2.new(0, 250, 0, 50)
PredYLabel.Position = UDim2.new(0.5, -125, 0, 220) -- Below Prediction X box
PredYLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
PredYLabel.Text = "Prediction Y"
PredYLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text
local PredYLabelCorner = Instance.new("UICorner", PredYLabel)
PredYLabelCorner.CornerRadius = UDim.new(0, 15)

-- Prediction Y box
local PredYBox = Instance.new("TextBox", MenuFrame)
PredYBox.Size = UDim2.new(0, 250, 0, 100)
PredYBox.Position = UDim2.new(0.5, -125, 0, 270) -- Below Prediction Y label
PredYBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark grey
PredYBox.Text = tostring(Aimbot['Prediction'].Y)
PredYBox.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text
PredYBox.BorderSizePixel = 2
PredYBox.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Red outline
local PredYBoxCorner = Instance.new("UICorner", PredYBox)
PredYBoxCorner.CornerRadius = UDim.new(0, 15)
PredYBox.FocusLost:Connect(function()
    Aimbot['Prediction'].Y = tonumber(PredYBox.Text) or Aimbot['Prediction'].Y
end)

-- Keybind label
local KeybindLabel = Instance.new("TextLabel", MenuFrame)
KeybindLabel.Size = UDim2.new(0, 250, 0, 30)
KeybindLabel.Position = UDim2.new(0.5, -125, 0, 390) -- Below Prediction Y box
KeybindLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
KeybindLabel.Text = "Keybind"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text
local KeybindLabelCorner = Instance.new("UICorner", KeybindLabel)
KeybindLabelCorner.CornerRadius = UDim.new(0, 15)

-- Keybind box
local KeybindBox = Instance.new("TextBox", MenuFrame)
KeybindBox.Size = UDim2.new(0, 250, 0, 50)
KeybindBox.Position = UDim2.new(0.5, -125, 0, 430) -- Below Keybind label
KeybindBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark grey
KeybindBox.Text = Aimbot.Keybind
KeybindBox.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text
KeybindBox.BorderSizePixel = 2
KeybindBox.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Red outline
local KeybindBoxCorner = Instance.new("UICorner", KeybindBox)
KeybindBoxCorner.CornerRadius = UDim.new(0, 15)
KeybindBox.FocusLost:Connect(function()
    Aimbot.Keybind = KeybindBox.Text:upper() -- Convert to uppercase
end)

-- Make GUI draggable
local dragging
local dragInput
local dragStart
local startPos

MenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MenuFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MenuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MenuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle GUI visibility
local function toggleGUI()
    ScreenGui.Enabled = not ScreenGui.Enabled
end

-- Bind toggle to Right Control key
UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleGUI()
    end
end)

local GetClosestPlayer = function() -- Optimized GetClosestPlayer
    local ClosestDistance, ClosestPlayer = 100000, nil
    for _, Player : Player in pairs(Players:GetPlayers()) do
        if Player.Name ~= LocalPlayer.Name and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') then
            local Root, Visible = Camera:WorldToScreenPoint(Player.Character.HumanoidRootPart.Position)
            if not Visible then
                continue
            end
            Root = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Root.X, Root.Y)).Magnitude
            if Root < ClosestDistance then
                ClosestPlayer = Player
                ClosestDistance = Root
            end
        end
    end
    return ClosestPlayer
end

Mouse.KeyDown:Connect(function(key) -- Get closest player (toggle)
    if key == Aimbot.Keybind:lower() then
        Player = not Player and GetClosestPlayer() or nil
    end
end)

RunService.RenderStepped:Connect(function()
    if not Player then
        return
    end
    if not Aimbot.Status then
        return
    end
    local Hitpart = Player.Character:FindFirstChild(Aimbot.Hitpart)
    if not Hitpart then
        return
    end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position + Hitpart.Velocity * Vector3.new(Aimbot.Prediction.X, Aimbot.Prediction.Y, Aimbot.Prediction.X))
end)
