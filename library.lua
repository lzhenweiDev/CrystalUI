-- CrystalUI - Funktionierende UI-Bibliothek
local CrystalUI = {}
CrystalUI.__index = CrystalUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ProtectGui Funktion
local function ProtectGui(gui)
    if syn and syn.protect_gui then
        gui.Parent = syn.protect_gui()
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = CoreGui
    end
end

-- Themes
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
        ButtonHover = Color3.fromRGB(65, 65, 75),
        Toggle = Color3.fromRGB(100, 100, 255),
        Slider = Color3.fromRGB(100, 100, 255),
        Dropdown = Color3.fromRGB(45, 45, 55)
    }
}

-- Fenster erstellen
function CrystalUI:CreateWindow(config)
    config = config or {}
    local theme = self.Themes.Default
    
    -- ScreenGui erstellen
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "CrystalUI"
    ProtectGui(ScreenGui)
    
    -- Hauptframe
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    -- UICorner für Main
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    -- Titlebar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = theme.Main
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "Crystal UI"
    TitleLabel.TextColor3 = theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Minimize Button
    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.new(0, 30, 0, 30)
    Minimize.Position = UDim2.new(1, -70, 0, 5)
    Minimize.BackgroundColor3 = theme.Button
    Minimize.Text = "—"
    Minimize.TextColor3 = theme.Text
    Minimize.TextSize = 18
    Minimize.Font = Enum.Font.GothamBold
    Minimize.BorderSizePixel = 0
    Minimize.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = Minimize
    
    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 20
    Close.Font = Enum.Font.GothamBold
    Close.BorderSizePixel = 0
    Close.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(0, 160, 1, -50)
    TabBar.Position = UDim2.new(0, 0, 0, 45)
    TabBar.BackgroundColor3 = theme.Main
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Main
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 2)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabBar
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabBar
    
    -- Content Frame
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -170, 1, -60)
    Content.Position = UDim2.new(0, 165, 0, 50)
    Content.BackgroundColor3 = theme.Secondary
    Content.BorderSizePixel = 0
    Content.Parent = Main
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = Content
    
    -- Scrolling Frame
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ScrollBarImageColor3 = theme.Accent
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Parent = Content
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.Parent = ScrollingFrame
    
    -- Drag Funktionalität
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
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
    
    -- Window Objekt
    local Window = {
        ScreenGui = ScreenGui,
        Main = Main,
        Tabs = {}
    }
    
    -- Tabs verwalten
    local currentTab = nil
    
    -- Tab erstellen
    function Window:CreateTab(name)
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = theme.Button
        TabButton.Text = name
        TabButton.TextColor3 = theme.TabText
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabBar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = ScrollingFrame
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 5)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingLeft = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.Parent = TabContent
        
        -- Tab auswählen
        TabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Button.TextColor3 = theme.TabText
                currentTab.Content.Visible = false
            end
            
            currentTab = {Button = TabButton, Content = TabContent}
            TabButton.TextColor3 = theme.Text
            TabButton.BackgroundColor3 = theme.Accent
            TabContent.Visible = true
            
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Ersten Tab automatisch auswählen
        if not currentTab then
            currentTab = {Button = TabButton, Content = TabContent}
            TabButton.TextColor3 = theme.Text
            TabButton.BackgroundColor3 = theme.Accent
            TabContent.Visible = true
        end
        
        -- Section erstellen
        function Window:CreateSection(name)
            local Section = {}
            
            -- Section Header
            local SectionHeader = Instance.new("Frame")
            SectionHeader.Size = UDim2.new(1, 0, 0, 30)
            SectionHeader.BackgroundTransparency = 1
            SectionHeader.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = name
            SectionLabel.TextColor3 = theme.SubText
            SectionLabel.TextSize = 12
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionHeader
            
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 1, 0)
            Line.BackgroundColor3 = theme.Border
            Line.BorderSizePixel = 0
            Line.BackgroundTransparency = 0.5
            Line.Parent = SectionHeader
            
            -- Button
            function Section:CreateButton(name, callback)
                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
                ButtonFrame.BackgroundColor3 = theme.Button
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Parent = TabContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = ButtonFrame
                
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, 0, 1, 0)
                Button.BackgroundTransparency = 1
                Button.Text = name
                Button.TextColor3 = theme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.TextXAlignment = Enum.TextXAlignment.Left
                Button.Parent = ButtonFrame
                
                local ButtonPadding = Instance.new("UIPadding")
                ButtonPadding.PaddingLeft = UDim.new(0, 10)
                ButtonPadding.Parent = Button
                
                Button.MouseEnter:Connect(function()
                    ButtonFrame.BackgroundColor3 = theme.ButtonHover
                end)
                
                Button.MouseLeave:Connect(function()
                    ButtonFrame.BackgroundColor3 = theme.Button
                end)
                
                Button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)
                
                return Button
            end
            
            -- Toggle
            function Section:CreateToggle(name, default, callback)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
                ToggleFrame.BackgroundColor3 = theme.Button
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = TabContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = ToggleFrame
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = theme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleBg = Instance.new("Frame")
                ToggleBg.Size = UDim2.new(0, 44, 0, 24)
                ToggleBg.Position = UDim2.new(1, -54, 0.5, -12)
                ToggleBg.BackgroundColor3 = default and theme.Accent or Color3.fromRGB(60, 60, 70)
                ToggleBg.BorderSizePixel = 0
                ToggleBg.Parent = ToggleFrame
                
                local ToggleBgCorner = Instance.new("UICorner")
                ToggleBgCorner.CornerRadius = UDim.new(0, 12)
                ToggleBgCorner.Parent = ToggleBg
                
                local ToggleDot = Instance.new("Frame")
                ToggleDot.Size = UDim2.new(0, 18, 0, 18)
                ToggleDot.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleDot.BorderSizePixel = 0
                ToggleDot.Parent = ToggleBg
                
                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = ToggleDot
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                local toggled = default or false
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    if toggled then
                        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}):Play()
                        TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
                    else
                        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
                        TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
                    end
                    
                    if callback then
                        callback(toggled)
                    end
                end)
                
                return {
                    SetState = function(_, state)
                        toggled = state
                        if toggled then
                            TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Accent}):Play()
                            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
                        else
                            TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
                            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
                        end
                    end
                }
            end
            
            -- Slider
            function Section:CreateSlider(name, min, max, default, callback)
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 55)
                SliderFrame.BackgroundColor3 = theme.Button
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = TabContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = SliderFrame
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -20, 0, 20)
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = name .. " - " .. default
                SliderLabel.TextColor3 = theme.Text
                SliderLabel.TextSize = 13
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderBg = Instance.new("Frame")
                SliderBg.Size = UDim2.new(1, -20, 0, 4)
                SliderBg.Position = UDim2.new(0, 10, 0, 35)
                SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                SliderBg.BorderSizePixel = 0
                SliderBg.Parent = SliderFrame
                
                local SliderBgCorner = Instance.new("UICorner")
                SliderBgCorner.CornerRadius = UDim.new(0, 2)
                SliderBgCorner.Parent = SliderBg
                
                local SliderFill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderFill.BackgroundColor3 = theme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBg
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(0, 2)
                SliderFillCorner.Parent = SliderFill
                
                local SliderDot = Instance.new("Frame")
                SliderDot.Size = UDim2.new(0, 12, 0, 12)
                SliderDot.Position = UDim2.new(percent, -6, 0.5, -6)
                SliderDot.BackgroundColor3 = theme.Text
                SliderDot.BorderSizePixel = 0
                SliderDot.Parent = SliderBg
                
                local SliderDotCorner = Instance.new("UICorner")
                SliderDotCorner.CornerRadius = UDim.new(1, 0)
                SliderDotCorner.Parent = SliderDot
                
                local sliderDragging = false
                
                local function updateSlider(input)
                    local sizeX = SliderBg.AbsoluteSize.X
                    local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / sizeX, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderDot.Position = UDim2.new(pos, -6, 0.5, -6)
                    SliderLabel.Text = name .. " - " .. value
                    
                    if callback then
                        callback(value)
                    end
                end
                
                SliderDot.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = true
                    end
                end)
                
                SliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = true
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDragging = false
                    end
                end)
                
                return {}
            end
            
            -- Dropdown
            function Section:CreateDropdown(name, options, callback)
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.BackgroundColor3 = theme.Button
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Parent = TabContent
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = name .. " ▼"
                DropdownButton.TextColor3 = theme.Text
                DropdownButton.TextSize = 14
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.Parent = DropdownFrame
                
                local DropdownPadding = Instance.new("UIPadding")
                DropdownPadding.PaddingLeft = UDim.new(0, 10)
                DropdownPadding.Parent = DropdownButton
                
                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 25 + 10)
                OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
                OptionsFrame.BackgroundColor3 = theme.Dropdown
                OptionsFrame.BorderSizePixel = 0
                OptionsFrame.Visible = false
                OptionsFrame.ZIndex = 10
                OptionsFrame.Parent = DropdownFrame
                
                local OptionsCorner = Instance.new("UICorner")
                OptionsCorner.CornerRadius = UDim.new(0, 6)
                OptionsCorner.Parent = OptionsFrame
                
                local OptionsList = Instance.new("UIListLayout")
                OptionsList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionsList.Parent = OptionsFrame
                
                local OptionsPadding = Instance.new("UIPadding")
                OptionsPadding.PaddingTop = UDim.new(0, 5)
                OptionsPadding.PaddingBottom = UDim.new(0, 5)
                OptionsPadding.Parent = OptionsFrame
                
                -- Optionen erstellen
                for i, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Text = option
                    OptionButton.TextColor3 = theme.Text
                    OptionButton.TextSize = 13
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.TextXAlignment = Enum.TextXAlignment.Left
                    OptionButton.ZIndex = 11
                    OptionButton.Parent = OptionsFrame
                    
                    local OptionPadding = Instance.new("UIPadding")
                    OptionPadding.PaddingLeft = UDim.new(0, 10)
                    OptionPadding.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = name .. ": " .. option .. " ▼"
                        OptionsFrame.Visible = false
                        if callback then
                            callback(option)
                        end
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    OptionsFrame.Visible = not OptionsFrame.Visible
                end)
                
                return {}
            end
            
            return Section
        end
        
        return Window
    end
    
    -- Minimieren
    local minimized = false
    Minimize.MouseButton1Click:Connect(function()
        if minimized then
            Main.Size = UDim2.new(0, 600, 0, 400)
            minimized = false
        else
            Main.Size = UDim2.new(0, 600, 0, 40)
            minimized = true
        end
    end)
    
    -- Schließen
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    return Window
end

return CrystalUI
