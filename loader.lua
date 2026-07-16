-- Pistol Arena v2.2 MINIMAL | plalettescripts
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local CoreGui=game:GetService("CoreGui")
local Lighting=game:GetService("Lighting")
local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera

local Config={Aimbot=false,AimFOV=150,Triggerbot=false,ESP=false,SpeedHack=false,SpeedValue=24,Fly=false,FlySpeed=30}
local ESPDrawings={}
local Connections={}

local function ClearESP()for _,d in pairs(ESPDrawings)do pcall(function()d:Remove()end)end ESPDrawings={}end
local function AddESP(d)if#ESPDrawings>=80 then table.remove(ESPDrawings,1):Remove()end table.insert(ESPDrawings,d)return d end

-- GUI
local GUI=Instance.new("ScreenGui")GUI.Name="PA"GUI.Parent=CoreGui

local Main=Instance.new("Frame")Main.Size=UDim2.new(0,180,0,240)Main.Position=UDim2.new(0.01,0,0.15,0)Main.BackgroundColor3=Color3.fromRGB(18,18,26)Main.BorderSizePixel=0 Main.Active=true Main.Draggable=true Main.Parent=GUI
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,10)

local Title=Instance.new("TextLabel")Title.Size=UDim2.new(1,0,0,28)Title.BackgroundColor3=Color3.fromRGB(24,24,34)Title.TextColor3=Color3.fromRGB(255,150,200)Title.Text="🔫 Pistol Arena v2.2"Title.Font=Enum.Font.SourceSansBold Title.TextSize=13 Title.Parent=Main

local Close=Instance.new("TextButton")Close.Size=UDim2.new(0,20,0,18)Close.Position=UDim2.new(1,-24,0,5)Close.BackgroundColor3=Color3.fromRGB(200,30,60)Close.TextColor3=Color3.fromRGB(255,255,255)Close.Text="X"Close.Font=Enum.Font.SourceSansBold Close.TextSize=11 Close.Parent=Main
Close.MouseButton1Click:Connect(function()ClearESP()for _,c in pairs(Connections)do pcall(function()c:Disconnect()end)end GUI:Destroy()end)

local Scroll=Instance.new("ScrollingFrame")Scroll.Size=UDim2.new(1,-8,1,-34)Scroll.Position=UDim2.new(0,4,0,30)Scroll.BackgroundColor3=Color3.fromRGB(20,22,30)Scroll.BorderSizePixel=0 Scroll.ScrollBarThickness=2 Scroll.ScrollBarImageColor3=Color3.fromRGB(255,80,160)Scroll.CanvasSize=UDim2.new(0,0,0,480)Scroll.Parent=Main
local SL=Instance.new("UIListLayout")SL.Padding=UDim.new(0,3)SL.FillDirection=Enum.FillDirection.Vertical SL.SortOrder=Enum.SortOrder.LayoutOrder SL.Parent=Scroll

local function Tog(name,key)
    local f=Instance.new("Frame")f.Size=UDim2.new(1,-2,0,26)f.BackgroundColor3=Color3.fromRGB(26,26,36)f.Parent=Scroll
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,5)
    local l=Instance.new("TextLabel")l.Size=UDim2.new(0.5,0,1,0)l.Position=UDim2.new(0.05,0,0,0)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(220,210,230)l.Text=name..": OFF"l.Font=Enum.Font.SourceSans l.TextSize=11 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
    local b=Instance.new("TextButton")b.Size=UDim2.new(0,30,0,16)b.Position=UDim2.new(0.9,-30,0,5)b.BackgroundColor3=Color3.fromRGB(50,45,60)b.Text=""b.Parent=f
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    local on=false b.MouseButton1Click:Connect(function()on=not on Config[key]=on l.Text=name..": "..(on and"ON"or"OFF")b.BackgroundColor3=on and Color3.fromRGB(255,60,160)or Color3.fromRGB(50,45,60)end)
end

local function Sli(name,key,min,max,def)
    Config[key]=def
    local f=Instance.new("Frame")f.Size=UDim2.new(1,-2,0,38)f.BackgroundColor3=Color3.fromRGB(26,26,36)f.Parent=Scroll
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,5)
    local l=Instance.new("TextLabel")l.Size=UDim2.new(1,0,0,16)l.Position=UDim2.new(0.05,0,0,2)l.BackgroundTransparency=1 l.TextColor3=Color3.fromRGB(220,210,230)l.Text=name..": "..def l.Font=Enum.Font.SourceSans l.TextSize=10 l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=f
    local inp=Instance.new("TextBox")inp.Size=UDim2.new(0.3,0,0,18)inp.Position=UDim2.new(0.35,0,0,18)inp.BackgroundColor3=Color3.fromRGB(40,35,50)inp.TextColor3=Color3.fromRGB(255,200,230)inp.Text=tostring(def)inp.Font=Enum.Font.SourceSans inp.TextSize=10 inp.Parent=f
    Instance.new("UICorner",inp).CornerRadius=UDim.new(0,4)
    inp.FocusLost:Connect(function()local v=tonumber(inp.Text)if v and v>=min and v<=max then Config[key]=v l.Text=name..": "..v else inp.Text=tostring(Config[key])end end)
