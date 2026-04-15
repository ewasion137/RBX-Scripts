local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer


-- =========================================================
-- 1. ФИЗИКА И ДВИЖЕНИЕ (АНТИ-СКОЛЬЖЕНИЕ)
-- =========================================================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local hum = char.Humanoid
        local root = char.HumanoidRootPart
        
        -- Если не жмем кнопки ходьбы — стоим намертво
        if hum.MoveDirection.Magnitude == 0 then
            root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
        else
            -- Убираем инерцию в воздухе
            if hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall then
                local targetVel = hum.MoveDirection * hum.WalkSpeed
                root.Velocity = Vector3.new(targetVel.X, root.Velocity.Y, targetVel.Z)
            end
        end
    end
end)

-- Настройка материалов (максимальное трение)
local function UpdatePhysics()
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = PhysicalProperties.new(
                    100, 100, 0, 100, 0
                )
            end
        end
    end
end
LocalPlayer.CharacterAdded:Connect(UpdatePhysics)
UpdatePhysics() -- И сразу для текущего

-- =========================================================
-- 2. ПЛАТФОРМА (НАКЛОННАЯ)
-- =========================================================
local p1 = Vector3.new(-309.84, 106.0, 511.68)
local p2 = Vector3.new(-311.47, 106.0, 447.81)
local p3 = Vector3.new(-204.90, 106.0, 445.92)
local p4 = Vector3.new(-203.52, 106.0, 511.79)

local center = (p1 + p2 + p3 + p4) / 4
local sizeX = (p4 - p1).Magnitude
local sizeZ = (p2 - p1).Magnitude
local sizeY = 1

local plat = Instance.new("Part")
plat.Name = "CustomPlatform"
plat.Anchored = true
plat.Size = Vector3.new(sizeX, sizeY, sizeZ)
local right = (p4 - p1).Unit
local forward = (p2 - p1).Unit
local up = right:Cross(forward).Unit
plat.CFrame = CFrame.fromMatrix(center, right, up)
plat.Color = Color3.fromRGB(255, 255, 255)
plat.Transparency = 0.9
plat.Material = Enum.Material.Plastic
plat.Parent = workspace

-- =========================================================
-- 3. ПЕРЕМЕННЫЕ И НАСТРОЙКИ
-- =========================================================
local targetWalkSpeed = 16
local targetJumpPower = 50

-- Переключатели
local isAutoDigEnabled = false
local isAutoSnowflakes = false
local isAutoHoney = false 
local isMagnetEnabled = false -- Для токенов
local isStickerMagnet = false -- Для стикеров
local isAutoTropical = false

-- Ремоуты (с проверкой)
local Events = ReplicatedStorage:WaitForChild("Events", 5)
local ToolRemote = Events and Events:WaitForChild("ToolCollect", 5)
local MaskRemote = Events and Events:WaitForChild("ItemPackageEvent", 5)
local HiddenStickerRemote = Events and Events:WaitForChild("HiddenStickerEvent", 5)

-- =========================================================
-- 4. ИНТЕРФЕЙС
-- =========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BSS_Pro_V4_Complete"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 550)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "BSS PRO (FINAL BUILD)"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.CanvasSize = UDim2.new(0, 0, 0, 800) -- Немного увеличил CanvasSize для новой кнопки
Content.ScrollBarThickness = 2
Content.Parent = MainFrame

local List = Instance.new("UIListLayout", Content)
List.Padding = UDim.new(0, 8)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateButton(name, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.95, 0, 0, 35)
    Btn.BackgroundColor3 = color
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Btn.Parent = Content
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(0.95, 0, 0, 45)
    Frame.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1,0,0,20); Lbl.Text = name..": "..default; Lbl.TextColor3 = Color3.new(1,1,1); Lbl.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1,0,0,4); Bar.Position = UDim2.new(0,0,0,30); Bar.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default-min)/(max-min),0,1,0); Fill.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    local Btn = Instance.new("TextButton", Bar)
    Btn.Size = UDim2.new(1,0,1,0); Btn.BackgroundTransparency = 1; Btn.Text = ""
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local move = RunService.RenderStepped:Connect(function()
                local pos = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max-min)*pos)
                Fill.Size = UDim2.new(pos,0,1,0); Lbl.Text = name..": "..val
                callback(val)
            end)
            local release; release = UserInputService.InputEnded:Connect(function(i2)
                if i2.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect(); release:Disconnect() end
            end)
        end
    end)
