getgenv().Aimbot = { 
    Status = false, 
    Keybind = 'C', 
    Hitpart = 'HumanoidRootPart', 
    ['Prediction'] = { X = 0.1, Y = 0.1 },
    Smoothness = 0.2, 
    Fov = 100 
}

if getgenv().AimbotRan then return else getgenv().AimbotRan = true end

local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local TargetPlayer = nil

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Enabled = true
local MenuFrame = Instance.new("Frame", ScreenGui)
MenuFrame.Size = UDim2.new(0, 300, 0, 500)
MenuFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MenuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MenuFrame.BorderSizePixel = 0
MenuFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local MenuCorner = Instance.new("UICorner", MenuFrame)
MenuCorner.CornerRadius = UDim.new(0, 15)

-- Header
local Header = Instance.new("TextLabel", MenuFrame)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Header.Text = "hktjware" -- Changed header text
Header.TextColor3 = Color3.fromRGB(255, 0, 0)
Header.TextScaled = true
Header.BorderSizePixel = 0
local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 15)

-- Function to create UI elements
local function createUIElement(elementType, parent, size, position, text)
    local element = Instance.new(elementType, parent)
    element.Size = size
    element.Position = position
    element.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    element.Text = text
    element.TextColor3 = Color3.fromRGB(255, 0, 0)
    element.BorderSizePixel = 0
    local corner = Instance.new("UICorner", element)
    corner.CornerRadius = UDim.new(0, 15)
    return element
end

local function createTextBox(parent, position, defaultText, callback)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0, 250, 0, 30)
    box.Position = position
    box.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    box.Text = defaultText
    box.TextColor3 = Color3.fromRGB(255, 0, 0)
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false

    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 15)

    box.FocusLost:Connect(function()
        callback(tonumber(box.Text) or box.Text)
    end)
    return box
end

-- Create UI Elements
local PredXLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 60), "Prediction X")
local PredXBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 90), tostring(Aimbot['Prediction'].X), function(value) Aimbot['Prediction'].X = value end)

local PredYLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 130), "Prediction Y")
local PredYBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 170), tostring(Aimbot['Prediction'].Y), function(value) Aimbot['Prediction'].Y = value end)

local SmoothnessLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 210), "Smoothness")
local SmoothnessBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 250), tostring(Aimbot.Smoothness), function(value) Aimbot.Smoothness = value end)

-- New FOV Elements
local FovLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 290), "FOV")
local FovBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 330), tostring(Aimbot.Fov), function(value) Aimbot.Fov = value end)

-- Keybind Elements moved below FOV
local KeybindLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 0, 370), "Keybind")
local KeybindBox = createTextBox(MenuFrame, UDim2.new(0.5, -125, 0, 410), Aimbot.Keybind, function(value) Aimbot.Keybind = value:upper() end)

-- Credits Labels moved to the bottom
local CreditsLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 1, -60), "Credits")
local HKTJLabel = createUIElement("TextLabel", MenuFrame, UDim2.new(0, 250, 0, 30), UDim2.new(0.5, -125, 1, -30), "@hktj")

-- Function to check if target is visible and within FOV
local function isVisible(target)
    local character = target.Character
    local rootPart = character and character:FindFirstChild('HumanoidRootPart')
    if not rootPart then return false end

    local ray = Ray.new(Camera.CFrame.Position, (rootPart.Position - Camera.CFrame.Position).unit * (Camera.CFrame.Position - rootPart.Position).magnitude)
    local hitPart = Workspace:FindPartOnRay(ray, LocalPlayer.Character)

    return not hitPart or hitPart:IsDescendantOf(character)
end

local function isInFOV(target)
    local targetPosition = target.Character.HumanoidRootPart.Position
    local direction = (targetPosition - Camera.CFrame.Position).unit
    local dotProduct = direction:Dot(Camera.CFrame.LookVector)

    return dotProduct > math.cos(math.rad(Aimbot.Fov / 2))
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode[Aimbot.Keybind] and not gameProcessedEvent then
        Aimbot.Status = not Aimbot.Status
        TargetPlayer = Aimbot.Status and nil
    end
end)

RunService.RenderStepped:Connect(function()
    if Aimbot.Status then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') then
                if isVisible(Player) and isInFOV(Player) then
                    TargetPlayer = Player
                    break
                end
            end
        end
    end

    if not Aimbot.Status or not TargetPlayer or not isVisible(TargetPlayer) then return end

    local aimPosition = TargetPlayer.Character[Aimbot.Hitpart].Position + TargetPlayer.Character[Aimbot.Hitpart].Velocity * Vector3.new(Aimbot.Prediction.X, Aimbot.Prediction.Y, Aimbot.Prediction.X)

    local randomOffset = Vector3.new(math.random(-1, 1) * 0.05, math.random(-1, 1) * 0.05, 0)
    aimPosition = aimPosition + randomOffset

    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, aimPosition)
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, Aimbot.Smoothness)
end)

-- Make GUI draggable
local dragging, dragInput, dragStart, startPos
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
