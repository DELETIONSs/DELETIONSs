local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

-- DELETIONLIBRARY: A Simple GUI Library for Roblox
-- This script provides functions to create windows, tabs, buttons, and more.

local DELETIONLIBRARY = {}

-- GUI framework (Example)
local function CreateGuiElement(elementType, properties)
    -- This is a placeholder for the actual Roblox GUI creation functions.
    -- You would use Roblox's GUI services such as ScreenGui, Frame, TextButton, etc.
    local element = Instance.new(elementType)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

-- MakeWindow: Creates a new window
function DELETIONLIBRARY:MakeWindow(properties)
    local window = Instance.new("ScreenGui")
    window.Name = properties.Name or "DELETION Window"
    window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Configuring window settings (e.g., saving configuration)
    if properties.SaveConfig then
        -- Here you'd add code to save and load the window configuration
    end
    
    -- Window background (for visualization purposes)
    local background = CreateGuiElement("Frame", {
        Size = UDim2.new(0.5, 0, 0.5, 0),
        Position = UDim2.new(0.25, 0, 0.25, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Parent = window
    })
    
    -- Title label
    local titleLabel = CreateGuiElement("TextLabel", {
        Size = UDim2.new(1, 0, 0.1, 0),
        Text = properties.Name or "Untitled Window",
        TextSize = 24,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = background
    })

    return {
        Name = properties.Name,
        window = window,
        background = background,
        AddTab = function(self, tabProperties)
            return self:MakeTab(tabProperties)
        end
    }
end

-- MakeTab: Creates a new tab inside the window
function DELETIONLIBRARY:MakeTab(properties)
    local tabFrame = CreateGuiElement("Frame", {
        Size = UDim2.new(1, 0, 0.9, 0),
        Position = UDim2.new(0, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Parent = self.window
    })
    
    -- Tab label (Icon + Name)
    local tabLabel = CreateGuiElement("TextLabel", {
        Size = UDim2.new(0.2, 0, 0.1, 0),
        Text = properties.Name or "Unnamed Tab",
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = tabFrame
    })

    -- Tab Icon
    if properties.Icon then
        local icon = CreateGuiElement("ImageLabel", {
            Size = UDim2.new(0.05, 0, 0.05, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Image = properties.Icon,
            Parent = tabLabel
        })
    end

    return {
        Name = properties.Name,
        tabFrame = tabFrame,
        AddButton = function(self, buttonProperties)
            return self:AddButton(buttonProperties)
        end,
        AddToggle = function(self, toggleProperties)
            return self:AddToggle(toggleProperties)
        end
    }
end

-- AddButton: Adds a button to the tab
function DELETIONLIBRARY:MakeButton(properties)
    local button = CreateGuiElement("TextButton", {
        Size = UDim2.new(0.5, 0, 0.1, 0),
        Text = properties.Name or "Button",
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(0, 120, 255),
        Parent = properties.Parent
    })
    button.MouseButton1Click:Connect(properties.Callback)

    return button
end

-- AddToggle: Adds a checkbox toggle to the tab
function DELETIONLIBRARY:AddToggle(properties)
    local toggle = CreateGuiElement("TextButton", {
        Size = UDim2.new(0.5, 0, 0.1, 0),
        Text = properties.Name or "Toggle",
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        Parent = properties.Parent
    })

    local state = properties.Default or false

    toggle.MouseButton1Click:Connect(function()
        state = not state
        properties.Callback(state)  -- Run the callback with the updated state
    end)

    return {
        Set = function(self, value)
            state = value
            properties.Callback(state)
        end
    }
end

-- AddColorpicker: Adds a color picker to the tab
function DELETIONLIBRARY:AddColorpicker(properties)
    -- For simplicity, we'll create a color box that changes color when clicked
    local colorPicker = CreateGuiElement("TextButton", {
        Size = UDim2.new(0.3, 0, 0.1, 0),
        Text = properties.Name or "Color Picker",
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = properties.Default or Color3.fromRGB(255, 0, 0),
        Parent = properties.Parent
    })

    colorPicker.MouseButton1Click:Connect(function()
        local newColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        colorPicker.BackgroundColor3 = newColor
        properties.Callback(newColor)
    end)

    return colorPicker
end

-- MakeNotification: Creates a notification popup
function DELETIONLIBRARY:MakeNotification(properties)
    local notification = Instance.new("ScreenGui")
    notification.Name = "Notification"
    notification.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = CreateGuiElement("Frame", {
        Size = UDim2.new(0.3, 0, 0.1, 0),
        Position = UDim2.new(0.35, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Parent = notification
    })

    local label = CreateGuiElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Text = properties.Name or "Notification",
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = frame
    })

    -- Notification image (optional)
    if properties.Image then
        local imageLabel = CreateGuiElement("ImageLabel", {
            Size = UDim2.new(0.1, 0, 0.1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Image = properties.Image,
            Parent = frame
        })
    end

    -- Close after the specified time
    wait(properties.Time or 5)
    notification:Destroy()
end

-- Return the DELETIONLIBRARY object
return DELETIONLIBRARY
