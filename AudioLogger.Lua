local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AudioLogger"
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.6, 0)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Black background
frame.BorderSizePixel = 0
frame.Parent = gui

-- Add UI Corners to frame for rounded edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.05, 0) -- Rounded corners
uiCorner.Parent = frame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Audio Logger"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BorderSizePixel = 0
titleLabel.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.BackgroundTransparency = 1 -- Make background transparent
closeButton.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text color
closeButton.BorderSizePixel = 0
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy() -- Close the AudioLogger GUI
end)

-- Add UI Corners to close button
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.5, 0)
closeCorner.Parent = closeButton

-- ScrollFrame to list audio items
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 0.9, 0)
scrollFrame.Position = UDim2.new(0, 0, 0.1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 10, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scrollFrame.BorderSizePixel = 0
scrollFrame.Parent = frame

-- Add UI Corners to the scroll frame
local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0.05, 0)
scrollCorner.Parent = scrollFrame

-- List layout for items
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 5)

-- Function to log and display audio
local function logAudio(sound)
    local soundButton = Instance.new("TextButton")
    soundButton.Text = sound.Name .. " (ID: " .. sound.SoundId .. ")"
    soundButton.Font = Enum.Font.Gotham
    soundButton.TextSize = 18
    soundButton.Size = UDim2.new(1, 0, 0, 40)
    soundButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    soundButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    soundButton.BorderSizePixel = 0
    soundButton.Parent = scrollFrame

    -- Add rounded corners to the button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.05, 0)
    buttonCorner.Parent = soundButton

    -- Add a click function to play the sound
    soundButton.MouseButton1Click:Connect(function()
        sound:Play()
        print("Playing: " .. sound.Name)
    end)
end

-- Function to search the entire game for audio
local function findAllAudio(parent)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("Sound") then
            logAudio(child)
        end
        -- Recursively check the child objects
        findAllAudio(child)
    end
end

-- Loading screen with spinning dots animation
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
loadingFrame.Parent = gui

local loadingLabel = Instance.new("TextLabel")
loadingLabel.Text = "Loading Audio Logger"
loadingLabel.Size = UDim2.new(1, 0, 0.1, 0)
loadingLabel.Position = UDim2.new(0, 0, 0.45, 0)
loadingLabel.TextScaled = true
loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingLabel.BackgroundTransparency = 1
loadingLabel.Font = Enum.Font.GothamBold
loadingLabel.Parent = loadingFrame

local dotsLabel = Instance.new("TextLabel")
dotsLabel.Text = ""
dotsLabel.Size = UDim2.new(1, 0, 0.1, 0)
dotsLabel.Position = UDim2.new(0, 0, 0.55, 0)
dotsLabel.TextScaled = true
dotsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dotsLabel.BackgroundTransparency = 1
dotsLabel.Font = Enum.Font.Gotham
dotsLabel.Parent = loadingFrame

local tipLabel = Instance.new("TextLabel")
tipLabel.Text = "Tips : Credits to @TheeOfficialProplay For Creating this AudioLogger"
tipLabel.Size = UDim2.new(1, 0, 0.1, 0)
tipLabel.Position = UDim2.new(0, 0, 0.65, 0)
tipLabel.TextScaled = false -- Disable TextScaled for specific sizing
tipLabel.TextSize = 36 -- Adjusted size to be 35% smaller than 18
tipLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tipLabel.BackgroundTransparency = 1
tipLabel.Font = Enum.Font.Gotham
tipLabel.Parent = loadingFrame

-- Function to animate dots
local function animateDots()
    while true do
        for i = 1, 3 do
            dotsLabel.Text = string.rep(".", i)
            wait(0.5)
        end
    end
end

-- Start spinning dots animation in a separate thread
coroutine.wrap(animateDots)()

-- Start searching from the workspace and SoundService after a delay
wait(10) -- Set loading time to 10 seconds
loadingFrame:Destroy() -- Remove loading screen after loading

findAllAudio(workspace)
findAllAudio(game:GetService("SoundService"))

-- Make the GUI draggable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Audio logging completed.")
