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

-- Liquid/Glass Theme
local Theme = {
    Main = Color3.fromRGB(30, 30, 40),
    Second = Color3.fromRGB(40, 40, 55),
    Accent = Color3.fromRGB(120, 120, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200),
    Glass = Color3.fromRGB(255, 255, 255), -- Für Transparenz
    GlassBackground = Color3.fromRGB(20, 20, 30)
}

function CrystalUI:CreateWindow(config)
    config = config or {}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CrystalUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Protect(ScreenGui)
    
    -- Main Frame mit Glass-Effekt
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 550, 0, 400)
    Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    Main.BackgroundColor3 = Theme.GlassBackground
    Main.BackgroundTransparency = 0.15
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    -- Glass Border
    local GlassBorder = Instance.new("Frame")
    GlassBorder.Size = UDim2.new(1, 4, 1, 4)
    GlassBorder.Position = UDim2.new(0, -2, 0, -2)
    GlassBorder.BackgroundColor3 = Theme.Glass
    GlassBorder.BackgroundTransparency = 0.8
    GlassBorder.BorderSizePixel = 0
    GlassBorder.Parent = Main
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    Instance.new("UICorner", GlassBorder).CornerRadius = UDim.new(0, 13)
    
    -- Blur-Effekt (falls verfügbar)
    pcall(function()
        local Blur = Instance.new("BlurEffect")
        Blur.Size = 10
        Blur.Parent = Main
    end)
    
    -- Top Bar (Glass)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.Main
    TopBar.BackgroundTransparency = 0.3
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    
    local TopCover = Instance.new("Frame")
    TopCover.Size = UDim2.new(1, 0, 0, 6)
    TopCover.Position = UDim2.new(0, 0, 1, -6)
    TopCover.BackgroundColor3 = Theme.Main
    TopCover.BackgroundTransparency = 0.3
    TopCover.BorderSizePixel = 0
    TopCover.Parent = TopBar
    
    -- Title mit Animation
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Crystal UI"
    Title.TextColor3 = Theme.Text
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTransparency = 0
    Title.Parent = TopBar
    
    -- Close Button (Glass)
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -37, 0, 5)
    Close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    Close.BackgroundTransparency = 0.2
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 18
    Close.Font = Enum.Font.GothamBold
    Close.BorderSizePixel = 0
    Close.Parent = TopBar
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
    
    -- Minimize Button (Glass)
    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.new(0, 30, 0, 30)
    Minimize.Position = UDim2.new(1, -72, 0, 5)
    Minimize.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    Minimize.BackgroundTransparency = 0.2
    Minimize.Text = "—"
    Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.TextSize = 18
    Minimize.Font = Enum.Font.GothamBold
    Minimize.BorderSizePixel = 0
    Minimize.Parent = TopBar
    Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 8)
    
    -- Navigation (Sidebar Glass)
    local Nav = Instance.new("Frame")
    Nav.Size = UDim2.new(0, 150, 1, -45)
    Nav.Position = UDim2.new(0, 0, 0, 42)
    Nav.BackgroundColor3 = Theme.Main
    Nav.BackgroundTransparency = 0.4
    Nav.BorderSizePixel = 0
    Nav.Parent = Main
    
    local NavList = Instance.new("UIListLayout")
    NavList.Padding = UDim.new(0, 4)
    NavList.SortOrder = Enum.SortOrder.LayoutOrder
    NavList.Parent = Nav
    
    local NavPad = Instance.new("UIPadding")
    NavPad.PaddingTop = UDim.new(0, 8)
    NavPad.PaddingLeft = UDim.new(0, 8)
    NavPad.PaddingRight = UDim.new(0, 8)
    NavPad.Parent = Nav
    
    -- Content Area
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -155, 1, -50)
    Content.Position = UDim2.new(0, 152, 0, 44)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    
    -- Drag System mit smoother Bewegung
    local dragging = false
    local dragStart, startPos
    local dragVelocity = Vector2.new(0, 0)
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Button Hover Animation
    local function AddHoverAnimation(button, frame)
        button.MouseEnter:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.3
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.5
            }):Play()
        end)
    end
    
    -- Minimize mit Animation
    local minimized = false
    local originalSize = Main.Size
    local originalNavSize = Nav.Size
    local originalContentPos = Content.Position
    
    Minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 550, 0, 40)
            }):Play()
            Nav.Visible = false
            Content.Visible = false
        else
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize
            }):Play()
            Nav.Visible = true
            Content.Visible = true
        end
    end)
    
    -- Close mit Animation
    Close.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Tabs System
    local current = nil
    
    local Window = {}
    
    function Window:CreateTab(name, icon)
        -- Tab Button mit Glass-Effekt
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Theme.Second
        TabBtn.BackgroundTransparency = 0.5
        TabBtn.Text = (icon or "") .. "  " .. name
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.TextSize = 12
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.BorderSizePixel = 0
        TabBtn.AutoButtonColor = false
        TabBtn.ClipsDescendants = true
        TabBtn.Parent = Nav
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn
        
        local TabPad = Instance.new("UIPadding")
        TabPad.PaddingLeft = UDim.new(0, 10)
        TabPad.Parent = TabBtn
        
        -- Selection Indicator (animierter Balken)
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0.6, 0)
        Indicator.Position = UDim2.new(0, 0, 0.2, 0)
        Indicator.BackgroundColor3 = Theme.Accent
        Indicator.BackgroundTransparency = 1
        Indicator.BorderSizePixel = 0
        Indicator.Parent = TabBtn
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 2)
        
        -- Tab Content mit Glass-Effekt
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.ScrollBarImageTransparency = 0.5
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.ScrollBarImageTransparency = 0.7
        TabContent.Parent = Content
        
        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0, 6)
        List.SortOrder = Enum.SortOrder.LayoutOrder
        List.Parent = TabContent
        
        local Pad = Instance.new("UIPadding")
        Pad.PaddingTop = UDim.new(0, 8)
        Pad.PaddingLeft = UDim.new(0, 8)
        Pad.PaddingRight = UDim.new(0, 8)
        Pad.PaddingBottom = UDim.new(0, 8)
        Pad.Parent = TabContent
        
        -- Tab Switch mit Animation
        TabBtn.MouseButton1Click:Connect(function()
            if current and current.Button == TabBtn then return end
            
            if current then
                -- Alten Tab deaktivieren
                TweenService:Create(current.Button, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.5,
                    TextColor3 = Theme.SubText
                }):Play()
                TweenService:Create(current.Indicator, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1
                }):Play()
                current.Content.Visible = false
            end
            
            -- Neuen Tab aktivieren
            current = {
                Button = TabBtn,
                Content = TabContent,
                Indicator = Indicator
            }
            
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.3,
                TextColor3 = Theme.Text
            }):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            }):Play()
            TabContent.Visible = true
        end)
        
        -- Auto-select first tab with animation
        if not current then
            current = {
                Button = TabBtn,
                Content = TabContent,
                Indicator = Indicator
            }
            TabBtn.BackgroundTransparency = 0.3
            TabBtn.TextColor3 = Theme.Text
            Indicator.BackgroundTransparency = 0
            TabContent.Visible = true
        end
        
        -- Add hover animation
        AddHoverAnimation(TabBtn, TabBtn)
        
        -- Create Section
        function Window:CreateSection(name)
            local Section = {}
            
            -- Section Header mit Animation
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 22)
            Header.BackgroundTransparency = 1
            Header.Parent = TabContent
            
            local HeaderText = Instance.new("TextLabel")
            HeaderText.Size = UDim2.new(1, 0, 1, 0)
            HeaderText.BackgroundTransparency = 1
            HeaderText.Text = name:upper()
            HeaderText.TextColor3 = Theme.SubText
            HeaderText.TextTransparency = 0.3
            HeaderText.TextSize = 10
            HeaderText.Font = Enum.Font.GothamBold
            HeaderText.TextXAlignment = Enum.TextXAlignment.Left
            HeaderText.Parent = Header
            
            -- Divider Line
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 1)
            Divider.Position = UDim2.new(0, 0, 1, 0)
            Divider.BackgroundColor3 = Theme.SubText
            Divider.BackgroundTransparency = 0.8
            Divider.BorderSizePixel = 0
            Divider.Parent = Header
            
            -- Create Button mit Glass und Animation
            function Section:CreateButton(name, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BackgroundTransparency = 0.5
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
                
                -- Glow Effect
                local Glow = Instance.new("Frame")
                Glow.Size = UDim2.new(1, 0, 0, 1)
                Glow.Position = UDim2.new(0, 0, 1, 0)
                Glow.BackgroundColor3 = Theme.Accent
                Glow.BackgroundTransparency = 1
                Glow.BorderSizePixel = 0
                Glow.Parent = Frame
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = name
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 13
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = Frame
                
                local BtnPad = Instance.new("UIPadding")
                BtnPad.PaddingLeft = UDim.new(0, 12)
                BtnPad.Parent = Btn
                
                -- Hover Animationen
                Btn.MouseEnter:Connect(function()
                    TweenService:Create(Frame, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.3
                    }):Play()
                    TweenService:Create(Glow, TweenInfo.new(0.3), {
                        BackgroundTransparency = 0.5
                    }):Play()
                end)
                
                Btn.MouseLeave:Connect(function()
                    TweenService:Create(Frame, TweenInfo.new(0.2), {
                        BackgroundTransparency = 0.5
                    }):Play()
                    TweenService:Create(Glow, TweenInfo.new(0.3), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
                
                -- Click Animation
                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Frame, TweenInfo.new(0.1), {
                        Size = UDim2.new(0.98, 0, 0.95, 0)
                    }):Play()
                    wait(0.05)
                    TweenService:Create(Frame, TweenInfo.new(0.1), {
                        Size = UDim2.new(1, 0, 0, 36)
                    }):Play()
                    
                    if callback then callback() end
                end)
                
                return Frame
            end
            
            -- Create Toggle mit Glass und Animation
            function Section:CreateToggle(name, default, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 42)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BackgroundTransparency = 0.5
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.65, 0, 1, 0)
                Label.Position = UDim2.new(0, 12, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Theme.Text
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local ToggleBg = Instance.new("Frame")
                ToggleBg.Size = UDim2.new(0, 42, 0, 22)
                ToggleBg.Position = UDim2.new(1, -54, 0.5, -11)
                ToggleBg.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(60, 60, 70)
                ToggleBg.BackgroundTransparency = 0.3
                ToggleBg.BorderSizePixel = 0
                ToggleBg.Parent = Frame
                Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(0, 11)
                
                local ToggleDot = Instance.new("Frame")
                ToggleDot.Size = UDim2.new(0, 18, 0, 18)
                ToggleDot.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleDot.BackgroundTransparency = 0.1
                ToggleDot.BorderSizePixel = 0
                ToggleDot.Parent = ToggleBg
                Instance.new("UICorner", ToggleDot).CornerRadius = UDim.new(1, 0)
                
                local ClickBtn = Instance.new("TextButton")
                ClickBtn.Size = UDim2.new(1, 0, 1, 0)
                ClickBtn.BackgroundTransparency = 1
                ClickBtn.Text = ""
                ClickBtn.Parent = Frame
                
                local toggled = default or false
                ClickBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        TweenService:Create(ToggleBg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundColor3 = Theme.Accent
                        }):Play()
                        TweenService:Create(ToggleDot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = UDim2.new(1, -20, 0.5, -9)
                        }):Play()
                    else
                        TweenService:Create(ToggleBg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                        }):Play()
                        TweenService:Create(ToggleDot, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = UDim2.new(0, 2, 0.5, -9)
                        }):Play()
                    end
                    if callback then callback(toggled) end
                end)
                
                return Frame
            end
            
            -- Create Slider mit Glass und Animation
            function Section:CreateSlider(name, min, max, default, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 50)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BackgroundTransparency = 0.5
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -24, 0, 18)
                Label.Position = UDim2.new(0, 12, 0, 4)
                Label.BackgroundTransparency = 1
                Label.Text = name .. ": " .. tostring(default)
                Label.TextColor3 = Theme.Text
                Label.TextSize = 12
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame
                
                local SliderBg = Instance.new("Frame")
                SliderBg.Size = UDim2.new(1, -24, 0, 4)
                SliderBg.Position = UDim2.new(0, 12, 0, 32)
                SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                SliderBg.BackgroundTransparency = 0.5
                SliderBg.BorderSizePixel = 0
                SliderBg.Parent = Frame
                Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 2)
                
                local percent = (default - min) / (max - min)
                
                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                Fill.BackgroundColor3 = Theme.Accent
                Fill.BackgroundTransparency = 0.2
                Fill.BorderSizePixel = 0
                Fill.Parent = SliderBg
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 2)
                
                local Dot = Instance.new("Frame")
                Dot.Size = UDim2.new(0, 14, 0, 14)
                Dot.Position = UDim2.new(percent, -7, 0.5, -7)
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dot.BackgroundTransparency = 0.1
                Dot.BorderSizePixel = 0
                Dot.Parent = SliderBg
                Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
                
                local drag = false
                local function upd(input)
                    local sz = SliderBg.AbsoluteSize.X
                    if sz <= 0 then return end
                    local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / sz, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    
                    TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    TweenService:Create(Dot, TweenInfo.new(0.1), {Position = UDim2.new(pos, -7, 0.5, -7)}):Play()
                    Label.Text = name .. ": " .. tostring(val)
                    
                    if callback then callback(val) end
                end
                
                Dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
                SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; upd(i) end end)
                UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
                
                return Frame
            end
            
            -- Create Dropdown mit Glass und Animation
            function Section:CreateDropdown(name, options, callback)
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundColor3 = Theme.Second
                Frame.BackgroundTransparency = 0.5
                Frame.BorderSizePixel = 0
                Frame.Parent = TabContent
                Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
                
                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundTransparency = 1
                Btn.Text = name .. " ▼"
                Btn.TextColor3 = Theme.Text
                Btn.TextSize = 13
                Btn.Font = Enum.Font.Gotham
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                Btn.Parent = Frame
                
                local BtnPad = Instance.new("UIPadding")
                BtnPad.PaddingLeft = UDim.new(0, 12)
                BtnPad.Parent = Btn
                
                local Opts = Instance.new("Frame")
                Opts.Size = UDim2.new(1, 0, 0, 0)
                Opts.Position = UDim2.new(0, 0, 1, 2)
                Opts.BackgroundColor3 = Theme.Second
                Opts.BackgroundTransparency = 0.3
                Opts.BorderSizePixel = 0
                Opts.Visible = false
                Opts.ZIndex = 10
                Opts.ClipsDescendants = true
                Opts.Parent = Frame
                Instance.new("UICorner", Opts).CornerRadius = UDim.new(0, 6)
                
                local OptList = Instance.new("UIListLayout")
                OptList.SortOrder = Enum.SortOrder.LayoutOrder
                OptList.Parent = Opts
                
                for _, opt in ipairs(options) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 28)
                    OptBtn.BackgroundTransparency = 1
                    OptBtn.Text = opt
                    OptBtn.TextColor3 = Theme.Text
                    OptBtn.TextSize = 12
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.ZIndex = 11
                    OptBtn.Parent = Opts
                    
                    local OptPad = Instance.new("UIPadding")
                    OptPad.PaddingLeft = UDim.new(0, 12)
                    OptPad.Parent = OptBtn
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        Btn.Text = name .. ": " .. opt .. " ▼"
                        TweenService:Create(Opts, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()
                        wait(0.2)
                        Opts.Visible = false
                        if callback then callback(opt) end
                    end)
                end
                
                Btn.MouseButton1Click:Connect(function()
                    if Opts.Visible then
                        TweenService:Create(Opts, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 0)
                        }):Play()
                        wait(0.2)
                        Opts.Visible = false
                    else
                        Opts.Visible = true
                        TweenService:Create(Opts, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(1, 0, 0, #options * 28)
                        }):Play()
                    end
                end)
                
                return Frame
            end
            
            -- Create Label
            function Section:CreateLabel(text)
                local Lbl = Instance.new("TextLabel")
                Lbl.Size = UDim2.new(1, 0, 0, 20)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = Theme.SubText
                Lbl.TextTransparency = 0.3
                Lbl.TextSize = 11
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = TabContent
                
                local LblPad = Instance.new("UIPadding")
                LblPad.PaddingLeft = UDim.new(0, 12)
                LblPad.Parent = Lbl
                
                return Lbl
            end
            
            return Section
        end
        
        return Window
    end
    
    return Window
end

return CrystalUI