end

-- Слайдеры
CreateSlider("Speed", 16, 150, 16, function(v) targetWalkSpeed = v end)
CreateSlider("Jump", 50, 150, 50, function(v) targetJumpPower = v end)

-- =========================================================
-- ФУНКЦИОНАЛ
-- =========================================================

local function CollectToken(targetID, enabledVar)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local collectibles = workspace:FindFirstChild("Collectibles")
    
    if root and collectibles then
        for _, token in pairs(collectibles:GetChildren()) do
            if not enabledVar() then break end
            
            local decal = token:FindFirstChild("BackDecal")
            if decal and token.Transparency == 0 then
                if string.find(tostring(decal.Texture), targetID) then
                    -- Летим к токену
                    local distance = (token.Position - root.Position).Magnitude
                    local tween = TweenService:Create(root, TweenInfo.new(distance / 150), {CFrame = token.CFrame})
                    tween:Play()
                    tween.Completed:Wait()
                    
                    task.wait(0.6) -- Задержка после сбора
                end
            end
        end
    end
end

-- 1. AUTO DIG
local DigBtn = CreateButton("Auto Dig: OFF", Color3.fromRGB(50, 50, 50), function()
    isAutoDigEnabled = not isAutoDigEnabled
end)
task.spawn(function()
    while true do
        if isAutoDigEnabled and ToolRemote then ToolRemote:FireServer() end
        task.wait(0.2)
    end
end)

-- 2. SNOWFLAKES (Tween + Teleport)
local SnowBtn = CreateButton("Auto Snowflakes: OFF", Color3.fromRGB(50, 50, 50), function()
    isAutoSnowflakes = not isAutoSnowflakes
end)
task.spawn(function()
    while true do
        if isAutoSnowflakes then CollectToken("6087969886", function() return isAutoSnowflakes end) end
        task.wait(0.5)
    end
end)

-- 2. TROPICAL DRINK
local TropBtn = CreateButton("Auto Tropical: OFF", Color3.fromRGB(50, 50, 50), function()
    isAutoTropical = not isAutoTropical
end)
task.spawn(function()
    while true do
        if isAutoTropical then CollectToken("3835878005", function() return isAutoTropical end) end
        task.wait(0.5)
    end
end)
-- 3. HONEY TOKENS (Teleport)
local HoneyBtn = CreateButton("Auto Honey Tokens: OFF", Color3.fromRGB(50, 50, 50), function()
    isAutoHoney = not isAutoHoney
end)
task.spawn(function()
    while true do
        if isAutoHoney and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local collectibles = workspace:FindFirstChild("Collectibles")
            if root and collectibles then
                for _, token in pairs(collectibles:GetChildren()) do
                    if not isAutoHoney then break end
                    local decal = token:FindFirstChild("BackDecal")
                    if decal and token.Transparency == 0 then
                        local tex = tostring(decal.Texture)
                        if string.find(tex, "1472108394") or string.find(tex, "1472135114") then
                            root.CFrame = token.CFrame
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end)

-- 4. МАСКИ
local function EquipMask(maskName)
    if MaskRemote then
        local args = { ["Type"] = maskName .. " Mask", ["Category"] = "Accessory" }
        MaskRemote:InvokeServer("Equip", args)
    end
end
CreateButton("Equip Diamond Mask", Color3.fromRGB(0, 100, 200), function() EquipMask("Diamond") end)
CreateButton("Equip Demon Mask", Color3.fromRGB(150, 0, 0), function() EquipMask("Demon") end)
-- ДОБАВЛЕНА ГАММИ МАСКА:
CreateButton("Equip Gummy Mask", Color3.fromRGB(255, 100, 150), function() EquipMask("Gummy") end)

