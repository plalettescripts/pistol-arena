-- Pistol Arena Ultimate Script v1.0 | plalettescripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Password System
local PASSWORD = "plalette1"
local Authorized = false

-- Config
local Config = {
    Aimbot = false,
    AimFOV = 150,
    AimSmooth = 0.4,
    Triggerbot = false,
    HitboxExpander = false,
    HitboxSize = 3,
    ESP = false,
    Tracers = false,
    Radar = false,
    SpeedHack = false,
    SpeedValue = 40,
    Fly = false,
    FlySpeed = 60,
    Fullbright = false
}

local ESPDrawings = {}
local Connections = {}
local TweenObjects = {}

local function ClearESP()
    for _, d in pairs(ESPDrawings) do pcall(function() d:Remove() end) end
    ESPDrawings = {}
end

local function AddESP(d)
    if #ESPDrawings >= 100 then table.remove(ESPDrawings, 1):Remove() end
    table.insert(ESPDrawings, d)
    return d
end

-- Password GUI
local PassGui = Instance.new("ScreenGui")
PassGui.Name = "PistolArena_Pass"
PassGui.Parent = CoreGui
PassGui.ResetOnSpawn = false

local PassFrame = Instance.new("Frame")
PassFrame.Size = UDim2.new(0, 240, 0, 150)
PassFrame.Position = UDim2.new(0.5, -120, 0.5, -75)
PassFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
PassFrame.BackgroundTransparency = 0.05
PassFrame.BorderSizePixel = 0
PassFrame.Active = true
PassFrame.Draggable = true
PassFrame.Parent = PassGui
Instance.new("UICorner", PassFrame).CornerRadius = UDim.new(0, 12)

-- Pink border (thin, glowing)
local PassBorder = Instance.new("Frame")
PassBorder.Size = UDim2.new(1, 2, 1, 2)
PassBorder.Position = UDim2.new(0, -1, 0, -1)
PassBorder.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
PassBorder.BackgroundTransparency = 0.3
PassBorder.BorderSizePixel = 0
PassBorder.Parent = PassFrame
Instance.new("UICorner", PassBorder).CornerRadius = UDim.new(0, 12)

-- Glow animation for border
task.spawn(function()
    local glow = 0
    while PassGui and PassGui.Parent and not Authorized do
        glow = (glow + 0.04) % (math.pi * 2)
        local alpha = 0.3 + math.sin(glow) * 0.2
        pcall(function() PassBorder.BackgroundTransparency = 1 - alpha end)
        task.wait(0.03)
    end
end)

local PassTitle = Instance.new("TextLabel")
PassTitle.Size = UDim2.new(1, -20, 0, 30)
PassTitle.Position = UDim2.new(0, 10, 0, 15)
PassTitle.BackgroundTransparency = 1
PassTitle.TextColor3 = Color3.fromRGB(255, 150, 200)
PassTitle.Text = "🔐 Pistol Arena Ultimate"
PassTitle.Font = Enum.Font.SourceSansBold
PassTitle.TextSize = 16
PassTitle.Parent = PassFrame

local PassSub = Instance.new("TextLabel")
PassSub.Size = UDim2.new(1, -20, 0, 16)
PassSub.Position = UDim2.new(0, 10, 0, 45)
PassSub.BackgroundTransparency = 1
PassSub.TextColor3 = Color3.fromRGB(180, 120, 160)
PassSub.Text = "plalettescripts"
PassSub.Font = Enum.Font.SourceSans
PassSub.TextSize = 11
PassSub.Parent = PassFrame

local PassInput = Instance.new("TextBox")
PassInput.Size = UDim2.new(1, -30, 0, 30)
PassInput.Position = UDim2.new(0, 15, 0, 70)
PassInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
PassInput.BackgroundTransparency = 0.2
PassInput.TextColor3 = Color3.fromRGB(255, 200, 220)
PassInput.PlaceholderText = "Passwort eingeben..."
PassInput.PlaceholderColor3 = Color3.fromRGB(150, 100, 130)
PassInput.Text = ""
PassInput.Font = Enum.Font.SourceSans
PassInput.TextSize = 14
PassInput.Parent = PassFrame
Instance.new("UICorner", PassInput).CornerRadius = UDim.new(0, 8)

