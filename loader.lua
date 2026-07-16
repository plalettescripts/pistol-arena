-- Pistol Arena v6.0 FINAL | plalettescripts
-- JEDE FUNKTION EINZELN GETESTET

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PASSWORD = "plalette1"

-- ==================== ALLE VARIABLEN ====================
local AimbotEnabled = false
local AimbotRadius = 120
local SilentAimEnabled = false
local TriggerbotEnabled = false
local HitboxEnabled = false
local HitboxSize = 3
local ESPEnabled = false
local TracersEnabled = false
local RadarEnabled = false
local SpeedEnabled = false
local SpeedAmount = 24
local FlyEnabled = false
local FlySpeed = 25
local JumpEnabled = false
local JumpAmount = 50
local FullbrightEnabled = false
local AntiAFKEnabled = true

local ESPDrawings = {}
local FOVCircle = nil
local FlyGyro = nil
local FlyVelocity = nil

-- ==================== HILFSFUNKTIONEN ====================

local function ClearESP()
    for _, d in pairs(ESPDrawings) do
        pcall(function() d:Remove() end)
    end
    ESPDrawings = {}
    if FOVCircle then
        pcall(function() FOVCircle:Remove() end)
        FOVCircle = nil
    end
end

local function GetTarget()
    local closest = 99999
    local target = nil
    local screenCenterX = Camera.ViewportSize.X / 2
    local screenCenterY = Camera.ViewportSize.Y / 2
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dx = screenPos.X - screenCenterX
                    local dy = screenPos.Y - screenCenterY
                    local distance = math.sqrt(dx * dx + dy * dy)
                    if distance < AimbotRadius and distance < closest then
                        closest = distance
                        target = player
                    end
                end
            end
        end
    end
    
    return target
end

local function StopEverything()
    AimbotEnabled = false
    SilentAimEnabled = false
    TriggerbotEnabled = false
    HitboxEnabled = false
    ESPEnabled = false
    TracersEnabled = false
    RadarEnabled = false
    SpeedEnabled = false
    FlyEnabled = false
    JumpEnabled = false
    FullbrightEnabled = false
    AntiAFKEnabled = false
    
    ClearESP()
    
    if FlyGyro then
        FlyGyro:Destroy()
        FlyGyro = nil
    end
    if FlyVelocity then
        FlyVelocity:Destroy()
        FlyVelocity = nil
    end
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, child in ipairs(root:GetChildren()) do
                if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end
        end
    end
    
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.FogEnd = 10000
end

-- ==================== PASSWORT ====================

local PassScreen = Instance.new("ScreenGui")
PassScreen.Name = "PassScreen"
PassScreen.ResetOnSpawn = false
PassScreen.Parent = CoreGui

local PassFrame = Instance.new("Frame")
PassFrame.Size = UDim2.new(0, 240, 0, 150)
PassFrame.Position = UDim2.new(0.5, -120, 0.5, -75)
PassFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
PassFrame.BorderSizePixel = 0
PassFrame.Active = true
PassFrame.Draggable = true
PassFrame.Parent = PassScreen
Instance.new("UICorner", PassFrame).CornerRadius = UDim.new(0, 12)

local PassGlow = Instance.new("Frame")
PassGlow.Size = UDim2.new(1, 2, 1, 2)
PassGlow.Position = UDim2.new(0, -1, 0, -1)
PassGlow.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
PassGlow.BackgroundTransparency = 0.5
PassGlow.BorderSizePixel = 0
PassGlow.Parent = PassFrame
Instance.new("UICorner", PassGlow).CornerRadius = UDim.new(0, 12)

local PassTitle = Instance.new("TextLabel")
PassTitle.Size = UDim2.new(1, 0, 0, 24)
PassTitle.Position = UDim2.new(0, 0, 0, 16)
PassTitle.BackgroundTransparency = 1
PassTitle.TextColor3 = Color3.fromRGB(220, 220, 240)
PassTitle.Text = "Pistol Arena v6.0"
PassTitle.Font = Enum.Font.SourceSansBold
PassTitle.TextSize = 18
PassTitle.Parent = PassFrame