-- =========================================================
-- 5. MAGNET STICKERS (ЯДЕРНЫЙ ВАРИАНТ)
-- =========================================================
local StickerConnection = nil
local StickerBtn = CreateButton("Magnet Stickers: OFF", Color3.fromRGB(150, 0, 150), function()
    isStickerMagnet = not isStickerMagnet
    
    if StickerConnection then StickerConnection:Disconnect(); StickerConnection = nil end

    if isStickerMagnet then
        -- Используем Heartbeat для физики каждый кадр
        StickerConnection = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local folder = workspace:FindFirstChild("HiddenStickers")
            
            if root and folder then
                -- Берем ВСЕ стикеры
                for _, part in pairs(folder:GetChildren()) do
                    if part:IsA("BasePart") and part.Transparency < 1 then
                        
                        -- 1. Снимаем коллизию и ставим якорь, чтобы не улетал обратно
                        part.CanCollide = false
                        part.Anchored = true 
                        
                        -- 2. ЖЕСТКО ставим CFrame игрока
                        part.CFrame = root.CFrame
                        
                        -- 3. Кликаем детектор
                        local cd = part:FindFirstChildOfClass("ClickDetector")
                        if cd then fireclickdetector(cd) end

                        -- 4. Касание (на всякий случай)
                        firetouchinterest(root, part, 0)
                        firetouchinterest(root, part, 1)
                    end
                end
            end
        end)
    end
end)

-- 6. SMART REJOIN
CreateButton("Rejoin (Smart)", Color3.fromRGB(255, 140, 0), function()
    local success, err = pcall(function()
        if #Players:GetPlayers() <= 1 then
            LocalPlayer:Kick("Rejoining...")
            task.wait()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    end)
    if not success then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end)

-- 7. COPY COORDS
CreateButton("Copy My Coords", Color3.fromRGB(80, 80, 80), function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local pos = root.Position
        local str = string.format("Vector3.new(%.2f, %.2f, %.2f)", pos.X, pos.Y, pos.Z)
        if setclipboard then setclipboard(str) end
        print("Coords: " .. str)
    end
end)

-- 8. MAGNET TOKENS (ALL)
local MagnetBtn = CreateButton("Magnet Tokens (Risk): OFF", Color3.fromRGB(120, 0, 0), function()
    isMagnetEnabled = not isMagnetEnabled
end)
task.spawn(function()
    while true do
        if isMagnetEnabled and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local collectibles = workspace:FindFirstChild("Collectibles")
            if root and collectibles then
                for _, token in pairs(collectibles:GetChildren()) do
                    if token:IsA("BasePart") and token.Transparency == 0 then
                        token.CFrame = root.CFrame
                        token.CanCollide = false
                    end
                end
            end
        end
        task.wait()
    end
end)

CreateButton("Unload Menu", Color3.fromRGB(80, 20, 20), function() ScreenGui:Destroy() end)

-- =========================================================
-- ВИЗУАЛ И ОБНОВЛЕНИЕ КНОПОК
-- =========================================================
local function ApplyVisuals()
    pcall(function()
        local beam = ReplicatedStorage:WaitForChild("Particles"):WaitForChild("HoneyBeam")
        if beam then
            beam.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0, 0.356, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0.994, 0.735, 0.037))
            })
        end
    end)
end
ApplyVisuals()

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = targetWalkSpeed
            hum.JumpPower = targetJumpPower
        end
        
        -- Обновление цветов кнопок
        DigBtn.Text = "Auto Dig: " .. (isAutoDigEnabled and "ON" or "OFF")
        DigBtn.BackgroundColor3 = isAutoDigEnabled and Color3.fromRGB(40, 120, 40) or Color3.fromRGB(50, 50, 50)
        
        SnowBtn.Text = "Snowflakes: " .. (isAutoSnowflakes and "ON" or "OFF")
        SnowBtn.BackgroundColor3 = isAutoSnowflakes and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 50)

        HoneyBtn.Text = "Honey Tokens: " .. (isAutoHoney and "ON" or "OFF")
        HoneyBtn.BackgroundColor3 = isAutoHoney and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(50, 50, 50)

        StickerBtn.Text = "Magnet Stickers: " .. (isStickerMagnet and "ON" or "OFF")
        StickerBtn.BackgroundColor3 = isStickerMagnet and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 0, 150)

        TropBtn.Text = "Tropical: " .. (isAutoTropical and "ON" or "OFF")
        TropBtn.BackgroundColor3 = isAutoTropical and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(50, 50, 50)
        
        MagnetBtn.Text = "Magnet Tokens: " .. (isMagnetEnabled and "ON" or "OFF")
        MagnetBtn.BackgroundColor3 = isMagnetEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(120, 0, 0)
    end)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.M then ScreenGui.Enabled = not ScreenGui.Enabled end
end)
