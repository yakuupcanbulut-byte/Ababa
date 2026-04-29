--[[
    ╔══════════════════════════════════════════╗
    ║  KALI-MAC EXPERIMENTAL ADMIN PANEL       ║
    ║  Deneysel & Eğitimsel Amaçlıdır          ║
    ╚══════════════════════════════════════════╝
--]]

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Tema Renkleri (Kali Linux Green + macOS Dark)
local COLORS = {
    bg = Color3.fromRGB(13, 13, 15),
    bgLight = Color3.fromRGB(28, 28, 32),
    accent = Color3.fromRGB(0, 255, 100),      -- Kali Green
    accentDim = Color3.fromRGB(0, 150, 60),
    text = Color3.fromRGB(220, 220, 220),
    danger = Color3.fromRGB(255, 50, 50),
    warning = Color3.fromRGB(255, 165, 0)
}

-- GUI Oluştur
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaliMacAdmin"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- ANA PANEL (macOS yuvarlak köşe + Kali koyu tema)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 340, 0, 480)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -240)
MainFrame.BackgroundColor3 = COLORS.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

-- Glow Efekti
local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = COLORS.accent
Glow.ImageTransparency = 0.85
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(24, 24, 276, 276)
Glow.ZIndex = 0
Glow.Parent = MainFrame

-- BAŞLIK ÇUBUĞU
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = COLORS.bgLight
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 16)
TitleFix.Position = UDim2.new(0, 0, 1, -16)
TitleFix.BackgroundColor3 = COLORS.bgLight
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 2
TitleFix.Parent = TitleBar

-- macOS Traffic Lights (dekoratif)
local function createDot(color, pos)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = pos
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    dot.Parent = TitleBar
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    return dot
end

createDot(COLORS.danger, UDim2.new(0, 16, 0, 16))
createDot(Color3.fromRGB(255, 200, 0), UDim2.new(0, 34, 0, 16))
createDot(COLORS.accent, UDim2.new(0, 52, 0, 16))

-- Başlık Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 70, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "root@kali-mac:~ admin_panel"
TitleText.TextColor3 = COLORS.accent
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 3
TitleText.Parent = TitleBar

-- Kapatma Butonu
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.BackgroundColor3 = COLORS.danger
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.ZIndex = 3
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- İÇERİK ALANI
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -24, 1, -60)
Content.Position = UDim2.new(0, 12, 0, 54)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = COLORS.accent
Content.CanvasSize = UDim2.new(0, 0, 0, 500)
Content.ZIndex = 2
Content.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 10)
UIList.Parent = Content

-- Yardımcı Fonksiyonlar
local function tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, Enum.EasingStyle.Quad), props):Play()
end

local function createSection(title)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.Text = "── " .. string.upper(title) .. " ──"
    lbl.TextColor3 = COLORS.accentDim
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Content
    return lbl
end

local function createButton(text, callback, isDanger)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = COLORS.bgLight
    btn.Text = "  ➜  " .. text
    btn.TextColor3 = isDanger and COLORS.danger or COLORS.accent
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = isDanger and Color3.fromRGB(80, 20, 20) or Color3.fromRGB(0, 60, 30)
    stroke.Thickness = 1
    stroke.Parent = btn
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = isDanger and Color3.fromRGB(60, 15, 15) or Color3.fromRGB(0, 60, 30)}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = COLORS.bgLight}, 0.2)
    end)
    
    btn.MouseButton1Click:Connect(function()
        callback()
        -- Click ripple efekti
        tween(btn, {BackgroundColor3 = isDanger and COLORS.danger or COLORS.accent}, 0.05)
        task.delay(0.1, function()
            tween(btn, {BackgroundColor3 = COLORS.bgLight}, 0.2)
        end)
    end)
    
    return btn
end

