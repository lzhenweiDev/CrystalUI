-- CrystalUI - Eine moderne UI-Bibliothek für Lua
-- Inspiriert von Rayfield UI

local CrystalUI = {}
CrystalUI.__index = CrystalUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Globale Referenzen
local ProtectGui = nil

-- Erstelle ProtectGui falls nicht vorhanden
if syn and syn.protect_gui then
    ProtectGui = function(obj)
        obj.Parent = syn.protect_gui()
    end
elseif gethui then
    ProtectGui = function(obj)
        obj.Parent = gethui()
    end
else
    ProtectGui = function(obj)
        obj.Parent = CoreGui
    end
end

-- Theme und Styles
CrystalUI.Themes = {
    Default = {
        Main = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(35, 35, 45),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 180),
        Background = Color3.fromRGB(30, 30, 40),
        Border = Color3.fromRGB(60, 60, 80),
        Button = Color3.fromRGB(45, 45, 55),
        ButtonHover = Color3.fromRGB(55, 55, 65),
        Toggle = Color3.fromRGB(100, 100, 255),
        Slider = Color3.fromRGB(100, 100, 255),
        Dropdown = Color3.fromRGB(45, 45, 55),
        Input = Color3.fromRGB(35, 35, 45),
        TabText = Color3.fromRGB(200, 200, 200),
        SelectedTab = Color3.fromRGB(255, 255, 255)
    },
    
    Midnight = {
        Main = Color3.fromRGB(20, 20, 30),
        Secondary = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(80, 80, 200),
        Text = Color3.fromRGB(230, 230, 230),
        SubText = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(25, 25, 35),
        Border = Color3.fromRGB(50, 50, 60),
        Button = Color3.fromRGB(40, 40, 50),
        ButtonHover = Color3.fromRGB(50, 50, 60),
        Toggle = Color3.fromRGB(80, 80, 200),
        Slider = Color3.fromRGB(80, 80, 200),
        Dropdown = Color3.fromRGB(40, 40, 50),
        Input = Color3.fromRGB(30, 30, 40),
        TabText = Color3.fromRGB(180, 180, 180),
        SelectedTab = Color3.fromRGB(230, 230, 230)
    }
}

-- Utility Funktionen
local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    duration = duration or 0.3
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    return tween
end