end

Tog("Aimbot (Right Click)","Aimbot")
Sli("Aim FOV","AimFOV",50,300,150)
Tog("Triggerbot","Triggerbot")
Tog("Player ESP","ESP")
Tog("Speed Hack","SpeedHack")
Sli("Walk Speed","SpeedValue",16,30,24)
Tog("Fly","Fly")
Sli("Fly Speed","FlySpeed",15,40,30)
Tog("Fullbright","Fullbright")

local Foot=Instance.new("TextLabel")Foot.Size=UDim2.new(1,-4,0,14)Foot.BackgroundTransparency=1 Foot.TextColor3=Color3.fromRGB(140,110,130)Foot.Text="v2.2 | plalettescripts"Foot.Font=Enum.Font.SourceSans Foot.TextSize=8 Foot.Parent=Scroll

-- Aimbot
UserInputService.InputBegan:Connect(function(input,processed)if processed then return end if input.UserInputType==Enum.UserInputType.MouseButton2 and Config.Aimbot then Connections.Aimbot=RunService.RenderStepped:Connect(function()local cl,tr=math.huge,nil for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head")then local pos,on=Camera:WorldToViewportPoint(p.Character.Head.Position)local d=(Vector2.new(pos.X,pos.Y)-Vector2.new(workspace.CurrentCamera.ViewportSize.X/2,workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude if on and d<Config.AimFOV and d<cl then cl=d tr=p end end end if tr and tr.Character and tr.Character:FindFirstChild("Head")then Camera.CFrame=CFrame.new(Camera.CFrame.Position,tr.Character.Head.Position)end end)end end)
UserInputService.InputEnded:Connect(function(input)if input.UserInputType==Enum.UserInputType.MouseButton2 then if Connections.Aimbot then Connections.Aimbot:Disconnect()Connections.Aimbot=nil end end end)

-- Triggerbot
task.spawn(function()while task.wait(0.06)do if Config.Triggerbot and LocalPlayer.Character then pcall(function()local tool=LocalPlayer.Character:FindFirstChildOfClass("Tool")if tool then local ray=Ray.new(Camera.CFrame.Position,Camera.CFrame.LookVector*300)local hit=Workspace:FindPartOnRay(ray,LocalPlayer.Character)if hit and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")and hit.Parent~=LocalPlayer.Character then if tool:FindFirstChild("Shoot")then tool.Shoot:FireServer(hit.Position)end end end end)end end end)

-- ESP
task.spawn(function()while task.wait(0.06)do ClearESP()if Config.ESP then for _,p in ipairs(Players:GetPlayers())do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head")then local pos,on=Camera:WorldToViewportPoint(p.Character.Head.Position)if on then local t=AddESP(Drawing.new("Text"))t.Text=p.Name t.Color=Color3.fromRGB(255,150,200)t.Size=12 t.Position=Vector2.new(pos.X,pos.Y-15)t.Center=true t.Visible=true end end end end end end)

-- Speed Hack
RunService.Stepped:Connect(function()if Config.SpeedHack and LocalPlayer.Character then local h=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")if h then h.WalkSpeed=math.min(Config.SpeedValue,30)end end end)

-- Fly
task.spawn(function()while task.wait()do if Config.Fly and LocalPlayer.Character then local hrp=LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if hrp then local g=hrp:FindFirstChild("FG")or Instance.new("BodyGyro",hrp)local v=hrp:FindFirstChild("FV")or Instance.new("BodyVelocity",hrp)g.Name="FG"g.MaxTorque=Vector3.new(9e9,9e9,9e9)g.CFrame=Camera.CFrame v.Name="FV"v.MaxForce=Vector3.new(9e9,9e9,9e9)local s=math.min(Config.FlySpeed or 30,40)local m=Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W)then m+=Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S)then m-=Camera.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A)then m-=Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D)then m+=Camera.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.Space)then m+=Vector3.new(0,1,0)end if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)then m-=Vector3.new(0,1,0)end v.Velocity=m*s end end end end)

-- Fullbright
task.spawn(function()while task.wait(2)do if Config.Fullbright then Lighting.Brightness=2 Lighting.ClockTime=14 end end end)

print("🔫 v2.2 | plalettescripts")
