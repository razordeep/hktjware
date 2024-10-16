getgenv().AimAssist = { 
    Status = false, 
    Keybind = 'C', 
    Hitpart = 'HumanoidRootPart', 
    ['Prediction'] = { X = 0.1, Y = 0.1 },
    Smoothness = 0.06
}

if getgenv().AimAssistRan then return else getgenv().AimAssistRan = true end

local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local TargetPlayer = nil

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Enabled = true
local MenuFrame = Instance.new("Frame", ScreenGui)
MenuFrame.Size = UDim2.new(0, 300, 0, 500)
MenuFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MenuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Changed to black
MenuFrame.BorderSizePixel = 2
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local MenuCorner = Instance.new("UICorner", MenuFrame)
MenuCorner.CornerRadius = UDim.new(0, 15)

-- Header
local Header = Instance.new("TextLabel", MenuFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Background color black
Header.Text = "hktjware"
Header.TextColor3 = Color3.fromRGB(255, 0, 0) -- Header text color red
Header.TextScaled = true
Header.BorderSizePixel = 0 -- Removed the border
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 15)

-- Create UI elements function
local function createUIElement(elementType, parent, size, position, text)
    local element = Instance.new(elementType, parent)
    element.Size = size
    element.Position = position
    element.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Background color black
    element.Text = text
    element.TextColor3 = Color3.fromRGB(255, 0, 0)
    local corner = Instance.new("UICorner", element)
    corner.CornerRadius = UDim.new(0, 15)
    return element
end

local function createTextBox(parent, position, defaultText, callback)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0, 250, 0, 30)
    box.Position = position
    box.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Background color black
    box.Text = defaultText
    box.TextColor3 = Color3.fromRGB(255, 0, 0)
    box.BorderSizePixel = 0 -- Removed the border
    box.ClearTextOnFocus = false -- Prevent text clearing on focus

    local corner = Instance.new("UICorner", box) -- Rounded edges
    corner.CornerRadius = UDim.new(0, 15)

    box.FocusLost:Connect(function()
        callback(tonumber(box.Text) or box.Text)
    end)
    return box
end

-- UI Elements
local PredXLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 60), "Prediction X")
local PredXBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 90), tostring(AimAssist['Prediction'].X), function(value) AimAssist['Prediction'].X = value end)

local PredYLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 130), "Prediction Y")
local PredYBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 170), tostring(AimAssist['Prediction'].Y), function(value) AimAssist['Prediction'].Y = value end)

local SmoothnessLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 210), "Smoothness")
local SmoothnessBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 250), tostring(AimAssist.Smoothness), function(value) AimAssist.Smoothness = value end)

local KeybindLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 290), "Keybind")
local KeybindBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 330), AimAssist.Keybind, function(value) AimAssist.Keybind = value:upper() end)

-- Credits Labels with space
local CreditsLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 370), "Credits")
local HKTJLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 410), "@hktj")

-- Make GUI draggable
local dragging = false
local dragStart = Vector2.new(0, 0)
local startPos = Vector2.new(0, 0)

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
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleGUI()
    end
end)

local GetClosestPlayer = function()
    local ClosestDistance, ClosestPlayer = math.huge, nil
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') then
            local Root, Visible = Camera:WorldToScreenPoint(Player.Character.HumanoidRootPart.Position)
            if not Visible then continue end
            local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Root.X, Root.Y)).Magnitude
            if distance < ClosestDistance then
                ClosestPlayer = Player 
                ClosestDistance = distance
            end
        end
    end
    return ClosestPlayer
end

Mouse.KeyDown:Connect(function(key)
    if key == AimAssist.Keybind:lower() then
        AimAssist.Status = not AimAssist.Status
        TargetPlayer = AimAssist.Status and GetClosestPlayer() or nil
    end
end)

RunService.RenderStepped:Connect(function()
    if not AimAssist.Status or not TargetPlayer then return end

    local humanoid = TargetPlayer.Character:FindFirstChildOfClass('Humanoid')
    if humanoid and humanoid.Health <= 0 then 
        TargetPlayer = nil -- Stop aiming if the target is dead
        return 
    end

    local Hitpart = TargetPlayer.Character:FindFirstChild(AimAssist.Hitpart)
    if not Hitpart then return end

    local aimPosition = Hitpart.Position + Hitpart.Velocity * Vector3.new(AimAssist.Prediction.X, AimAssist.Prediction.Y, AimAssist.Prediction.X)

    -- Smoothly adjust the camera CFrame
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, aimPosition)
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, AimAssist.Smoothness)
end)
