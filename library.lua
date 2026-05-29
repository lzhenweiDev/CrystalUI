local CrystalUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Protect GUI
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
    Second = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(100, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180),
    Background = Color3.fromRGB(20, 20, 30)
}

function CrystalUI:CreateWindow(config)
    config = config or {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CrystalUI"
    Protect(ScreenGui)
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 520, 0, 360)
    Main.Position = UDim2.new(0.5, -260, 0.5, -180)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundColor3 = Theme.Main
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)
    
    -- Cover bottom corners of TopBar
    local Cover = Instance.new("Frame")
    Cover.Size = UDim2.new(1, 0, 0, 6)
    Cover.Position = UDim2.new(0, 0, 1, -6)
    Cover.BackgroundColor3 = Theme.Main
    Cover.BorderSizePixel = 0
    Cover.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Crystal UI"
    Title.TextColor3 = Theme.Text
    Title.TextSize = 13
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 24, 0, 24)
    Close.Position = UDim2.new(1, -28, 0, 4)
    Close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 16
    Close.Font = Enum.Font.GothamBold
    Close.BorderSizePixel = 0
    Close.Parent = TopBar
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)
    
    -- Minimize Button
    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.new(0, 24, 0, 24)
    Minimize.Position = UDim2.new(1, -56, 0, 4)
    Minimize.BackgroundColor3 = Theme.Second
    Minimize.Text = "—"
    Minimize.TextColor3 = Theme.Text
    Minimize.TextSize = 14
    Minimize.Font = Enum.Font.GothamBold
    Minimize.BorderSizePixel = 0
    Minimize.Parent = TopBar
    Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 4)
    
    -- Navigation (Sidebar)
    local Nav = Instance.new("Frame")
    Nav.Size = UDim2.new(0, 130, 1, -37)
    Nav.Position = UDim2.new(0, 0, 0, 34)
    Nav.BackgroundColor3 = Theme.Main
    Nav.BorderSizePixel = 0
    Nav.Parent = Main
    
    local NavList = Instance.new("UIListLayout")
    NavList.Padding = UDim.new(0, 3)
    NavList.SortOrder = Enum.SortOrder.LayoutOrder
    NavList.Parent = Nav
    
    local NavPad = Instance.new("UIPadding")
    NavPad.PaddingTop = UDim.new(0, 6)
    NavPad.PaddingLeft = UDim.new(0, 6)
    NavPad.PaddingRight = UDim.new(0, 6)
    NavPad.Parent = Nav
    
    -- Content Area
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -135, 1, -40)
    Content.Position = UDim2.new(0, 132, 0, 36)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    
    -- Drag
    local drag = false
    local start, spos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = input.Position
            spos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - start
            Main.Position = UDim2.new(spos.X.Scale, spos.X.Offset + delta.X, spos.Y.Scale, spos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = false
        end
    end)
    
    -- Minimize
    local min = false
    Minimize.MouseButton1Click:Connect(function()
        min = not min
        Main.Size = min and UDim2.new(0, 520, 0, 32) or UDim2.new(0, 520, 0, 360)
    end)
    
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tabs
    local tabs = {}
    local current = nil
    
    local Window = {}
    
    function Window:CreateTab(name)
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 28)
        TabBtn.BackgroundColor3 = Theme.Second
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.TextSize = 12
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = Nav
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        
        local TPad = Instance.new("UIPadding")
        TPad.PaddingLeft = UDim.new(0, 8)
        TPad.Parent = TabBtn
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = Content
        
        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0, 6)
        List.SortOrder = Enum.SortOrder.LayoutOrder
        List.Parent = TabContent
        
        local Pad = Instance.new("UIPadding")
        Pad.PaddingTop = UDim.new(0, 6)
        Pad.PaddingLeft = UDim.new(0, 6)
        Pad.PaddingRight = UDim.new(0, 6)
        Pad.PaddingBottom = UDim.new(0, 6)
        Pad.Parent = TabContent
        
        -- Tab Click
        TabBtn.MouseButton1Click:Connect(function()
            if current then
                current.Button.BackgroundColor3 = Theme.Second
                current.Button.TextColor3 = Theme.SubText
                current.Content.Visible = false
            end
            current = {Button = TabBtn, Content = TabContent}
            TabBtn.BackgroundColor3 = Theme.Accent
            TabBtn.TextColor3 = Theme.Text
            TabContent.Visible = true
        end)
        
        -- Auto select first
        if not current then
            current = {Button = TabBtn, Content = TabContent}
            TabBtn.BackgroundColor3 = Theme.Accent
            TabBtn.TextColor3 = Theme.Text
            TabContent.Visible = true
        end
        
        -- Create Section
        function Window:CreateSection(name)
            local Section = {}
            
            -- Header
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 20)
            Header.BackgroundTransparency = 1
            Header.Parent = TabContent
            
            local HeaderText = Instance.new("TextLabel")
            HeaderText.Size = UDim2.new(1, 0, 1, 0)
            HeaderText.BackgroundTransparency = 1
            HeaderText.Text = name:upper()
            HeaderText.TextColor3 = Theme.SubText
            HeaderText.TextSize = 10
            HeaderText.Font = Enum.Font.GothamBold
            HeaderText.TextXAlignment = Enum.TextXAlignment.Left
            HeaderText.Parent = Header
            
            -- Button
            function Section:CreateButton(name, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = name
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 12
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = Frame
                
                local BPad = Instance.new("UIPadding")
                BPad.PaddingLeft = UDim.new(0, 10)
                BPad.Parent = Btn
                
                Btn.MouseEnter:Connect(function() Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55) end)
                Btn.MouseLeave:Connect(function() Frame.BackgroundColor3 = Theme.Second end)
                Btn.MouseButton1Click:Connect(function() if callback then callback() end end)
                
                return Btn
            end
            
            -- Toggle
            function Section:CreateToggle(name, default, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 38)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 1, 0)
                Label.Position = UDim2.new(0, 10, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Theme.Text
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Bg = Instance.new("Frame")
                Bg.Size = UDim2.new(0, 36, 0, 18)
                Bg.Position = UDim2.new(1, -44, 0.5, -9)
                Bg.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(60, 60, 70)
                Bg.BorderSizePixel = 0
                Bg.Parent = Frame
                Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 9)
                
                local Dot = Instance.new("Frame")
                Dot.Size = UDim2.new(0, 14, 0, 14)
                Dot.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dot.BorderSizePixel = 0
                Dot.Parent = Bg
                Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
                
                local Click = Instance.new("TextButton")
                Click.Size = UDim2.new(1, 0, 1, 0)
                Click.BackgroundTransparency = 1
                Click.Text = ""
                Click.Parent = Frame
                
                local toggled = default or false
                Click.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
                    else
                        TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
                        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
                    end
                    if callback then callback(toggled) end
                end)
                
                return Frame
            end
            
            -- Slider
            function Section:CreateSlider(name, min, max, default, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 48)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -20, 0, 18)
                Label.Position = UDim2.new(0, 10, 0, 3)
                Label.BackgroundTransparency = 1
                Label.Text = name .. ": " .. tostring(default)
                Label.TextColor3 = Theme.Text
                Label.TextSize = 11
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local Bg = Instance.new("Frame")
                Bg.Size = UDim2.new(1, -20, 0, 3)
                Bg.Position = UDim2.new(0, 10, 0, 30)
                Bg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                Bg.BorderSizePixel = 0
                Bg.Parent = Frame
                Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 2)
                
                local percent = (default - min) / (max - min)
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                Fill.BackgroundColor3 = Theme.Accent
                Fill.BorderSizePixel = 0
                Fill.Parent = Bg
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 2)
                
                local Dot = Instance.new("Frame")
                Dot.Size = UDim2.new(0, 10, 0, 10)
                Dot.Position = UDim2.new(percent, -5, 0.5, -5)
                Dot.BackgroundColor3 = Theme.Text
                Dot.BorderSizePixel = 0
                Dot.Parent = Bg
                Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
                
                local drag = false
                local function upd(input)
                    local sz = Bg.AbsoluteSize.X
                    if sz <= 0 then return end
                    local pos = math.clamp((input.Position.X - Bg.AbsolutePosition.X) / sz, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    Dot.Position = UDim2.new(pos, -5, 0.5, -5)
                    Label.Text = name .. ": " .. tostring(val)
                    if callback then callback(val) end
                end
                
                Dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
                Bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; upd(i) end end)
                UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
                
                return Frame
            end
            
            -- Dropdown
            function Section:CreateDropdown(name, options, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = name .. " ▼"
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 12
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = Frame
                
                local BPad = Instance.new("UIPadding")
                BPad.PaddingLeft = UDim.new(0, 10)
                BPad.Parent = Btn
                
                local Opts = Instance.new("Frame")
                Opts.Size = UDim2.new(1, 0, 0, #options * 26)
                Opts.Position = UDim2.new(0, 0, 1, 2)
                Opts.BackgroundColor3 = Theme.Second
                Opts.BorderSizePixel = 0
                Opts.Visible = false
                Opts.ZIndex = 10
                Opts.Parent = Frame
                Instance.new("UICorner", Opts).CornerRadius = UDim.new(0, 4)
                
                local OptList = Instance.new("UIListLayout")
                OptList.SortOrder = Enum.SortOrder.LayoutOrder
                OptList.Parent = Opts
                
                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 26)
                    OptBtn.BackgroundTransparency = 1
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = Theme.Text
                    OptBtn.TextSize = 12
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.ZIndex = 11
                    OptBtn.Parent = Opts
                    
                    local OPad = Instance.new("UIPadding")
                    OPad.PaddingLeft = UDim.new(0, 10)
                    OPad.Parent = OptBtn
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        Btn.Text = name .. ": " .. opt .. " ▼"
                        Opts.Visible = false
                        if callback then callback(opt) end
                    end)
                end
                
                Btn.MouseButton1Click:Connect(function()
                    Opts.Visible = not Opts.Visible
                end)
                
                return Frame
            end
            
            -- Label
            function Section:CreateLabel(text)
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 18)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = Theme.SubText
                Lbl.TextSize = 11
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = TabContent
                
                local LPad = Instance.new("UIPadding")
                LPad.PaddingLeft = UDim.new(0, 10)
                LPad.Parent = Lbl
                
                return Lbl
            end
            
            return Section
        end
        
        return Window
    end
    
    return Window
end

return CrystalUI
