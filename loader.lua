-- Pistol Arena v2.1 | plalettescripts
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local CoreGui=game:GetService("CoreGui")
local TweenService=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera
local Mouse=LocalPlayer:GetMouse()
local PASSWORD="plalette1"
local Authorized=false
local Config={Aimbot=false,AimFOV=150,Triggerbot=false,HitboxExpander=false,HitboxSize=3,ESP=false,Tracers=false,Radar=false,SpeedHack=false,SpeedValue=24,Fly=false,FlySpeed=30,Fullbright=false}
local ESPDrawings={}
local Connections={}

local function ClearESP()
    for _,d in pairs(ESPDrawings)do pcall(function()d:Remove()end)end
    ESPDrawings={}
end
local function AddESP(d)
    if#ESPDrawings>=80 then table.remove(ESPDrawings,1):Remove()end
    table.insert(ESPDrawings,d)
    return d
end

-- Password
local PassGui=Instance.new("ScreenGui")PassGui.Name="P"PassGui.Parent=CoreGui PassGui.ResetOnSpawn=false
local PF=Instance.new("Frame")PF.Size=UDim2.new(0,240,0,140)PF.Position=UDim2.new(0.5,-120,0.5,-70)PF.BackgroundColor3=Color3.fromRGB(18,18,26)PF.BackgroundTransparency=0.08 PF.BorderSizePixel=0 PF.Active=true PF.Draggable=true PF.Parent=PassGui
Instance.new("UICorner",PF).CornerRadius=UDim.new(0,14)

local PGL=Instance.new("Frame")PGL.Size=UDim2.new(1,3,1,3)PGL.Position=UDim2.new(0,-1.5,0,-1.5)PGL.BackgroundColor3=Color3.fromRGB(255,60,160)PGL.BackgroundTransparency=0.5 PGL.BorderSizePixel=0 PGL.Parent=PF
Instance.new("UICorner",PGL).CornerRadius=UDim.new(0,14)

task.spawn(function()local a=0 while PassGui and PassGui.Parent and not Authorized do a=(a+0.03)%(math.pi*2)pcall(function()PGL.BackgroundTransparency=0.55-math.sin(a)*0.3 end)task.wait(0.04)end end)

local PT=Instance.new("TextLabel")PT.Size=UDim2.new(1,0,0,20)PT.Position=UDim2.new(0,0,0,12)PT.BackgroundTransparency=1 PT.TextColor3=Color3.fromRGB(255,160,200)PT.Text="🔐 Pistol Arena Ultimate"PT.Font=Enum.Font.SourceSansBold PT.TextSize=15 PT.Parent=PF
local PS=Instance.new("TextLabel")PS.Size=UDim2.new(1,0,0,14)PS.Position=UDim2.new(0,0,0,34)PS.BackgroundTransparency=1 PS.TextColor3=Color3.fromRGB(160,120,150)PS.Text="plalettescripts"PS.Font=Enum.Font.SourceSans PS.TextSize=11 PS.Parent=PF

local PI=Instance.new("TextBox")PI.Size=UDim2.new(1,-30,0,28)PI.Position=UDim2.new(0,15,0,58)PI.BackgroundColor3=Color3.fromRGB(28,28,38)PI.BackgroundTransparency=0.15 PI.TextColor3=Color3.fromRGB(255,200,230)PI.PlaceholderText="Passwort..."PI.PlaceholderColor3=Color3.fromRGB(120,90,110)PI.Text=""PI.Font=Enum.Font.SourceSansSemibold PI.TextSize=14 PI.Parent=PF
Instance.new("UICorner",PI).CornerRadius=UDim.new(0,10)

local PB=Instance.new("TextButton")PB.Size=UDim2.new(1,-30,0,26)PB.Position=UDim2.new(0,15,0,95)PB.BackgroundColor3=Color3.fromRGB(255,50,150)PB.BackgroundTransparency=0.08 PB.TextColor3=Color3.fromRGB(255,255,255)PB.Text="Freischalten"PB.Font=Enum.Font.SourceSansBold PB.TextSize=13 PB.Parent=PF
Instance.new("UICorner",PB).CornerRadius=UDim.new(0,10)