local function createInput(labelText, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 80)
    container.BackgroundTransparency = 1
    container.Parent = Content
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = COLORS.text
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 44)
    box.Position = UDim2.new(0, 0, 0, 26)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    box.Text = ""
    box.PlaceholderText = "  Değer girin..."
    box.TextColor3 = COLORS.accent
    box.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
    box.Font = Enum.Font.Code
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = container
    
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 50, 25)
    stroke.Thickness = 1
    stroke.Parent = box
    
    box.FocusLost:Connect(function(enter)
        if enter and box.Text ~= "" then
            callback(box.Text)
            box.Text = ""
        end
    end)
    
    return box
end

-- ═══════════════════════════════════════
-- FLY SİSTEMİ (PC + Mobile Desteği)
-- ═══════════════════════════════════════
createSection("flight control")

local flying = false
local flyConnection
local flyBtn

local function toggleFly()
    flying = not flying
    if flying then
        flyBtn.Text = "  ➜  [ ✓ AKTİF ] FLY MODE"
        flyBtn.TextColor3 = COLORS.warning
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "KaliFlyVel"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.zero
        bv.Parent = humanoidRootPart
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "KaliFlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 10000
        bg.Parent = humanoidRootPart
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if not flying then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.zero
            
            -- PC Kontroller
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, 1, 0) end
            
            bv.Velocity = dir * 50
            bg.CFrame = cam.CFrame
        end)
    else
        flyBtn.Text = "  ➜  FLY MODE"
        flyBtn.TextColor3 = COLORS.accent
        if flyConnection then flyConnection:Disconnect() end
        local bv = humanoidRootPart:FindFirstChild("KaliFlyVel")
        local bg = humanoidRootPart:FindFirstChild("KaliFlyGyro")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

flyBtn = createButton("FLY MODE", toggleFly)

-- ═══════════════════════════════════════
-- SPEED CONTROL
-- ═══════════════════════════════════════
createSection("locomotion")

createInput("WALK SPEED (Varsayılan: 16)", function(txt)
    local n = tonumber(txt)
    if n then
        humanoid.WalkSpeed = math.clamp(n, 0, 500)
    end
end)

createInput("JUMP POWER (Varsayılan: 50)", function(txt)
    local n = tonumber(txt)
    if n then
        humanoid.JumpPower = math.clamp(n, 0, 500)
    end
end)

-- ═══════════════════════════════════════
-- SKY CHANGER (Cyberpunk / Matrix)
-- ═══════════════════════════════════════
createSection("environment")

createButton("SKY: CYBERPUNK NIGHT", function()
    Lighting.ClockTime = 0
    Lighting.Ambient = Color3.fromRGB(80, 0, 120)
    Lighting.OutdoorAmbient = Color3.fromRGB(40, 0, 80)
    Lighting.FogColor = Color3.fromRGB(10, 0, 30)
    Lighting.FogEnd = 400
    Lighting.Brightness = 0.5
end)

createButton("SKY: MATRIX GREEN", function()
    Lighting.ClockTime = 6
    Lighting.Ambient = Color3.fromRGB(0, 40, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 80, 0)
    Lighting.FogColor = Color3.fromRGB(0, 15, 0)
    Lighting.FogEnd = 800
    Lighting.Brightness = 1.2
end)

