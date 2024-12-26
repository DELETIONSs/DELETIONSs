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

    -- Draggable functionality for the window
    local dragging = false
    local dragInput, dragStart, startPos
    background.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = background.Position
            input.Changed:Connect(function()
                if dragging == false then return end
                local delta = input.Position - dragStart
                background.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end)
        end
    end)

    background.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

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
            -- Correct reference to add button to the current tab's frame
            return self:AddButton(buttonProperties)
        end,
        AddSlider = function(self, sliderProperties)
            return self:AddSlider(sliderProperties)
        end,
        AddLabel = function(self, labelText)
            return self:AddLabel(labelText)
        end
    }
end

-- AddButton: Adds a button to the tab
function DELETIONLIBRARY:AddButton(properties)
    local button = CreateGuiElement("TextButton", {
        Size = UDim2.new(0.5, 0, 0.1, 0),
        Text = properties.Name or "Button",
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(0, 120, 255),
        Parent = properties.Parent
    })
    -- Connect button callback
    button.MouseButton1Click:Connect(properties.Callback)

    return button
end

-- AddSlider: Adds a slider to the tab
function DELETIONLIBRARY:AddSlider(properties)
    local sliderFrame = CreateGuiElement("Frame", {
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Parent = properties.Parent
    })

    local sliderBar = CreateGuiElement("Frame", {
        Size = UDim2.new(1, -20, 0, 5),
        Position = UDim2.new(0, 10, 0.5, -2),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = sliderFrame
    })

    local sliderButton = CreateGuiElement("Frame", {
        Size = UDim2.new(0, 10, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 120, 255),
        Parent = sliderBar
    })

    local valueLabel = CreateGuiElement("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, 10, 0.5, -10),
        Text = properties.Default .. " " .. properties.ValueName,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = sliderFrame
    })

    local dragging = false
    local min = properties.Min
    local max = properties.Max
    local increment = properties.Increment
    local default = properties.Default

    sliderButton.Position = UDim2.new((default - min) / (max - min), 0, 0, 0)

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            while dragging do
                local position = input.Position.X
                local newPosition = math.clamp(position - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                sliderButton.Position = UDim2.new(newPosition / sliderBar.AbsoluteSize.X, 0, 0, 0)

                local value = math.floor(min + (newPosition / sliderBar.AbsoluteSize.X) * (max - min) / increment) * increment
                valueLabel.Text = value .. " " .. properties.ValueName
                properties.Callback(value)
                wait(0.01)
            end
        end
    end)

    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return sliderFrame
end

-- AddLabel: Adds a simple label to the tab
function DELETIONLIBRARY:AddLabel(labelText)
    local label = CreateGuiElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Text = labelText,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Parent = self.tabFrame
    })

    return label
end

-- Return the DELETIONLIBRARY object
return DELETIONLIBRARY