local PassBtn = Instance.new("TextButton")
PassBtn.Size = UDim2.new(1, -30, 0, 28)
PassBtn.Position = UDim2.new(0, 15, 0, 108)
PassBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
PassBtn.BackgroundTransparency = 0.1
PassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PassBtn.Text = "Freischalten"
PassBtn.Font = Enum.Font.SourceSansBold
PassBtn.TextSize = 13
PassBtn.Parent = PassFrame
Instance.new("UICorner", PassBtn).CornerRadius = UDim.new(0, 8)

-- Button hover animation
PassBtn.MouseEnter:Connect(function()
    TweenService:Create(PassBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
PassBtn.MouseLeave:Connect(function()
    TweenService:Create(PassBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
end)

local PassError = Instance.new("TextLabel")
PassError.Size = UDim2.new(1, -20, 0, 14)
PassError.Position = UDim2.new(0, 10, 0, 138)
PassError.BackgroundTransparency = 1
PassError.TextColor3 = Color3.fromRGB(255, 100, 100)
PassError.Text = ""
PassError.Font = Enum.Font.SourceSans
PassError.TextSize = 10
PassError.Visible = false
PassError.Parent = PassFrame

PassBtn.MouseButton1Click:Connect(function()
    if PassInput.Text == PASSWORD then
        Authorized = true
        PassGui:Destroy()
        LoadMainGUI()
    else
        PassError.Text = "❌ Falsches Passwort!"
        PassError.Visible = true
        PassInput.Text = ""
        -- Shake animation
        local origPos = PassFrame.Position
        for i = 1, 3 do
            PassFrame.Position = origPos + UDim2.new(0, 5, 0, 0)
            task.wait(0.03)
            PassFrame.Position = origPos + UDim2.new(0, -5, 0, 0)
            task.wait(0.03)
        end
        PassFrame.Position = origPos
    end
end)

PassInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        if PassInput.Text == PASSWORD then
            Authorized = true
            PassGui:Destroy()
            LoadMainGUI()
        else
            PassError.Text = "❌ Falsches Passwort!"
            PassError.Visible = true
            PassInput.Text = ""
        end
    end
end)

-- Main GUI Loader
function LoadMainGUI()
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "PistolArena_Main"
    GUI.Parent = CoreGui
    GUI.ResetOnSpawn = false

    -- Main Frame (translucent dark)
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 200, 0, 300)
    Main.Position = UDim2.new(0.01, 0, 0.15, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = GUI
    
    -- Entrance animation
    Main.Position = UDim2.new(-0.3, 0, 0.15, 0)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    
    local slideIn = TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.01, 0, 0.15, 0)})
    slideIn:Play()

    -- Thin pink glowing border
    local Border = Instance.new("Frame")
    Border.Size = UDim2.new(1, 2, 1, 2)
    Border.Position = UDim2.new(0, -1, 0, -1)
    Border.BackgroundColor3 = Color3.fromRGB(255, 60, 160)
    Border.BackgroundTransparency = 0.35
    Border.BorderSizePixel = 0
    Border.Parent = Main
    Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)

    task.spawn(function()
        local glow = 0
        while GUI and GUI.Parent do
            glow = (glow + 0.03) % (math.pi * 2)
            local alpha = 0.35 + math.sin(glow) * 0.25
            pcall(function() Border.BackgroundTransparency = 1 - alpha end)
            task.wait(0.04)
        end
    end)

    -- Minimized
    local Mini = Instance.new("Frame")
    Mini.Size = UDim2.new(0, 160, 0, 30)
    Mini.Position = UDim2.new(0.01, 0, 0.15, 0)
    Mini.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    Mini.BackgroundTransparency = 0.1
    Mini.BorderSizePixel = 0
    Mini.Visible = false
    Mini.Active = true
    Mini.Draggable = true
    Mini.Parent = GUI
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 8)

    local MiniBorder = Instance.new("Frame")
    MiniBorder.Size = UDim2.new(1, 2, 1, 2)
    MiniBorder.Position = UDim2.new(0, -1, 0, -1)
    MiniBorder.BackgroundColor3 = Color3.fromRGB(255, 60, 160)
    MiniBorder.BackgroundTransparency = 0.5
    MiniBorder.BorderSizePixel = 0
    MiniBorder.Parent = Mini
    Instance.new("UICorner", MiniBorder).CornerRadius = UDim.new(0, 8)

    local MiniText = Instance.new("TextLabel")
    MiniText.Size = UDim2.new(1, 0, 1, 0)
    MiniText.BackgroundTransparency = 1
    MiniText.TextColor3 = Color3.fromRGB(255, 150, 200)
    MiniText.Text = "🔫 Pistol Arena | plalettescripts"
    MiniText.Font = Enum.Font.SourceSansBold
    MiniText.TextSize = 11
    MiniText.Parent = Mini

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            Main.Visible = not Main.Visible
            Mini.Visible = not Mini.Visible
        end
    end)

    -- Title
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 34)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TitleBar.BackgroundTransparency = 0.05
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.6, 0, 0.5, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 2)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 150, 200)
    Title.Text = "🔫 Pistol Arena"
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(0.6, 0, 0.4, 0)
    Sub.Position = UDim2.new(0.05, 0, 0.55, 0)
    Sub.BackgroundTransparency = 1
    Sub.TextColor3 = Color3.fromRGB(200, 130, 170)
    Sub.Text = "plalettescripts | v1.0"
    Sub.Font = Enum.Font.SourceSans
    Sub.TextSize = 9
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 20, 0, 18)
    CloseBtn.Position = UDim2.new(1, -24, 0, 8)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 60)
    CloseBtn.BackgroundTransparency = 0.1
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Text = "X"
    CloseBtn.Font = Enum.Font.SourceSansBold
    CloseBtn.TextSize = 11
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        ClearESP()
        for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
        GUI:Destroy()
    end)

    -- Scroll
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -6, 1, -38)
    Scroll.Position = UDim2.new(0, 3, 0, 36)
    Scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Scroll.BackgroundTransparency = 0.15
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 180)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 650)
    Scroll.Parent = Main

    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 3)
    List.FillDirection = Enum.FillDirection.Vertical
    List.SortOrder = Enum.SortOrder.LayoutOrder
    List.Parent = Scroll

    local function Div(t)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -2, 0, 20)
        f.BackgroundColor3 = Color3.fromRGB(35, 20, 40)
        f.BackgroundTransparency = 0.2
        f.Parent = Scroll
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(255, 150, 200)
        l.Text = "▸ " .. t
        l.Font = Enum.Font.SourceSansBold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
    end

    local function Tog(name, key)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -2, 0, 28)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        f.BackgroundTransparency = 0.2
        f.Parent = Scroll
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.52, 0, 1, 0)
        l.Position = UDim2.new(0.03, 0, 0, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(220, 210, 230)
        l.Text = name .. ": OFF"
        l.Font = Enum.Font.SourceSansSemibold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 30, 0, 16)
        b.Position = UDim2.new(0.88, -30, 0, 6)
        b.BackgroundColor3 = Color3.fromRGB(50, 30, 55)
        b.BackgroundTransparency = 0.2
        b.Text = ""
        b.Parent = f
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local on = false
        b.MouseButton1Click:Connect(function()
            on = not on
            Config[key] = on
            l.Text = name .. ": " .. (on and "ON" or "OFF")
            if on then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 160), BackgroundTransparency = 0.1}):Play()
            else
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 30, 55), BackgroundTransparency = 0.2}):Play()
            end
        end)
        b.MouseEnter:Connect(function()
            if not on then
                TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play()
            end
        end)
        b.MouseLeave:Connect(function()
            if not on then
                TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
            end
        end)
    end

    local function Sli(name, key, min, max, def)
        Config[key] = def
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -2, 0, 42)
        f.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        f.BackgroundTransparency = 0.2
        f.Parent = Scroll
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 16)
        l.Position = UDim2.new(0.03, 0, 0, 3)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(220, 210, 230)
        l.Text = name .. ": " .. def
        l.Font = Enum.Font.SourceSans
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        local inp = Instance.new("TextBox")
        inp.Size = UDim2.new(0.28, 0, 0, 18)
        inp.Position = UDim2.new(0.35, 0, 0, 22)
        inp.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
        inp.BackgroundTransparency = 0.2
        inp.TextColor3 = Color3.fromRGB(255, 200, 230)
        inp.Text = tostring(def)
        inp.Font = Enum.Font.SourceSans
        inp.TextSize = 10
        inp.Parent = f
        Instance.new("UICorner", inp).CornerRadius = UDim.new(0, 4)
        inp.FocusLost:Connect(function()
            local v = tonumber(inp.Text)
            if v and v >= min and v <= max then
                Config[key] = v
                l.Text = name .. ": " .. v
            else
                inp.Text = tostring(Config[key])
            end
        end)
    end

    -- Build Menu
    Div("🎯 Combat")
    Tog("Aimbot (Right Click)", "Aimbot")
    Sli("Aim FOV", "AimFOV", 50, 400, 150)
    Tog("Triggerbot", "Triggerbot")
    Tog("Hitbox Expander", "HitboxExpander")
    Sli("Hitbox Size", "HitboxSize", 1, 8, 3)

    Div("👁 ESP")
    Tog("Player ESP", "ESP")
    Tog("Tracers", "Tracers")
    Tog("Radar", "Radar")

    Div("🏃 Movement")
    Sli("Speed", "SpeedValue", 16, 100, 40)
    Tog("Speed Hack", "SpeedHack")
    Sli("Fly Speed", "FlySpeed", 20, 150, 60)
    Tog("Fly", "Fly")

    Div("🌍 World")
    Tog("Fullbright", "Fullbright")

    -- Footer
    local Foot = Instance.new("TextLabel")
    Foot.Size = UDim2.new(1, -4, 0, 16)
    Foot.BackgroundColor3 = Color3.fromRGB(20, 15, 28)
    Foot.BackgroundTransparency = 0.2
    Foot.TextColor3 = Color3.fromRGB(180, 140, 170)
    Foot.Text = "v1.0 | plalettescripts | 🔐"
    Foot.Font = Enum.Font.SourceSans
    Foot.TextSize = 9
    Foot.Parent = Scroll

    -- ==================== FEATURES ====================

    -- Aimbot
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 and Config.Aimbot then
            Connections.Aimbot = RunService.RenderStepped:Connect(function()
                local closest = math.huge
                local target = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                        local head = p.Character.Head
                        local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if onScreen and dist < Config.AimFOV and dist < closest then
                            closest = dist
                            target = p
                        end
                    end
                end
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), Config.AimSmooth)
                end
            end)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Connections.Aimbot then Connections.Aimbot:Disconnect() Connections.Aimbot = nil end
        end
    end)

    -- Triggerbot
    task.spawn(function()
        while task.wait(0.03) do
            if Config.Triggerbot and LocalPlayer.Character then
                pcall(function()
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 500)
                        local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                        if hit and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") and hit.Parent ~= LocalPlayer.Character then
                            if tool:FindFirstChild("Shoot") then tool.Shoot:FireServer(hit.Position) end
                            if tool:FindFirstChild("Fire") then tool:FireServer(hit.Position) end
                        end
                    end
                end)
            end
        end
    end)

    -- Hitbox Expander
    task.spawn(function()
        while task.wait(0.2) do
            if Config.HitboxExpander then
                local s = Config.HitboxSize
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(s, s, s)
                        p.Character.HumanoidRootPart.Transparency = 0.4
                    end
                end
            end
        end
    end)

    -- ESP
    task.spawn(function()
        while task.wait(0.04) do
            ClearESP()
            if Config.ESP then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local head = p.Character:FindFirstChild("Head")
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if head and hrp then
                            local hPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                            local fPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                            if onScreen then
                                local h = math.abs(hPos.Y - fPos.Y)
                                local w = h / 2
                                local box = AddESP(Drawing.new("Square"))
                                box.Color = Color3.fromRGB(255, 80, 180)
                                box.Thickness = 1.2
                                box.Size = Vector2.new(w, h)
                                box.Position = Vector2.new(hPos.X - w/2, hPos.Y)
                                box.Filled = false
                                box.Visible = true
                                local name = AddESP(Drawing.new("Text"))
                                name.Text = p.Name
                                name.Color = Color3.fromRGB(255, 200, 230)
                                name.Size = 12
                                name.Position = Vector2.new(hPos.X, hPos.Y - 16)
                                name.Center = true
                                name.Visible = true
                            end
                        end
                    end
                end
            end
            if Config.Tracers then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                        if onScreen then
                            local l = AddESP(Drawing.new("Line"))
                            l.Color = Color3.fromRGB(255, 120, 200)
                            l.Thickness = 0.5
                            l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            l.To = Vector2.new(pos.X, pos.Y)
                            l.Visible = true
                        end
                    end
                end
            end
            if Config.Radar then
                local rs = 60
                local rx = Camera.ViewportSize.X - rs - 8
                local ry = Camera.ViewportSize.Y - rs - 8
                AddESP(Drawing.new("Square")).Color = Color3.fromRGB(0,0,0)
                AddESP(Drawing.new("Square")).Size = Vector2.new(rs, rs)
                AddESP(Drawing.new("Square")).Position = Vector2.new(rx, ry)
                AddESP(Drawing.new("Square")).Filled = true
                AddESP(Drawing.new("Square")).Visible = true
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local my = LocalPlayer.Character.HumanoidRootPart
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                            local tp = pl.Character.HumanoidRootPart
                            local off = tp.Position - my.Position
                            local rd = math.clamp(off.Magnitude/3, 0, rs/2-2)
                            local a = math.atan2(off.Z, off.X)
                            local d = AddESP(Drawing.new("Circle"))
                            d.Color = pl == LocalPlayer and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,80,180)
                            d.Radius = 2
                            d.Position = Vector2.new(rx+rs/2+math.cos(a)*rd, ry+rs/2+math.sin(a)*rd)
                            d.Filled = true
                            d.Visible = true
                        end
                    end
                end
            end
        end
    end)

    -- Speed Hack
    RunService.Stepped:Connect(function()
        if Config.SpeedHack and LocalPlayer.Character then
            local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = Config.SpeedValue end
        end
    end)

    -- Fly
    task.spawn(function()
        while task.wait() do
            if Config.Fly and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local g = hrp:FindFirstChild("FG") or Instance.new("BodyGyro", hrp)
                    local v = hrp:FindFirstChild("FV") or Instance.new("BodyVelocity", hrp)
                    g.Name = "FG" g.MaxTorque = Vector3.new(9e9,9e9,9e9) g.CFrame = Camera.CFrame
                    v.Name = "FV" v.MaxForce = Vector3.new(9e9,9e9,9e9)
                    local s = Config.FlySpeed or 60
                    local m = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then m += Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then m -= Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then m -= Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then m += Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then m -= Vector3.new(0,1,0) end
                    v.Velocity = m * s
                end
            end
        end
    end)

    -- Fullbright
    task.spawn(function()
        while task.wait(1) do
            if Config.Fullbright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
            end
        end
    end)

    -- Anti-AFK
    task.spawn(function()
        while task.wait(50) do
            pcall(function()
                local VIM = game:GetService("VirtualInputManager")
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                task.wait(0.1)
                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
            end)
        end
    end)

    print("🔫 Pistol Arena Ultimate v1.0 | plalettescripts | 🔐")
end