local function CreateInstance(class, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    return instance
end

-- Hauptfenster erstellen
function CrystalUI:CreateWindow(config)
    config = config or {}
    local theme = self.Themes[config.Theme or "Default"] or self.Themes.Default
    
    local window = {}
    window.ScreenGui = nil
    
    -- Main GUI
    window.ScreenGui = CreateInstance("ScreenGui", {
        Name = config.Name or "CrystalUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    ProtectGui(window.ScreenGui)
    
    -- Hauptcontainer
    local MainFrame = CreateInstance("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Parent = window.ScreenGui
    })
    
    -- Ecken abrunden
    local Corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    -- Title Bar
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TitleCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TitleBar
    })
    
    -- Untere Ecken abdecken
    local TitleBottom = CreateInstance("Frame", {
        Name = "Bottom",
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 1, -5),
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    local TitleText = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Crystal UI",
        TextColor3 = theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        Parent = TitleBar
    })
    
    -- Minimieren Button
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = theme.Button,
        Text = "—",
        TextColor3 = theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    local MinimizeCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MinimizeButton
    })
    
    -- Schließen Button
    local CloseButton = CreateInstance("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    local CloseCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CloseButton
    })
    
    -- Tab Navigation
    local TabBar = CreateInstance("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, 160, 1, -50),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local TabList = CreateInstance("UIListLayout", {
        Name = "TabList",
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabBar
    })
    
    local TabPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = TabBar
    })
    
    -- Content Bereich
    local ContentFrame = CreateInstance("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -170, 1, -60),
        Position = UDim2.new(0, 165, 0, 50),
        BackgroundColor3 = theme.Secondary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local ContentCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = ContentFrame
    })
    
    -- Scrollbarer Content
    local ScrollingFrame = CreateInstance("ScrollingFrame", {
        Name = "ScrollingFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarImageTransparency = 0.5,
        Parent = ContentFrame
    })
    
    local ScrollingList = CreateInstance("UIListLayout", {
        Name = "List",
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ScrollingFrame
    })
    
    local ScrollingPadding = CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = ScrollingFrame
    })
    
    -- Fenster verschiebbar machen
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Tabs
    local tabs = {}
    local currentTab = nil
    
    -- Content Frame für den gesamten Content
    local allContent = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = ScrollingFrame
    })
    
    local allContentList = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = allContent
    })
    
    -- Tab erstellen
    function window:CreateTab(name, icon)
        local tabButton = CreateInstance("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = theme.Button,
            Text = (icon or "") .. "  " .. name,
            TextColor3 = theme.TabText,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Parent = TabBar
        })
        
        local tabCorner = CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = tabButton
        })
        
        local tabContent = CreateInstance("Frame", {
            Name = name .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            BackgroundTransparency = 1,
            Parent = allContent
        })
        
        local tabList = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        
        local tabPadding = CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Parent = tabContent
        })
        
        -- Button Events
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabButton then
                CreateTween(tabButton, {BackgroundColor3 = theme.ButtonHover}, 0.2):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabButton then
                CreateTween(tabButton, {BackgroundColor3 = theme.Button}, 0.2):Play()
            end
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.TextColor3 = theme.TabText
                CreateTween(currentTab, {BackgroundColor3 = theme.Button}, 0.2):Play()
                tabs[currentTab].Content.Visible = false
            end
            
            currentTab = tabButton
            tabButton.TextColor3 = theme.Text
            CreateTween(tabButton, {BackgroundColor3 = theme.Accent}, 0.2):Play()
            tabContent.Visible = true
            
            wait(0.1)
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, allContentList.AbsoluteContentSize.Y + 20)
        end)
        
        tabs[tabButton] = {Content = tabContent, List = tabList}
        
        if not currentTab then
            -- Warte einen Frame bevor wir den ersten Tab aktivieren
            spawn(function()
                wait(0.1)
                tabButton.MouseButton1Click:Fire()
            end)
        end
        
        -- Section erstellen
        local sections = {}
        
        function window:CreateSection(name)
            local section = {}
            
            local sectionFrame = CreateInstance("Frame", {
                Name = name,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = tabContent
            })
            
            local sectionText = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = theme.SubText,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold,
                Parent = sectionFrame
            })
            
            local line = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = theme.Border,
                BorderSizePixel = 0,
                BackgroundTransparency = 0.5,
                Parent = sectionFrame
            })
            
            -- Button erstellen
            function section:CreateButton(name, callback)
                local buttonFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = theme.Button,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Parent = tabContent
                })
                
                local buttonCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = buttonFrame
                })
                
                local button = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    Parent = buttonFrame
                })
                
                local buttonPadding = CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    Parent = button
                })
                
                button.MouseEnter:Connect(function()
                    CreateTween(buttonFrame, {BackgroundColor3 = theme.ButtonHover}, 0.2):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    CreateTween(buttonFrame, {BackgroundColor3 = theme.Button}, 0.2):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, allContentList.AbsoluteContentSize.Y + 40)
                
                return button
            end
            
            -- Toggle erstellen
            function section:CreateToggle(name, default, callback)
                local toggleFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = theme.Button,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Parent = tabContent
                })
                
                local toggleCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = toggleFrame
                })
                
                local toggleText = CreateInstance("TextLabel", {
                    Size = UDim2.new(0, 200, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    Parent = toggleFrame
                })
                
                local toggle = CreateInstance("Frame", {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -50, 0.5, -10),
                    BackgroundColor3 = default and theme.Toggle or Color3.fromRGB(60, 60, 70),
                    BorderSizePixel = 0,
                    Parent = toggleFrame
                })
                
                local toggleCorner2 = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = toggle
                })
                
                local toggleDot = CreateInstance("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Parent = toggle
                })
                
                local dotCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleDot
                })
                
                local toggled = default or false
                
                local toggleButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = toggleFrame
                })
                
                local function updateToggle()
                    if toggled then
                        CreateTween(toggle, {BackgroundColor3 = theme.Toggle}, 0.2):Play()
                        CreateTween(toggleDot, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2):Play()
                    else
                        CreateTween(toggle, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}, 0.2):Play()
                        CreateTween(toggleDot, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2):Play()
                    end
                end
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                    if callback then
                        callback(toggled)
                    end
                end)
                
                ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, allContentList.AbsoluteContentSize.Y + 40)
                
                return {
                    SetState = function(self, state)
                        toggled = state
                        updateToggle()
                    end,
                    GetState = function()
                        return toggled
                    end
                }
            end
            
            -- Slider erstellen
            function section:CreateSlider(name, min, max, default, callback)
                local sliderFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundColor3 = theme.Button,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Parent = tabContent
                })
                
                local sliderCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = sliderFrame
                })
                
                local sliderText = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    Text = name .. " - " .. default,
                    TextColor3 = theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    Parent = sliderFrame
                })
                
                local sliderBg = CreateInstance("Frame", {
                    Size = UDim2.new(1, -20, 0, 4),
                    Position = UDim2.new(0, 10, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                    BorderSizePixel = 0,
                    Parent = sliderFrame
                })
                
                local sliderBgCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 2),
                    Parent = sliderBg
                })
                
                local sliderFill = CreateInstance("Frame", {
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = theme.Slider,
                    BorderSizePixel = 0,
                    Parent = sliderBg
                })
                
                local sliderFillCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 2),
                    Parent = sliderFill
                })
                
                local sliderDot = CreateInstance("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
                    BackgroundColor3 = theme.Text,
                    BorderSizePixel = 0,
                    Parent = sliderBg
                })
                
                local dotCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderDot
                })
                
                local sliderDragging = false
                
                local function updateSlider(input)
                    local sizeX = sliderBg.AbsoluteSize.X
                    local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sizeX, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderDot.Position = UDim2.new(pos, -6, 0.5, -6)
                    sliderText.Text = name .. " - " .. value
                    
                    if callback then
                        callback(value)
                    end
                    
                    return value
                end
                
                local sliderInputBegan
                sliderInputBegan = sliderDot.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = true
                    end
                end)
                
                local sliderInputEnded
                sliderInputEnded = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = false
                    end
                end)
                
                local sliderInputChanged
                sliderInputChanged = UserInputService.InputChanged:Connect(function(input)
                    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = true
                        updateSlider(input)
                    end
                end)
                
                ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, allContentList.AbsoluteContentSize.Y + 60)
                
                return {
                    SetValue = function(self, value)
                        local pos = (value - min) / (max - min)
                        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                        sliderDot.Position = UDim2.new(pos, -6, 0.5, -6)
                        sliderText.Text = name .. " - " .. value
                    end
                }
            end
            
            -- Dropdown erstellen
            function section:CreateDropdown(name, options, callback)
                local dropdownFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = theme.Button,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Parent = tabContent
                })
                
                local dropdownCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropdownFrame
                })
                
                local dropdownButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name .. "  ▼",
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    Parent = dropdownFrame
                })
                
                local dropdownPadding = CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    Parent = dropdownButton
                })
                
                local optionsList = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, #options * 30 + 10),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = theme.Dropdown,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 10,
                    Parent = dropdownFrame
                })
                
                local optionsCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = optionsList
                })
                
                local optionsLayout = CreateInstance("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = optionsList
                })
                
                local optionsPadding = CreateInstance("UIPadding", {
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5),
                    Parent = optionsList
                })
                
                local expanded = false
                
                local function createOptions()
                    -- Clear existing
                    for _, child in pairs(optionsList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for i, option in ipairs(options) do
                        local optionButton = CreateInstance("TextButton", {
                            Name = option,
                            Size = UDim2.new(1, 0, 0, 30),
                            BackgroundTransparency = 1,
                            Text = option,
                            TextColor3 = theme.Text,
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Font = Enum.Font.Gotham,
                            ZIndex = 11,
                            Parent = optionsList
                        })
                        
                        local optionPadding = CreateInstance("UIPadding", {
                            PaddingLeft = UDim.new(0, 10),
                            Parent = optionButton
                        })
                        
                        optionButton.MouseEnter:Connect(function()
                            optionButton.BackgroundColor3 = theme.ButtonHover
                            optionButton.BackgroundTransparency = 0
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            optionButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            optionButton.BackgroundTransparency = 1
                        end)
                        
                        optionButton.MouseButton1Click:Connect(function()
                            dropdownButton.Text = name .. "  " .. option .. "  ▼"
                            expanded = false
                            optionsList.Visible = false
                            if callback then
                                callback(option)
                            end
                        end)
                    end
                end
                
                createOptions()
                
                dropdownButton.MouseButton1Click:Connect(function()
                    expanded = not expanded
                    optionsList.Visible = expanded
                    if expanded then
                        optionsList.Size = UDim2.new(1, 0, 0, #options * 30 + 10)
                    end
                end)
                
                ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, allContentList.AbsoluteContentSize.Y + 40)
                
                return {
                    Refresh = function(self, newOptions)
                        options = newOptions
                        createOptions()
                    end,
                    SetText = function(self, text)
                        dropdownButton.Text = text
                    end
                }
            end
            
            -- Textbox erstellen
            function section:CreateTextbox(name, placeholder, callback)
                local textboxFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = theme.Button,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Parent = tabContent
                })
                
                local textboxCorner = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = textboxFrame
                })
                
                local textboxTitle = CreateInstance("TextLabel", {
                    Size = UDim2.new(0, 100, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    Parent = textboxFrame
                })
                
                local textbox = CreateInstance("TextBox", {
                    Size = UDim2.new(1, -120, 0, 30),
                    Position = UDim2.new(0, 110, 0.5, -15),
                    BackgroundColor3 = theme.Input,
                    Text = "",
                    PlaceholderText = placeholder or "",
                    PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    Parent = textboxFrame
                })
                
                local textboxCorner2 = CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = textbox
                })
                
                local textboxPadding = CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = textbox
                })
                
                textbox.FocusLost:Connect(function()
                    if callback then
                        callback(textbox.Text)
                    end
                end)
                
                ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, allContentList.AbsoluteContentSize.Y + 40)
                
                return {
                    SetText = function(self, text)
                        textbox.Text = text
                    end,
                    GetText = function()
                        return textbox.Text
                    end
                }
            end
            
            -- Label erstellen
            function section:CreateLabel(text)
                local label = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.SubText,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    Parent = tabContent
                })
                
                local labelPadding = CreateInstance("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                    Parent = label
                })
                
                ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, allContentList.AbsoluteContentSize.Y + 25)
                
                return {
                    SetText = function(self, newText)
                        label.Text = newText
                    end
                }
            end
            
            sections[#sections + 1] = section
            return section
        end
        
        return window
    end
    
    -- Minimieren Funktion
    local minimized = false
    local originalSize = MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        if not minimized then
            MainFrame.Size = UDim2.new(0, 600, 0, 45)
            minimized = true
        else
            MainFrame.Size = originalSize
            minimized = false
        end
    end)
    
    -- Schließen Funktion
    CloseButton.MouseButton1Click:Connect(function()
        window.ScreenGui:Destroy()
    end)
    
    -- Setze ScreenGui Referenz für Notifications
    window.NotificationScreenGui = window.ScreenGui
    
    return window
end

-- Fenster zerstören
function CrystalUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Benachrichtigung erstellen
function CrystalUI:CreateNotification(title, text, duration)
    if not self.NotificationScreenGui then
        return
    end
    
    local theme = self.Themes.Default
    
    local notification = CreateInstance("Frame", {
        Size = UDim2.new(0, 250, 0, 80),
        Position = UDim2.new(1, -260, 1, -90),
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        Parent = self.NotificationScreenGui
    })
    
    local notifCorner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = notification
    })
    
    local titleLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        Parent = notification
    })
    
    local textLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = theme.SubText,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        Parent = notification
    })
    
    -- Animation
    CreateTween(notification, {Position = UDim2.new(1, -260, 1, -90)}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
    
    delay(duration or 3, function()
        CreateTween(notification, {Position = UDim2.new(1, -260, 1, 10)}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In):Play()
        wait(0.5)
        notification:Destroy()
    end)
end

return CrystalUI