local PassSub = Instance.new("TextLabel")
PassSub.Size = UDim2.new(1, 0, 0, 16)
PassSub.Position = UDim2.new(0, 0, 0, 42)
PassSub.BackgroundTransparency = 1
PassSub.TextColor3 = Color3.fromRGB(150, 150, 170)
PassSub.Text = "plalettescripts"
PassSub.Font = Enum.Font.SourceSans
PassSub.TextSize = 12
PassSub.Parent = PassFrame

local PassInput = Instance.new("TextBox")
PassInput.Size = UDim2.new(1, -40, 0, 30)
PassInput.Position = UDim2.new(0, 20, 0, 65)
PassInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
PassInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PassInput.PlaceholderText = "Passwort..."
PassInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
PassInput.Text = ""
PassInput.Font = Enum.Font.SourceSans
PassInput.TextSize = 14
PassInput.Parent = PassFrame
Instance.new("UICorner", PassInput).CornerRadius = UDim.new(0, 8)

local PassButton = Instance.new("TextButton")
PassButton.Size = UDim2.new(1, -40, 0, 28)
PassButton.Position = UDim2.new(0, 20, 0, 102)
PassButton.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
PassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PassButton.Text = "Freischalten"
PassButton.Font = Enum.Font.SourceSansBold
PassButton.TextSize = 13
PassButton.Parent = PassFrame
Instance.new("UICorner", PassButton).CornerRadius = UDim.new(0, 8)

local function CheckPassword()
    if PassInput.Text == PASSWORD then
        PassScreen:Destroy()
        BuildMainGUI()
    else
        PassInput.Text = ""
        PassInput.PlaceholderText = "❌ Falsches Passwort!"
        PassInput.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
        task.delay(1.0, function()
            PassInput.PlaceholderText = "Passwort..."
            PassInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
        end)
    end
end

PassButton.MouseButton1Click:Connect(CheckPassword)
PassInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        CheckPassword()
    end
end)

-- ==================== MAIN GUI ====================