createButton("SKY: RED TEAM", function()
    Lighting.ClockTime = 18
    Lighting.Ambient = Color3.fromRGB(120, 20, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(80, 10, 0)
    Lighting.FogColor = Color3.fromRGB(30, 5, 0)
    Lighting.FogEnd = 300
    Lighting.Brightness = 0.8
end)

createButton("SKY: RESET DEFAULT", function()
    Lighting.ClockTime = 14
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.FogColor = Color3.fromRGB(192, 192, 192)
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
end)

-- ═══════════════════════════════════════
-- MUSIC PLAYER (Roblox Asset ID)
-- ═══════════════════════════════════════
createSection("audio stream")

createInput("MUSIC ID (örn: 1838618353)", function(txt)
    local id = tonumber(txt)
    if id then
        local old = workspace:FindFirstChild("KaliAdminMusic")
        if old then old:Destroy() end
        
        local sound = Instance.new("Sound")
        sound.Name = "KaliAdminMusic"
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = 0.6
        sound.Looped = true
        sound.Parent = workspace
        sound:Play()
    end
end)

createButton("STOP MUSIC", function()
    local old = workspace:FindFirstChild("KaliAdminMusic")
    if old then old:Destroy() end
end, true)

-- ═══════════════════════════════════════
-- SOL ALT: KARAKTER BİLGİSİ (Terminal Stili)
-- ═══════════════════════════════════════
local CharFrame = Instance.new("Frame")
CharFrame.Name = "CharInfo"
CharFrame.Size = UDim2.new(0, 220, 0, 70)
CharFrame.Position = UDim2.new(0, 15, 1, -85)
CharFrame.BackgroundColor3 = COLORS.bg
CharFrame.BorderSizePixel = 0
CharFrame.Parent = ScreenGui

Instance.new("UICorner", CharFrame).CornerRadius = UDim.new(0, 14)

local charStroke = Instance.new("UIStroke")
charStroke.Color = Color3.fromRGB(0, 80, 40)
charStroke.Thickness = 1
charStroke.Parent = CharFrame

-- Avatar Görseli
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 56, 0, 56)
Avatar.Position = UDim2.new(0, 7, 0, 7)
Avatar.BackgroundColor3 = COLORS.bgLight
Avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
Avatar.Parent = CharFrame
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(0, 12)

-- Kullanıcı Adı
local NameLbl = Instance.new("TextLabel")
NameLbl.Size = UDim2.new(1, -75, 0, 28)
NameLbl.Position = UDim2.new(0, 70, 0, 8)
NameLbl.BackgroundTransparency = 1
NameLbl.Text = player.DisplayName
NameLbl.TextColor3 = COLORS.accent
NameLbl.Font = Enum.Font.Code
NameLbl.TextSize = 18
NameLbl.TextXAlignment = Enum.TextXAlignment.Left
NameLbl.Parent = CharFrame

-- Status (Terminal prompt stili)
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, -75, 0, 22)
StatusLbl.Position = UDim2.new(0, 70, 0, 36)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "root@" .. player.Name:lower() .. ":~$ online"
StatusLbl.TextColor3 = COLORS.accentDim
StatusLbl.Font = Enum.Font.Code
StatusLbl.TextSize = 12
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.Parent = CharFrame

-- Typing efekti için cursor
task.spawn(function()
    while CharFrame and CharFrame.Parent do
        StatusLbl.Text = "root@" .. player.Name:lower() .. ":~$ online_"
        task.wait(0.5)
        if StatusLbl and StatusLbl.Parent then
            StatusLbl.Text = "root@" .. player.Name:lower() .. ":~$ online"
        end
        task.wait(0.5)
    end
end)

-- ═══════════════════════════════════════
-- MOBİL TOGGLE BUTONU (Sağ Üst)
-- ═══════════════════════════════════════
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 56, 0, 56)
ToggleBtn.Position = UDim2.new(1, -66, 0, 15)
ToggleBtn.BackgroundColor3 = COLORS.bg
ToggleBtn.Text = "⌘"
ToggleBtn.TextColor3 = COLORS.accent
ToggleBtn.Font = Enum.Font.Code
ToggleBtn.TextSize = 28
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = COLORS.accentDim
toggleStroke.Thickness = 2
toggleStroke.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    tween(ToggleBtn, {BackgroundColor3 = MainFrame.Visible and COLORS.accentDim or COLORS.bg}, 0.2)
end)

-- ═══════════════════════════════════════
-- KARAKTER YENİDEN SPAWN
-- ═══════════════════════════════════════
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    if flying then
        flying = false
        flyBtn.Text = "  ➜  FLY MODE"
        flyBtn.TextColor3 = COLORS.accent
        if flyConnection then flyConnection:Disconnect() end
    end
    
    -- Avatar güncelle
    Avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)

-- Başlangıç animasyonu
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Visible = true
tween(MainFrame, {Size = UDim2.new(0, 340, 0, 480)}, 0.4)

print("[KALI-MAC] Admin Panel loaded successfully | Deneysel & Egitimsel Kullanim")