local function Try()
    if PI.Text==PASSWORD then Authorized=true PassGui:Destroy()LoadMain()else PI.Text=""PI.PlaceholderText="Falsch!"PI.PlaceholderColor3=Color3.fromRGB(255,80,80)task.wait(0.6)PI.PlaceholderText="Passwort..."PI.PlaceholderColor3=Color3.fromRGB(120,90,110)end
end
PB.MouseButton1Click:Connect(Try)PI.FocusLost:Connect(function(ep)if ep then Try()end end)

function LoadMain()
    local GUI=Instance.new("ScreenGui")GUI.Name="M"GUI.Parent=CoreGui GUI.ResetOnSpawn=false
    local Main=Instance.new("Frame")Main.Size=UDim2.new(0,200,0,290)Main.Position=UDim2.new(0.01,0,0.12,0)Main.BackgroundColor3=Color3.fromRGB(16,16,24)Main.BackgroundTransparency=0.1 Main.BorderSizePixel=0 Main.Active=true Main.Draggable=true Main.Parent=GUI
    Instance.new("UICorner",Main).CornerRadius=UDim.new(0,14)
    
    local Glow=Instance.new("Frame")Glow.Size=UDim2.new(1,2.5,1,2.5)Glow.Position=UDim2.new(0,-1.25,0,-1.25)Glow.BackgroundColor3=Color3.fromRGB(255,70,170)Glow.BackgroundTransparency=0.45 Glow.BorderSizePixel=0 Glow.Parent=Main
    Instance.new("UICorner",Glow).CornerRadius=UDim.new(0,14)
    task.spawn(function()local a=0 while GUI and GUI.Parent do a=(a+0.025)%(math.pi*2)pcall(function()Glow.BackgroundTransparency=0.5-math.sin(a)*0.28 end)task.wait(0.05)end end)
    
    local Mini=Instance.new("Frame")Mini.Size=UDim2.new(0,150,0,26)Mini.Position=UDim2.new(0.01,0,0.12,0)Mini.BackgroundColor3=Color3.fromRGB(16,16,24)Mini.BackgroundTransparency=0.1 Mini.BorderSizePixel=0 Mini.Visible=false Mini.Active=true Mini.Draggable=true Mini.Parent=GUI
    Instance.new("UICorner",Mini).CornerRadius=UDim.new(0,10)
    local MT=Instance.new("TextLabel")MT.Size=UDim2.new(1,0,1,0)MT.BackgroundTransparency=1 MT.TextColor3=Color3.fromRGB(255,160,200)MT.Text="🔫 v2.1 | plalettescripts"MT.Font=Enum.Font.SourceSansBold MT.TextSize=11 MT.Parent=Mini
    
    UserInputService.InputBegan:Connect(function(input,processed)if processed then return end if input.KeyCode==Enum.KeyCode.LeftControl or input.KeyCode==Enum.KeyCode.RightControl then Main.Visible=not Main.Visible Mini.Visible=not Mini.Visible end end)
    
    local Header=Instance.new("Frame")Header.Size=UDim2.new(1,0,0,36)Header.BackgroundColor3=Color3.fromRGB(20,20,30)Header.BackgroundTransparency=0.05 Header.BorderSizePixel=0 Header.Parent=Main
    Instance.new("UICorner",Header).CornerRadius=UDim.new(0,14)
    local HT=Instance.new("TextLabel")HT.Size=UDim2.new(0.6,0,0.5,0)HT.Position=UDim2.new(0.05,0,0,3)HT.BackgroundTransparency=1 HT.TextColor3=Color3.fromRGB(255,170,210)HT.Text="Pistol Arena"HT.Font=Enum.Font.SourceSansBold HT.TextSize=14 HT.TextXAlignment=Enum.TextXAlignment.Left HT.Parent=Header
    local HS=Instance.new("TextLabel")HS.Size=UDim2.new(0.6,0,0.4,0)HS.Position=UDim2.new(0.05,0,0.55,0)HS.BackgroundTransparency=1 HS.TextColor3=Color3.fromRGB(180,130,160)HS.Text="v2.1 · plalettescripts"HS.Font=Enum.Font.SourceSans HS.TextSize=9 HS.TextXAlignment=Enum.TextXAlignment.Left HS.Parent=Header
    local CB=Instance.new("TextButton")CB.Size=UDim2.new(0,20,0,18)CB.Position=UDim2.new(1,-24,0,9)CB.BackgroundColor3=Color3.fromRGB(200,30,60)CB.BackgroundTransparency=0.15 CB.TextColor3=Color3.fromRGB(255,255,255)CB.Text="X"CB.Font=Enum.Font.SourceSansBold CB.TextSize=11 CB.Parent=Header
    Instance.new("UICorner",CB).CornerRadius=UDim.new(0,5)CB.MouseButton1Click:Connect(function()ClearESP()for _,c in pairs(Connections)do pcall(function()c:Disconnect()end)end GUI:Destroy()end)
    
    local Scroll=Instance.new("ScrollingFrame")Scroll.Size=UDim2.new(1,-8,1,-42)Scroll.Position=UDim2.new(0,4,0,38)Scroll.BackgroundColor3=Color3.fromRGB(18,18,26)Scroll.BackgroundTransparency=0.15 Scroll.BorderSizePixel=0 Scroll.ScrollBarThickness=2 Scroll.ScrollBarImageColor3=Color3.fromRGB(255,80,160)Scroll.CanvasSize=UDim2.new(0,0,0,550)Scroll.Parent=Main
    local SL=Instance.new("UIListLayout")SL.Padding=UDim.new(0,4)SL.FillDirection=Enum.FillDirection.Vertical SL.SortOrder=Enum.SortOrder.LayoutOrder SL.Parent=Scroll
    
    local function Div(t)local f=Instance.new("Frame")f.Size=UDim2.new(1,-2,0,16)f.BackgroundTransparency=1 f.Parent=Scroll local l=Instance.new("TextLabel")l.Size=UDim2.new(1,0,1,0)l.Position=UDim2.new(0,2,0,0)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(255,130,180)l.Text=t l.Font=Enum.Font.SourceSansBold l.TextSize=10 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f end
    
    local function Tog(name,key)
        local f=Instance.new("Frame")f.Size=UDim2.new(1,-2,0,28)f.BackgroundColor3=Color3.fromRGB(26,26,36)f.BackgroundTransparency=0.2 f.Parent=Scroll
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
        local l=Instance.new("TextLabel")l.Size=UDim2.new(0.5,0,1,0)l.Position=UDim2.new(0.05,0,0,0)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(220,210,230)l.Text=name l.Font=Enum.Font.SourceSansMedium l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        local track=Instance.new("Frame")track.Size=UDim2.new(0,38,0,20)track.Position=UDim2.new(1,-44,0,4)track.BackgroundColor3=Color3.fromRGB(45,40,50)track.BackgroundTransparency=0.3 track.BorderSizePixel=0 track.Parent=f
        Instance.new("UICorner",track).CornerRadius=UDim.new(0,10)
        local thumb=Instance.new("Frame")thumb.Size=UDim2.new(0,16,0,16)thumb.Position=UDim2.new(0,2,0,2)thumb.BackgroundColor3=Color3.fromRGB(200,180,210)thumb.BorderSizePixel=0 thumb.Parent=track
        Instance.new("UICorner",thumb).CornerRadius=UDim.new(0,8)
        local btn=Instance.new("TextButton")btn.Size=UDim2.new(1,0,1,0)btn.BackgroundTransparency=1 btn.Text=""btn.Parent=track
        local enabled=false
        btn.MouseButton1Click:Connect(function()
            enabled=not enabled Config[key]=enabled
            if enabled then
                TweenService:Create(track,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{BackgroundColor3=Color3.fromRGB(255,60,160),BackgroundTransparency=0.15}):Play()
                TweenService:Create(thumb,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{Position=UDim2.new(1,-18,0,2),BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
            else
                TweenService:Create(track,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{BackgroundColor3=Color3.fromRGB(45,40,50),BackgroundTransparency=0.3}):Play()
                TweenService:Create(thumb,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{Position=UDim2.new(0,2,0,2),BackgroundColor3=Color3.fromRGB(200,180,210)}):Play()
            end
        end)
    end
    
    local function Sli(name,key,min,max,def)
        Config[key]=def
        local f=Instance.new("Frame")f.Size=UDim2.new(1,-2,0,42)f.BackgroundColor3=Color3.fromRGB(26,26,36)f.BackgroundTransparency=0.2 f.Parent=Scroll
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
        local l=Instance.new("TextLabel")l.Size=UDim2.new(0.5,0,0,18)l.Position=UDim2.new(0.05,0,0,3)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(220,210,230)l.Text=name l.Font=Enum.Font.SourceSansMedium l.TextSize=12 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
        local v=Instance.new("TextLabel")v.Size=UDim2.new(0,40,0,18)v.Position=UDim2.new(1,-48,0,3)v.BackgroundTransparency=1 v.TextColor3=Color3.fromRGB(255,180,210)v.Text=tostring(def)v.Font=Enum.Font.SourceSansBold v.TextSize=11 v.TextXAlignment=Enum.TextXAlignment.Right v.Parent=f
        local inp=Instance.new("TextBox")inp.Size=UDim2.new(0.35,0,0,18)inp.Position=UDim2.new(0.3,0,0,21)inp.BackgroundColor3=Color3.fromRGB(35,30,45)inp.BackgroundTransparency=0.25 inp.TextColor3=Color3.fromRGB(255,200,230)inp.Text=tostring(def)inp.Font=Enum.Font.SourceSans inp.TextSize=10 inp.Parent=f
        Instance.new("UICorner",inp).CornerRadius=UDim.new(0,6)
        inp.FocusLost:Connect(function()local val=tonumber(inp.Text)if val and val>=min and val<=max then Config[key]=val v.Text=tostring(val)else inp.Text=tostring(Config[key])end end)
    end
    
    Div("🎯 Combat")
    Tog("Aimbot (Right Click)","Aimbot")
    Sli("Aim FOV","AimFOV",50,300,150)
    Tog("Triggerbot","Triggerbot")
    Tog("Hitbox Expander","HitboxExpander")
    Sli("Hitbox Size","HitboxSize",1,6,3)
    
    Div("👁 ESP")
    Tog("Player ESP","ESP")
    Tog("Tracers","Tracers")
    Tog("Radar","Radar")
    
    Div("🏃 Movement (SAFE)")
    Tog("Speed Hack","SpeedHack")
    Sli("Walk Speed","SpeedValue",16,30,24)
    Tog("Fly","Fly")
    Sli("Fly Speed","FlySpeed",15,40,30)
    
    Div("🌍 World")
    Tog("Fullbright","Fullbright")
    
    -- Footer
    local Foot=Instance.new("TextLabel")Foot.Size=UDim2.new(1,-4,0,14)Foot.BackgroundTransparency=1 Foot.TextColor3=Color3.fromRGB(160,120,150)Foot.Text="v2.1 | plalettescripts"Foot.Font=Enum.Font.SourceSans Foot.TextSize=9 Foot.Parent=Scroll
    
    -- ==================== FEATURES ====================
    
    -- Aimbot
    UserInputService.InputBegan:Connect(function(input,processed)if processed then return end if input.UserInputType==Enum.UserInputType.MouseButton2 and Config.Aimbot then
        Connections.Aimbot=RunService.RenderStepped:Connect(function()local cl,tr=math.huge,nil for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head")then local pos,on=Camera:WorldToViewportPoint(p.Character.Head.Position)local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude if on and d<Config.AimFOV and d<cl then cl=d tr=p end end end if tr and tr.Character and tr.Character:FindFirstChild("Head")then Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,tr.Character.Head.Position),0.35)end end)
    end end)
    UserInputService.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton2 then if Connections.Aimbot then Connections.Aimbot:Disconnect()Connections.Aimbot=nil end end end)
    
    -- Triggerbot
    task.spawn(function()while task.wait(0.06)do if Config.Triggerbot and LocalPlayer.Character then pcall(function()local tool=LocalPlayer.Character:FindFirstChildOfClass("Tool")if tool then local ray=Ray.new(Camera.CFrame.Position,Camera.CFrame.LookVector*300)local hit=Workspace:FindPartOnRay(ray,LocalPlayer.Character)if hit and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")and hit.Parent~=LocalPlayer.Character then if tool:FindFirstChild("Shoot")then tool.Shoot:FireServer(hit.Position)end if tool:FindFirstChild("Fire")then tool:FireServer(hit.Position)end end end end)end end end)
    
    -- Hitbox Expander
    task.spawn(function()while task.wait(0.3)do if Config.HitboxExpander then local s=Config.HitboxSize for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then p.Character.HumanoidRootPart.Size=Vector3.new(s,s,s)p.Character.HumanoidRootPart.Transparency=0.3 end end end end end)
    
    -- ESP
    task.spawn(function()while task.wait(0.06)do ClearESP()
        if Config.ESP then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character then local head=p.Character:FindFirstChild("Head")local hrp=p.Character:FindFirstChild("HumanoidRootPart")if head and hrp then local hPos,on=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,0.5,0))local fPos=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))if on then local h=math.abs(hPos.Y-fPos.Y)local w=h/2 local box=AddESP(Drawing.new("Square"))box.Color=Color3.fromRGB(255,80,180)box.Thickness=1 box.Size=Vector2.new(w,h)box.Position=Vector2.new(hPos.X-w/2,hPos.Y)box.Filled=false box.Visible=true local nm=AddESP(Drawing.new("Text"))nm.Text=p.Name nm.Color=Color3.fromRGB(255,200,230)nm.Size=11 nm.Position=Vector2.new(hPos.X,hPos.Y-15)nm.Center=true nm.Visible=true end end end end end
        if Config.Tracers then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart")then local pos,on=Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)if on then local l=AddESP(Drawing.new("Line"))l.Color=Color3.fromRGB(255,120,200)l.Thickness=0.5 l.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)l.To=Vector2.new(pos.X,pos.Y)l.Visible=true end end end end
        if Config.Radar then local rs=55 local rx=Camera.ViewportSize.X-rs-6 local ry=Camera.ViewportSize.Y-rs-6 local bg=AddESP(Drawing.new("Square"))bg.Color=Color3.fromRGB(0,0,0)bg.Size=Vector2.new(rs,rs)bg.Position=Vector2.new(rx,ry)bg.Filled=true bg.Visible=true if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then local my=LocalPlayer.Character.HumanoidRootPart for _,pl in ipairs(Players:GetPlayers())do if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")then local tp=pl.Character.HumanoidRootPart local off=tp.Position-my.Position local rd=math.clamp(off.Magnitude/3,0,rs/2-2)local a=math.atan2(off.Z,off.X)local d=AddESP(Drawing.new("Circle"))d.Color=pl==LocalPlayer and Color3.fromRGB(0,255,0)or Color3.fromRGB(255,80,180)d.Radius=2 d.Position=Vector2.new(rx+rs/2+math.cos(a)*rd,ry+rs/2+math.sin(a)*rd)d.Filled=true d.Visible=true end end end end end
    end end)
    
    -- Speed Hack
    RunService.Stepped:Connect(function()if Config.SpeedHack and LocalPlayer.Character then local h=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if h then h.WalkSpeed=math.min(Config.SpeedValue,30)end end end)
    
    -- Fly
    task.spawn(function()while task.wait()do if Config.Fly and LocalPlayer.Character then local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then local g=hrp:FindFirstChild("FG")or Instance.new("BodyGyro",hrp)local v=hrp:FindFirstChild("FV")or Instance.new("BodyVelocity",hrp)g.Name="FG"g.MaxTorque=Vector3.new(9e9,9e9,9e9)g.CFrame=Camera.CFrame v.Name="FV"v.MaxForce=Vector3.new(9e9,9e9,9e9)local s=math.min(Config.FlySpeed or 30,40)local m=Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W)then m+=Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S)then m-=Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A)then m-=Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D)then m+=Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.Space)then m+=Vector3.new(0,1,0)end if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)then m-=Vector3.new(0,1,0)end v.Velocity=m*s end end end end)
    
    -- Fullbright
    task.spawn(function()while task.wait(2)do if Config.Fullbright then Lighting.Brightness=2 Lighting.ClockTime=14 end end end)
    
    print("🔫 Pistol Arena v2.1 | plalettescripts")
end