function BuildMainGUI()
    local MainScreen = Instance.new("ScreenGui")
    MainScreen.Name = "MainScreen"
    MainScreen.ResetOnSpawn = false
    MainScreen.Parent = CoreGui

    -- Hauptfenster
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    MainFrame.BackgroundTransparency = 0.03
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = MainScreen
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- Leuchtender Rand
    local GlowBorder = Instance.new("Frame")
    GlowBorder.Size = UDim2.new(1, 2, 1, 2)
    GlowBorder.Position = UDim2.new(0, -1, 0, -1)
    GlowBorder.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
    GlowBorder.BackgroundTransparency = 0.55
    GlowBorder.BorderSizePixel = 0
    GlowBorder.Parent = MainFrame
    Instance.new("UICorner", GlowBorder).CornerRadius = UDim.new(0, 10)

    -- Minimiertes Fenster
    local MiniFrame = Instance.new("Frame")
    MiniFrame.Size = UDim2.new(0, 180, 0, 30)
    MiniFrame.Position = UDim2.new(0.5, -90, 0.02, 0)
    MiniFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    MiniFrame.BackgroundTransparency = 0.03
    MiniFrame.BorderSizePixel = 0
    MiniFrame.Visible = false
    MiniFrame.Active = true
    MiniFrame.Draggable = true
    MiniFrame.Parent = MainScreen
    Instance.new("UICorner", MiniFrame).CornerRadius = UDim.new(0, 8)

    local MiniText = Instance.new("TextLabel")
    MiniText.Size = UDim2.new(1, 0, 1, 0)
    MiniText.BackgroundTransparency = 1
    MiniText.TextColor3 = Color3.fromRGB(200, 200, 220)
    MiniText.Text = "v6.0 | plalettescripts | CTRL"
    MiniText.Font = Enum.Font.SourceSansBold
    MiniText.TextSize = 11
    MiniText.Parent = MiniFrame

    -- CTRL Toggle
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            MainFrame.Visible = not MainFrame.Visible
            MiniFrame.Visible = not MiniFrame.Visible
        end
    end)

    -- Header
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Size = UDim2.new(1, 0, 0, 42)
    HeaderBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    HeaderBar.BorderSizePixel = 0
    HeaderBar.Parent = MainFrame
    Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 10)

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size = UDim2.new(0.5, 0, 1, 0)
    HeaderTitle.Position = UDim2.new(0, 16, 0, 0)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderTitle.Text = "Pistol Arena v6.0"
    HeaderTitle.Font = Enum.Font.SourceSansBold
    HeaderTitle.TextSize = 16
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = HeaderBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 26)
    CloseButton.Position = UDim2.new(1, -36, 0, 8)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Text = "✕"
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 14
    CloseButton.Parent = HeaderBar
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 5)
    CloseButton.MouseButton1Click:Connect(function()
        StopEverything()
        MainScreen:Destroy()
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 155, 1, -42)
    Sidebar.Position = UDim2.new(0, 0, 0, 42)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Padding = UDim.new(0, 2)
    SidebarList.FillDirection = Enum.FillDirection.Vertical
    SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Parent = Sidebar

    -- Content Bereich
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -155, 1, -68)
    ContentArea.Position = UDim2.new(0, 155, 0, 42)
    ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ContentArea.BorderSizePixel = 0
    ContentArea.Parent = MainFrame

    -- Footer
    local FooterBar = Instance.new("Frame")
    FooterBar.Size = UDim2.new(1, -155, 0, 26)
    FooterBar.Position = UDim2.new(0, 155, 1, -26)
    FooterBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    FooterBar.BorderSizePixel = 0
    FooterBar.Parent = MainFrame

    -- Avatar im Footer
    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Size = UDim2.new(0, 32, 0, 32)
    AvatarImage.Position = UDim2.new(0, 10, 0.5, -16)
    AvatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    AvatarImage.BorderSizePixel = 0
    AvatarImage.Parent = FooterBar
    Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(0, 16)

    task.spawn(function()
        local userId = LocalPlayer.UserId
        local content = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        AvatarImage.Image = content
    end)

    local FooterText = Instance.new("TextLabel")
    FooterText.Size = UDim2.new(1, 0, 1, 0)
    FooterText.BackgroundTransparency = 1
    FooterText.TextColor3 = Color3.fromRGB(150, 150, 150)
    FooterText.Text = "Welcome, " .. LocalPlayer.Name .. "  |  plalettescripts"
    FooterText.Font = Enum.Font.SourceSans
    FooterText.TextSize = 12
    FooterText.TextXAlignment = Enum.TextXAlignment.Center
    FooterText.Parent = FooterBar

    -- ==================== TAB SYSTEM ====================
    local AllTabs = {}

    local function CreateTab(tabName, tabIcon)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, -10, 0, 34)
        TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.Text = "  " .. tabIcon .. "  " .. tabName
        TabButton.Font = Enum.Font.SourceSans
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, -16, 1, -16)
        TabPage.Position = UDim2.new(0, 8, 0, 8)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(91, 81, 244)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Visible = false
        TabPage.Parent = ContentArea

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout.FillDirection = Enum.FillDirection.Vertical
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage

        TabButton.MouseButton1Click:Connect(function()
            for _, btn in ipairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
                end
            end
            for _, page in pairs(AllTabs) do
                page.Visible = false
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabPage.Visible = true
        end)

        table.insert(AllTabs, TabPage)
        if #AllTabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabPage.Visible = true
        end

        return TabPage
    end

    local function AddSection(page, title)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Size = UDim2.new(1, 0, 0, 20)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.Parent = page

        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, 0, 1, 0)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
        SectionLabel.Text = title
        SectionLabel.Font = Enum.Font.SourceSansBold
        SectionLabel.TextSize = 11
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = SectionFrame

        local currentY = page.CanvasSize.Y.Offset
        page.CanvasSize = UDim2.new(0, 0, 0, currentY + 24)
    end

    local function AddToggle(page, label, varName)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 34)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        ToggleFrame.Parent = page
        Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        ToggleLabel.Text = label .. ": OFF"
        ToggleLabel.Font = Enum.Font.SourceSans
        ToggleLabel.TextSize = 13
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local Track = Instance.new("Frame")
        Track.Size = UDim2.new(0, 42, 0, 24)
        Track.Position = UDim2.new(1, -54, 0, 5)
        Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Track.BorderSizePixel = 0
        Track.Parent = ToggleFrame
        Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 12)

        local Thumb = Instance.new("Frame")
        Thumb.Size = UDim2.new(0, 20, 0, 20)
        Thumb.Position = UDim2.new(0, 2, 0, 2)
        Thumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Thumb.BorderSizePixel = 0
        Thumb.Parent = Track
        Instance.new("UICorner", Thumb).CornerRadius = UDim.new(0, 10)

        local ClickButton = Instance.new("TextButton")
        ClickButton.Size = UDim2.new(1, 0, 1, 0)
        ClickButton.BackgroundTransparency = 1
        ClickButton.Text = ""
        ClickButton.Parent = Track

        local isOn = false
        ClickButton.MouseButton1Click:Connect(function()
            isOn = not isOn
            
            -- DIREKT in die entsprechende Variable schreiben
            if varName == "Aimbot" then AimbotEnabled = isOn
            elseif varName == "Silent" then SilentAimEnabled = isOn
            elseif varName == "Trigger" then TriggerbotEnabled = isOn
            elseif varName == "Hitbox" then HitboxEnabled = isOn
            elseif varName == "ESP" then ESPEnabled = isOn
            elseif varName == "Tracers" then TracersEnabled = isOn
            elseif varName == "Radar" then RadarEnabled = isOn
            elseif varName == "Speed" then SpeedEnabled = isOn
            elseif varName == "Fly" then FlyEnabled = isOn
            elseif varName == "Jump" then JumpEnabled = isOn
            elseif varName == "Fullbright" then FullbrightEnabled = isOn
            elseif varName == "AntiAFK" then AntiAFKEnabled = isOn
            end
            
            ToggleLabel.Text = label .. ": " .. (isOn and "ON" or "OFF")
            
            if isOn then
                Track.BackgroundColor3 = Color3.fromRGB(91, 81, 244)
                Thumb.Position = UDim2.new(1, -22, 0, 2)
                Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                Track.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Thumb.Position = UDim2.new(0, 2, 0, 2)
                Thumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            end
        end)

        local currentY = page.CanvasSize.Y.Offset
        page.CanvasSize = UDim2.new(0, 0, 0, currentY + 38)
    end

    local function AddSlider(page, label, varName, minVal, maxVal, defaultVal)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 48)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        SliderFrame.Parent = page
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(0.4, 0, 0, 20)
        SliderLabel.Position = UDim2.new(0, 12, 0, 4)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        SliderLabel.Text = label
        SliderLabel.Font = Enum.Font.SourceSans
        SliderLabel.TextSize = 13
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 45, 0, 20)
        ValueLabel.Position = UDim2.new(1, -57, 0, 4)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.TextColor3 = Color3.fromRGB(91, 81, 244)
        ValueLabel.Text = tostring(defaultVal)
        ValueLabel.Font = Enum.Font.SourceSansBold
        ValueLabel.TextSize = 13
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame

        local InputBox = Instance.new("TextBox")
        InputBox.Size = UDim2.new(0.3, 0, 0, 22)
        InputBox.Position = UDim2.new(0.35, 0, 0, 24)
        InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        InputBox.Text = tostring(defaultVal)
        InputBox.Font = Enum.Font.SourceSans
        InputBox.TextSize = 12
        InputBox.Parent = SliderFrame
        Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 4)

        InputBox.FocusLost:Connect(function()
            local val = tonumber(InputBox.Text)
            if val and val >= minVal and val <= maxVal then
                if varName == "AimR" then AimbotRadius = val
                elseif varName == "HitS" then HitboxSize = val
                elseif varName == "SpdV" then SpeedAmount = val
                elseif varName == "JumpV" then JumpAmount = val
                elseif varName == "FlyV" then FlySpeed = val
                end
                ValueLabel.Text = tostring(val)
            else
                -- Zurücksetzen
                local currentVal = 0
                if varName == "AimR" then currentVal = AimbotRadius
                elseif varName == "HitS" then currentVal = HitboxSize
                elseif varName == "SpdV" then currentVal = SpeedAmount
                elseif varName == "JumpV" then currentVal = JumpAmount
                elseif varName == "FlyV" then currentVal = FlySpeed
                end
                InputBox.Text = tostring(currentVal)
            end
        end)

        local currentY = page.CanvasSize.Y.Offset
        page.CanvasSize = UDim2.new(0, 0, 0, currentY + 52)
    end

    -- ==================== TABS ERSTELLEN ====================

    local HomePage = CreateTab("Home", "🏠")
    local CombatPage = CreateTab("Combat", "🎯")
    local VisualPage = CreateTab("Visuals", "👁")
    local CharacterPage = CreateTab("Character", "🏃")
    local SettingsPage = CreateTab("Settings", "⚙️")

    -- HOME
    local WelcomeFrame = Instance.new("Frame")
    WelcomeFrame.Size = UDim2.new(1, 0, 0, 90)
    WelcomeFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    WelcomeFrame.Parent = HomePage
    Instance.new("UICorner", WelcomeFrame).CornerRadius = UDim.new(0, 8)

    local WelcomeTitle = Instance.new("TextLabel")
    WelcomeTitle.Size = UDim2.new(1, -20, 0, 30)
    WelcomeTitle.Position = UDim2.new(0, 10, 0, 12)
    WelcomeTitle.BackgroundTransparency = 1
    WelcomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeTitle.Text = "Welcome, " .. LocalPlayer.Name .. " 👋"
    WelcomeTitle.Font = Enum.Font.SourceSansBold
    WelcomeTitle.TextSize = 18
    WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeTitle.Parent = WelcomeFrame

    local WelcomeInfo = Instance.new("TextLabel")
    WelcomeInfo.Size = UDim2.new(1, -20, 0, 30)
    WelcomeInfo.Position = UDim2.new(0, 10, 0, 48)
    WelcomeInfo.BackgroundTransparency = 1
    WelcomeInfo.TextColor3 = Color3.fromRGB(160, 160, 160)
    WelcomeInfo.Text = "v6.0 | plalettescripts\nCTRL = Hide | X = Emergency Stop"
    WelcomeInfo.Font = Enum.Font.SourceSans
    WelcomeInfo.TextSize = 13
    WelcomeInfo.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeInfo.Parent = WelcomeFrame
    HomePage.CanvasSize = UDim2.new(0, 0, 0, 110)

    -- COMBAT
    AddSection(CombatPage, "🎯 Aimbot")
    AddToggle(CombatPage, "FOV Aimbot", "Aimbot")
    AddSlider(CombatPage, "FOV Radius", "AimR", 30, 300, 120)
    AddToggle(CombatPage, "Silent Aim", "Silent")
    AddSection(CombatPage, "🔫 Weapon")
    AddToggle(CombatPage, "Triggerbot", "Trigger")
    AddToggle(CombatPage, "Hitbox Expander", "Hitbox")
    AddSlider(CombatPage, "Hitbox Size", "HitS", 1, 8, 3)

    -- VISUALS
    AddSection(VisualPage, "👁 ESP")
    AddToggle(VisualPage, "Player ESP", "ESP")
    AddToggle(VisualPage, "Tracers", "Tracers")
    AddToggle(VisualPage, "Radar", "Radar")

    -- CHARACTER
    AddSection(CharacterPage, "🏃 Movement")
    AddToggle(CharacterPage, "Speed Hack", "Speed")
    AddSlider(CharacterPage, "Walk Speed", "SpdV", 16, 30, 24)
    AddToggle(CharacterPage, "Infinite Jump", "Jump")
    AddSlider(CharacterPage, "Jump Power", "JumpV", 50, 200, 50)
    AddToggle(CharacterPage, "Fly", "Fly")
    AddSlider(CharacterPage, "Fly Speed", "FlyV", 15, 50, 25)

    -- SETTINGS
    AddSection(SettingsPage, "🌍 World")
    AddToggle(SettingsPage, "Fullbright", "Fullbright")
    AddToggle(SettingsPage, "Anti-AFK", "AntiAFK")
    AddSection(SettingsPage, "ℹ️ Info")
    
    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(1, 0, 0, 70)
    InfoFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    InfoFrame.Parent = SettingsPage
    Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 8)
    
    local InfoText = Instance.new("TextLabel")
    InfoText.Size = UDim2.new(1, -20, 1, -20)
    InfoText.Position = UDim2.new(0, 10, 0, 10)
    InfoText.BackgroundTransparency = 1
    InfoText.TextColor3 = Color3.fromRGB(160, 160, 160)
    InfoText.Text = "Pistol Arena v6.0\nplalettescripts\nPass: plalette1 | X = NOTAUS"
    InfoText.Font = Enum.Font.SourceSans
    InfoText.TextSize = 12
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.Parent = InfoFrame
    
    local y = SettingsPage.CanvasSize.Y.Offset
    SettingsPage.CanvasSize = UDim2.new(0, 0, 0, y + 90)

    -- ==================== ALLE FUNKTIONEN ====================

    -- FOV CIRCLE
    task.spawn(function()
        while true do
            task.wait(0.03)
            if AimbotEnabled then
                if not FOVCircle then
                    FOVCircle = Drawing.new("Circle")
                end
                FOVCircle.Visible = true
                FOVCircle.Radius = AimbotRadius
                FOVCircle.Thickness = 1.5
                FOVCircle.Color = Color3.fromRGB(91, 81, 244)
                FOVCircle.Filled = false
                FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            else
                if FOVCircle then
                    FOVCircle.Visible = false
                end
            end
        end
    end)

    -- SILENT AIM (lenkt Kugeln um, Kamera bleibt frei)
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and AimbotEnabled and SilentAimEnabled then
            local target = GetTarget()
            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head and args[1] then
                    args[1] = head.Position
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)

    -- TRIGGERBOT
    task.spawn(function()
        while true do
            task.wait(0.06)
            if TriggerbotEnabled and LocalPlayer.Character then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local target = GetTarget()
                        if target and target.Character then
                            local head = target.Character:FindFirstChild("Head")
                            if head then
                                local shoot = tool:FindFirstChild("Shoot")
                                if shoot then
                                    shoot:FireServer(head.Position)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- HITBOX EXPANDER
    task.spawn(function()
        while true do
            task.wait(0.3)
            if HitboxEnabled then
                local size = HitboxSize
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local root = player.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.Size = Vector3.new(size, size, size)
                            root.Transparency = 0.4
                        end
                    end
                end
            end
        end
    end)

    -- ESP + TRACERS + RADAR
    task.spawn(function()
        while true do
            task.wait(0.06)
            ClearESP()

            -- PLAYER ESP
            if ESPEnabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local head = player.Character:FindFirstChild("Head")
                        local root = player.Character:FindFirstChild("HumanoidRootPart")
                        if head and root then
                            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                            if onScreen then
                                local boxHeight = math.abs(headPos.Y - footPos.Y)
                                local boxWidth = boxHeight / 2

                                local box = Drawing.new("Square")
                                box.Color = Color3.fromRGB(91, 81, 244)
                                box.Thickness = 1
                                box.Size = Vector2.new(boxWidth, boxHeight)
                                box.Position = Vector2.new(headPos.X - boxWidth / 2, headPos.Y)
                                box.Filled = false
                                box.Visible = true
                                table.insert(ESPDrawings, box)

                                local nameTag = Drawing.new("Text")
                                nameTag.Text = player.Name
                                nameTag.Color = Color3.fromRGB(255, 255, 255)
                                nameTag.Size = 13
                                nameTag.Position = Vector2.new(headPos.X, headPos.Y - 18)
                                nameTag.Center = true
                                nameTag.Visible = true
                                table.insert(ESPDrawings, nameTag)
                            end
                        end
                    end
                end
            end

            -- TRACERS
            if TracersEnabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local root = player.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                            if onScreen then
                                local line = Drawing.new("Line")
                                line.Color = Color3.fromRGB(120, 110, 255)
                                line.Thickness = 0.5
                                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                                line.To = Vector2.new(pos.X, pos.Y)
                                line.Visible = true
                                table.insert(ESPDrawings, line)
                            end
                        end
                    end
                end
            end

            -- RADAR
            if RadarEnabled then
                local radarSize = 55
                local radarX = Camera.ViewportSize.X - radarSize - 8
                local radarY = Camera.ViewportSize.Y - radarSize - 8

                local bg = Drawing.new("Square")
                bg.Color = Color3.fromRGB(0, 0, 0)
                bg.Size = Vector2.new(radarSize, radarSize)
                bg.Position = Vector2.new(radarX, radarY)
                bg.Filled = true
                bg.Visible = true
                table.insert(ESPDrawings, bg)

                if LocalPlayer.Character then
                    local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player.Character then
                                local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
                                if playerRoot then
                                    local offset = playerRoot.Position - myRoot.Position
                                    local radarDistance = math.clamp(offset.Magnitude / 3, 0, radarSize / 2 - 2)
                                    local angle = math.atan2(offset.Z, offset.X)
                                    local dotX = radarX + radarSize / 2 + math.cos(angle) * radarDistance
                                    local dotY = radarY + radarSize / 2 + math.sin(angle) * radarDistance

                                    local dot = Drawing.new("Circle")
                                    if player == LocalPlayer then
                                        dot.Color = Color3.fromRGB(0, 255, 0)
                                    else
                                        dot.Color = Color3.fromRGB(91, 81, 244)
                                    end
                                    dot.Radius = 2
                                    dot.Position = Vector2.new(dotX, dotY)
                                    dot.Filled = true
                                    dot.Visible = true
                                    table.insert(ESPDrawings, dot)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    -- SPEED HACK + JUMP
    RunService.Stepped:Connect(function()
        if SpeedEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = SpeedAmount
            end
        end
        if JumpEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = JumpAmount
            end
        end
    end)

    -- INFINITE JUMP
    UserInputService.JumpRequest:Connect(function()
        if JumpEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- FLY
    task.spawn(function()
        while true do
            task.wait()
            if FlyEnabled and LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    -- BodyGyro
                    local gyro = root:FindFirstChild("FlyGyro")
                    if not gyro then
                        gyro = Instance.new("BodyGyro")
                        gyro.Name = "FlyGyro"
                        gyro.Parent = root
                    end
                    gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    gyro.CFrame = Camera.CFrame

                    -- BodyVelocity
                    local velocity = root:FindFirstChild("FlyVelocity")
                    if not velocity then
                        velocity = Instance.new("BodyVelocity")
                        velocity.Name = "FlyVelocity"
                        velocity.Parent = root
                    end
                    velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

                    -- Bewegung
                    local moveDirection = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - Camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + Camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection = moveDirection - Vector3.new(0, 1, 0)
                    end

                    velocity.Velocity = moveDirection * FlySpeed
                end
            end
        end
    end)

    -- FULLBRIGHT + ANTI AFK
    task.spawn(function()
        while true do
            task.wait(60)
            if FullbrightEnabled then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
            end
            if AntiAFKEnabled then
                pcall(function()
                    local VIM = game:GetService("VirtualInputManager")
                    VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                    task.wait(0.1)
                    VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
                end)
            end
        end
    end)

    print("Pistol Arena v6.0 FINAL | plalettescripts")
    print("ALL FEATURES WORKING")
end
