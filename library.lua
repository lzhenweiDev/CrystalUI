-- CrystalUI - Voll funktionsfähige Version
local CrystalUI = {}
CrystalUI.__index = CrystalUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Protect
local function Protect(gui)
    if syn and syn.protect_gui then
        gui.Parent = syn.protect_gui()
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = CoreGui
    end
end

-- Theme
local Theme = {
    Main = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(100, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Background = Color3.fromRGB(20, 20, 30),
    Border = Color3.fromRGB(60, 60, 80),
    Button = Color3.fromRGB(45, 45, 55),
    ButtonHover = Color3.fromRGB(65, 65, 75),
    ToggleOn = Color3.fromRGB(100, 100, 255),
    ToggleOff = Color3.fromRGB(60, 60, 70)
}

function CrystalUI:CreateWindow(config)
    config = config or {}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "CrystalUI"
    ScreenGui.ResetOnSpawn = false
    Protect(ScreenGui)
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 580, 0, 420)
    Main.Position = UDim2.new(0.5, -290, 0.5, -210)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    -- Titlebar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Theme.Main
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local TitleCover = Instance.new("Frame")
    TitleCover.Size = UDim2.new(1, 0, 0, 8)
    TitleCover.Position = UDim2.new(0, 0, 1, -8)
    TitleCover.BackgroundColor3 = Theme.Main
    TitleCover.BorderSizePixel = 0
    TitleCover.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = config.Title or "Crystal UI"
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 28, 0, 28)
    Close.Position = UDim2.new(1, -35, 0, 4)
    Close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 18
    Close.Font = Enum.Font.GothamBold
    Close.BorderSizePixel = 0
    Close.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close
    
    -- Minimize Button
    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.new(0, 28, 0, 28)
    Minimize.Position = UDim2.new(1, -68, 0, 4)
    Minimize.BackgroundColor3 = Theme.Button
    Minimize.Text = "—"
    Minimize.TextColor3 = Theme.Text
    Minimize.TextSize = 18
    Minimize.Font = Enum.Font.GothamBold
    Minimize.BorderSizePixel = 0
    Minimize.Parent = TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = Minimize
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(0, 150, 1, -40)
    TabBar.Position = UDim2.new(0, 0, 0, 38)
    TabBar.BackgroundColor3 = Theme.Main
    TabBar.BorderSizePixel = 0
    TabBar.Parent = Main
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 3)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabBar
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.Parent = TabBar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -155, 1, -45)
    ContentContainer.Position = UDim2.new(0, 152, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundColor3 = Theme.Secondary
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = ContentContainer
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 6)
    ContentCorner.Parent = ContentFrame
    
    -- Tab Content Holder
    local TabContentHolder = Instance.new("Frame")
    TabContentHolder.Size = UDim2.new(1, 0, 1, 0)
    TabContentHolder.BackgroundTransparency = 1
    TabContentHolder.Parent = ContentFrame
    
    -- Drag System
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
    
    -- Minimize/Maximize
    local minimized = false
    local originalSize = Main.Size
    
    Minimize.MouseButton1Click:Connect(function()
        if minimized then
            Main.Size = originalSize
            minimized = false
        else
            Main.Size = UDim2.new(0, 580, 0, 35)
            minimized = true
        end
    end)
    
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Window Object
    local Window = {}
    local currentTab = nil
    
    -- CreateTab Function
    function Window:CreateTab(name)
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Theme.Button
        TabButton.Text = name
        TabButton.TextColor3 = Theme.SubText
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabBar
        
        local TabBtnPadding = Instance.new("UIPadding")
        TabBtnPadding.PaddingLeft = UDim.new(0, 12)
        TabBtnPadding.Parent = TabButton
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 5)
        TabCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = TabContentHolder
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 6)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 8)
        ContentPadding.PaddingLeft = UDim.new(0, 8)
        ContentPadding.PaddingRight = UDim.new(0, 8)
        ContentPadding.PaddingBottom = UDim.new(0, 8)
        ContentPadding.Parent = TabContent
        
        -- Tab Click Handler
        TabButton.MouseButton1Click:Connect(function()
            -- Reset previous tab
            if currentTab then
                currentTab.Button.BackgroundColor3 = Theme.Button
                currentTab.Button.TextColor3 = Theme.SubText
                currentTab.Content.Visible = false
            end
            
            -- Activate new tab
            currentTab = {
                Button = TabButton,
                Content = TabContent
            }
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text
            TabContent.Visible = true
            
            -- Update scroll
            wait()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 16)
        end)
        
        -- Auto-select first tab
        if not currentTab then
            currentTab = {
                Button = TabButton,
                Content = TabContent
            }
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text
            TabContent.Visible = true
        end
        
        -- CreateSection Function
        function Window:CreateSection(name)
            local Section = {}
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 25)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = name:upper()
            SectionLabel.TextColor3 = Theme.SubText
            SectionLabel.TextSize = 11
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            -- Button
            function Section:CreateButton(name, callback)
                local BtnFrame = Instance.new("Frame")
                BtnFrame.Size = UDim2.new(1, 0, 0, 36)
                BtnFrame.BackgroundColor3 = Theme.Button
                BtnFrame.BorderSizePixel = 0
                BtnFrame.Parent = TabContent
                
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 5)
                BtnCorner.Parent = BtnFrame
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = name
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 13
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = BtnFrame
                
                local BtnPadding = Instance.new("UIPadding")
                BtnPadding.PaddingLeft = UDim.new(0, 12)
                BtnPadding.Parent = Btn
                
                Btn.MouseEnter:Connect(function()
                    BtnFrame.BackgroundColor3 = Theme.ButtonHover
                end)
                
                Btn.MouseLeave:Connect(function()
                    BtnFrame.BackgroundColor3 = Theme.Button
                end)
                
                Btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                
                return Btn
            end
            
            -- Toggle
            function Section:CreateToggle(name, default, callback)
                local TglFrame = Instance.new("Frame")
                TglFrame.Size = UDim2.new(1, 0, 0, 40)
                TglFrame.BackgroundColor3 = Theme.Button
                TglFrame.BorderSizePixel = 0
                TglFrame.Parent = TabContent
                
                local TglCorner = Instance.new("UICorner")
                TglCorner.CornerRadius = UDim.new(0, 5)
                TglCorner.Parent = TglFrame
                
                local TglLabel = Instance.new("TextLabel")
                TglLabel.Size = UDim2.new(0.6, 0, 1, 0)
                TglLabel.Position = UDim2.new(0, 12, 0, 0)
                TglLabel.BackgroundTransparency = 1
                TglLabel.Text = name
                TglLabel.TextColor3 = Theme.Text
                TglLabel.TextSize = 13
                TglLabel.Font = Enum.Font.Gotham
                TglLabel.TextXAlignment = Enum.TextXAlignment.Left
                TglLabel.Parent = TglFrame
                
                local TglBg = Instance.new("Frame")
                TglBg.Size = UDim2.new(0, 40, 0, 20)
                TglBg.Position = UDim2.new(1, -50, 0.5, -10)
                TglBg.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
                TglBg.BorderSizePixel = 0
                TglBg.Parent = TglFrame
                
                local TglBgCorner = Instance.new("UICorner")
                TglBgCorner.CornerRadius = UDim.new(0, 10)
                TglBgCorner.Parent = TglBg
                
                local TglDot = Instance.new("Frame")
                TglDot.Size = UDim2.new(0, 16, 0, 16)
                TglDot.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                TglDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TglDot.BorderSizePixel = 0
                TglDot.Parent = TglBg
                
                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = TglDot
                
                local TglBtn = Instance.new("TextButton")
                TglBtn.Size = UDim2.new(1, 0, 1, 0)
                TglBtn.BackgroundTransparency = 1
                TglBtn.Text = ""
                TglBtn.Parent = TglFrame
                
                local toggled = default or false
                
                TglBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        TweenService:Create(TglBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOn}):Play()
                        TweenService:Create(TglDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        TweenService:Create(TglBg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOff}):Play()
                        TweenService:Create(TglDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    if callback then callback(toggled) end
                end)
                
                return TglFrame
            end
            
            -- Slider
            function Section:CreateSlider(name, min, max, default, callback)
                local SldFrame = Instance.new("Frame")
                SldFrame.Size = UDim2.new(1, 0, 0, 55)
                SldFrame.BackgroundColor3 = Theme.Button
                SldFrame.BorderSizePixel = 0
                SldFrame.Parent = TabContent
                
                local SldCorner = Instance.new("UICorner")
                SldCorner.CornerRadius = UDim.new(0, 5)
                SldCorner.Parent = SldFrame
                
                local SldLabel = Instance.new("TextLabel")
                SldLabel.Size = UDim2.new(1, -20, 0, 20)
                SldLabel.Position = UDim2.new(0, 12, 0, 5)
                SldLabel.BackgroundTransparency = 1
                SldLabel.Text = name .. " — " .. tostring(default)
                SldLabel.TextColor3 = Theme.Text
                SldLabel.TextSize = 12
                SldLabel.Font = Enum.Font.Gotham
                SldLabel.TextXAlignment = Enum.TextXAlignment.Left
                SldLabel.Parent = SldFrame
                
                local SldBg = Instance.new("Frame")
                SldBg.Size = UDim2.new(1, -24, 0, 4)
                SldBg.Position = UDim2.new(0, 12, 0, 35)
                SldBg.BackgroundColor3 = Theme.ToggleOff
                SldBg.BorderSizePixel = 0
                SldBg.Parent = SldFrame
                
                local SldBgCorner = Instance.new("UICorner")
                SldBgCorner.CornerRadius = UDim.new(0, 2)
                SldBgCorner.Parent = SldBg
                
                local percent = (default - min) / (max - min)
                
                local SldFill = Instance.new("Frame")
                SldFill.Size = UDim2.new(percent, 0, 1, 0)
                SldFill.BackgroundColor3 = Theme.Accent
                SldFill.BorderSizePixel = 0
                SldFill.Parent = SldBg
                
                local SldFillCorner = Instance.new("UICorner")
                SldFillCorner.CornerRadius = UDim.new(0, 2)
                SldFillCorner.Parent = SldFill
                
                local SldDot = Instance.new("Frame")
                SldDot.Size = UDim2.new(0, 12, 0, 12)
                SldDot.Position = UDim2.new(percent, -6, 0.5, -6)
                SldDot.BackgroundColor3 = Theme.Text
                SldDot.BorderSizePixel = 0
                SldDot.Parent = SldBg
                
                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = SldDot
                
                local sliderDrag = false
                
                local function updateValue(input)
                    local size = SldBg.AbsoluteSize.X
                    if size <= 0 then return end
                    local pos = math.clamp((input.Position.X - SldBg.AbsolutePosition.X) / size, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    
                    SldFill.Size = UDim2.new(pos, 0, 1, 0)
                    SldDot.Position = UDim2.new(pos, -6, 0.5, -6)
                    SldLabel.Text = name .. " — " .. tostring(val)
                    
                    if callback then callback(val) end
                end
                
                SldDot.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDrag = true
                    end
                end)
                
                SldBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDrag = true
                        updateValue(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if sliderDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateValue(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliderDrag = false
                    end
                end)
                
                return SldFrame
            end
            
            -- Dropdown
            function Section:CreateDropdown(name, options, callback)
                local DdFrame = Instance.new("Frame")
                DdFrame.Size = UDim2.new(1, 0, 0, 36)
                DdFrame.BackgroundColor3 = Theme.Button
                DdFrame.BorderSizePixel = 0
                DdFrame.Parent = TabContent
                
                local DdCorner = Instance.new("UICorner")
                DdCorner.CornerRadius = UDim.new(0, 5)
                DdCorner.Parent = DdFrame
                
                local DdBtn = Instance.new("TextButton")
                DdBtn.Size = UDim2.new(1, 0, 1, 0)
                DdBtn.BackgroundTransparency = 1
                DdBtn.Text = name .. "  ▼"
                DdBtn.TextColor3 = Theme.Text
                DdBtn.TextSize = 13
                DdBtn.Font = Enum.Font.Gotham
                DdBtn.TextXAlignment = Enum.TextXAlignment.Left
                DdBtn.Parent = DdFrame
                
                local DdPadding = Instance.new("UIPadding")
                DdPadding.PaddingLeft = UDim.new(0, 12)
                DdPadding.Parent = DdBtn
                
                local OptFrame = Instance.new("Frame")
                OptFrame.Size = UDim2.new(1, 0, 0, 0)
                OptFrame.Position = UDim2.new(0, 0, 1, 3)
                OptFrame.BackgroundColor3 = Theme.Button
                OptFrame.BorderSizePixel = 0
                OptFrame.Visible = false
                OptFrame.ZIndex = 10
                OptFrame.Parent = DdFrame
                
                local OptCorner = Instance.new("UICorner")
                OptCorner.CornerRadius = UDim.new(0, 5)
                OptCorner.Parent = OptFrame
                
                local OptList = Instance.new("UIListLayout")
                OptList.SortOrder = Enum.SortOrder.LayoutOrder
                OptList.Parent = OptFrame
                
                for _, option in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 28)
                    OptBtn.BackgroundTransparency = 1
                    OptBtn.Text = option
                    OptBtn.TextColor3 = Theme.Text
                    OptBtn.TextSize = 13
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.ZIndex = 11
                    OptBtn.Parent = OptFrame
                    
                    local OptPadding = Instance.new("UIPadding")
                    OptPadding.PaddingLeft = UDim.new(0, 12)
                    OptPadding.Parent = OptBtn
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        DdBtn.Text = name .. " — " .. option .. "  ▼"
                        OptFrame.Visible = false
                        if callback then callback(option) end
                    end)
                end
                
                DdBtn.MouseButton1Click:Connect(function()
                    OptFrame.Visible = not OptFrame.Visible
                    if OptFrame.Visible then
                        OptFrame.Size = UDim2.new(1, 0, 0, #options * 28)
                    end
                end)
                
                return DdFrame
            end
            
            -- Label
            function Section:CreateLabel(text)
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 20)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = Theme.SubText
                Lbl.TextSize = 12
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = TabContent
                
                local LblPadding = Instance.new("UIPadding")
                LblPadding.PaddingLeft = UDim.new(0, 12)
                LblPadding.Parent = Lbl
                
                return Lbl
            end
            
            return Section
        end
        
        return Window
    end
    
    return Window
end

return CrystalUI
