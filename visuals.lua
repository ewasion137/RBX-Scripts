local targetFolder = workspace.Map.Ground

local find1 = game.Lighting:FindFirstChildWhichIsA("BloomEffect") if find1 then

game.Lighting:FindFirstChildWhichIsA("BloomEffect"):Destroy()

end

local find2 = game.Lighting:FindFirstChildWhichIsA("SunRaysEffect") if find2 then

game.Lighting:FindFirstChildWhichIsA("SunRaysEffect"):Destroy()

end

local find3 = game.Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect") if find3 then

game.Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect"):Destroy()

end

local find4 = game.Lighting:FindFirstChildWhichIsA("BlurEffect") if find4 then

game.Lighting:FindFirstChildWhichIsA("BlurEffect"):Destroy()

end

local blem = Instance.new("BloomEffect",game.Lighting)

local sanrey = Instance.new("SunRaysEffect",game.Lighting)

local color = Instance.new("ColorCorrectionEffect",game.Lighting)

local blor = Instance.new("BlurEffect",game.Lighting)

game.Lighting.ExposureCompensation = 0.25

game.Lighting.ShadowSoftness = 1

game.Lighting.EnvironmentDiffuseScale = 0.343

game.Lighting.EnvironmentSpecularScale = 1

game.Lighting.ColorShift_Top = Color3.fromRGB(118,117,108)

game.Lighting.OutdoorAmbient = Color3.fromRGB(141,141,141)

game.Lighting.GeographicLatitude = 100

game.Lighting.Ambient = Color3.fromRGB(112,112,112)

blem.Intensity = 0.4

blem.Size = 20

blem.Threshold = 1.5

sanrey.Intensity = 0.110

sanrey.Spread = 1

blor.Size = 2

color.Contrast = 0.2

color.Saturation = 0.1

color.TintColor = Color3.fromRGB(255,252,224)
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

for _, v in pairs(targetFolder:GetDescendants()) do
    -- Проверяем, является ли объект физической деталью (Part, MeshPart, Union)
    if v:IsA("BasePart") then
        v.Material = Enum.Material.Sand
        
        -- ОПЦИОНАЛЬНО: Можно поменять цвет на песочный, если хочешь
        -- v.Color = Color3.fromRGB(235, 205, 165) 
    end
end

print("Текстуры земли заменены на Песок!")

--[[ 
    Cartoony Animation Replacer (Based on your IDs) 
    Работает для R15
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Animate = Character:WaitForChild("Animate")

-- Твои ID со скриншота
local animIds = {
    idle  = "10921071918", -- Idle
    walk  = "10921082452", -- Walk
    run   = "10921076136", -- Run
    jump  = "10921078135", -- Jump
    fall  = "10921077030", -- Fall
    climb = "10921070953", -- Climb
    swim  = "10921079380", -- Swim
}

local function replaceAnimations()
    print("Заменяю анимации на Cartoony...")

    -- Проходимся по списку и заменяем
    for animName, animId in pairs(animIds) do
        local animFolder = Animate:FindFirstChild(animName)
        
        if animFolder then
            -- Внутри папки (например idle) могут быть Animation1, Animation2 и т.д.
            -- Заменяем ID во всех объектах Animation внутри этой папки
            for _, child in pairs(animFolder:GetChildren()) do
                if child:IsA("Animation") then
                    child.AnimationId = "rbxassetid://" .. animId
                end
            end
        end
    end

    -- Самая важная часть: Перезагружаем скрипт Animate
    -- Это заставляет Roblox сбросить текущие треки и загрузить новые ID
    Animate.Disabled = true
    task.wait() -- Маленькая задержка для стабильности
    Animate.Disabled = false
    
    print("Анимации успешно заменены!")
end

-- Запуск
replaceAnimations()

-- Опционально: Уведомление на экране (если поддерживается игрой/экзекутором)
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Animation Changer";
        Text = "Cartoony Animations Loaded!";
        Duration = 3;
    })
end)

-- [[ BSS CUSTOM VISUALS ]] --

local function applyChanges()
    -- 1. FieldDecos (Прозрачность 0.5, без коллизии)
    if workspace:FindFirstChild("FieldDecos") then
        for _, v in pairs(workspace.FieldDecos:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 0.5
                v.CanCollide = false
            end
        end
    end

    -- 2 & 3. The Supreme Saturator (Партиклы)
    pcall(function()
        local saturator = workspace.Gadgets:FindFirstChild("The Supreme Saturator")
        if saturator and saturator:FindFirstChild("Top") then
            local top = saturator.Top
            
            -- Sparkles Size
            if top:FindFirstChild("Sparkles") then
                top.Sparkles.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 6.071)
                })
            end
            
            -- Honey Size
            if top:FindFirstChild("Honey") then
                top.Honey.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 5.83432),
                    NumberSequenceKeypoint.new(0.215478, 3.52663, 0.175), -- С энвелопом (разбросом)
                    NumberSequenceKeypoint.new(1, 0)
                })
            end
        end
    end)

    -- 5. HiddenStickers (Яркий глоу)
    if workspace:FindFirstChild("HiddenStickers") then
        for _, sticker in pairs(workspace.HiddenStickers:GetChildren()) do
            -- Удаляем старый хайлайт если есть, чтобы не дублировать
            if sticker:FindFirstChild("CustomGlow") then sticker.CustomGlow:Destroy() end
            
            local hl = Instance.new("Highlight")
            hl.Name = "CustomGlow"
            hl.Parent = sticker
            hl.FillColor = Color3.fromRGB(255, 255, 0) -- Ярко-желтый
            hl.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белая обводка
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
        end
    end

    -- 6. Hive Models (Белый цвет + Cracked Lava)
    pcall(function()
        local hiveModels = workspace.HiveDeco.HiveModels
        -- Ищем конкретно Basic Black, как ты просил
        local targetHive = hiveModels:FindFirstChild("HiveModelBasic Black")
        
        if targetHive then
            local partsToChange = {"BackPlate", "BaseCircle", "BasePlate"}
            
            for _, partName in pairs(partsToChange) do
                local part = targetHive:FindFirstChild(partName)
                if part then
                    part.Color = Color3.fromRGB(255, 255, 255)
                    part.Material = Enum.Material.CrackedLava
                end
            end
        end
    end)
end

-- Запуск
applyChanges()
print("Визуал применен!")

local assetId = 15876671760
local lighting = game:GetService("Lighting")

-- 1. Загружаем объект из библиотеки Roblox
local success, objects = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)
end)

if success and objects[1] then
    local newSky = objects[1]
    
    -- Если внутри модели лежит Sky, достаем его, если нет - берем сам объект
    if not newSky:IsA("Sky") then
        newSky = newSky:FindFirstChildOfClass("Sky")
    end

    if newSky then
        -- 2. Очищаем Lighting от старого неба, атмосферы и тумана
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
                obj:Destroy()
            end
        end

        -- 3. Устанавливаем новое небо
        newSky.Parent = lighting
        
        -- 4. НАСТРОЙКИ НОЧИ (чтобы выглядело круто)
        lighting.FogEnd = 100000         -- Выключаем туман (чтобы небо было четким)
        lighting.Brightness = 0.5        -- Приглушаем яркость мира под ночь
        lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 80) -- Синеватый оттенок теней

        print("Ночное небо 'Fog on the water' установлено!")
    else
        print("Ошибка: В ассете не найден объект класса Sky")
    end
else
    print("Ошибка: Не удалось загрузить ассет. Возможно, экзекутор не поддерживает GetObjects или ID неверный.")
end


local Camera = workspace.CurrentCamera
Camera.FieldOfView = 100 -- Золотая середина. Можешь поставить 120 для эффекта "рыбий глаз"

-- Фиксация, чтобы игра не сбрасывала
game:GetService("RunService").RenderStepped:Connect(function()
    Camera.FieldOfView = 100
end)

-- [[ ATMOSPHERIC RAIN V3 (PERMANENT FOLLOW) ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- 1. Создаем или находим блок
local RainPart = workspace:FindFirstChild("RainEmitter") or Instance.new("Part")
RainPart.Name = "RainEmitter"
RainPart.Size = Vector3.new(200, 1, 200) -- Увеличил площадь, чтобы не было краев
RainPart.Transparency = 1
RainPart.Anchored = true
RainPart.CanCollide = false
RainPart.CanQuery = false
RainPart.Parent = workspace

-- 2. Настройка частиц (тонкие иглы)
local RainDrop = RainPart:FindFirstChild("RainParticles") or Instance.new("ParticleEmitter")
RainDrop.Name = "RainParticles"
RainDrop.Texture = "rbxassetid://241685484" 
RainDrop.Color = ColorSequence.new(Color3.fromRGB(200, 200, 220))
RainDrop.Transparency = NumberSequence.new(0.65) -- Чуть-чуть заметнее
RainDrop.Size = NumberSequence.new(0.12) -- Еще тоньше
RainDrop.Orientation = Enum.ParticleOrientation.VelocityParallel 
RainDrop.EmissionDirection = Enum.NormalId.Bottom 
RainDrop.Lifetime = NumberRange.new(1.5, 2)
RainDrop.Rate = 500 -- Плотнее, так как они совсем тонкие
RainDrop.Speed = NumberRange.new(10, 30) -- Быстро падают вниз
RainDrop.SpreadAngle = Vector2.new(0, 0)
RainDrop.Parent = RainPart

-- 3. Звук (фоновый шелест)
local RainSound = RainPart:FindFirstChild("RainSound") or Instance.new("Sound")
RainSound.Name = "RainSound"
RainSound.SoundId = "rbxassetid://1516791621"
RainSound.Volume = 0.15
RainSound.Looped = true
RainSound.Parent = RainPart
if not RainSound.IsPlaying then RainSound:Play() end

-- ГЛАВНАЯ ЛОГИКА: СЛЕДОВАНИЕ ЗА ИГРОКОМ
RunService.Heartbeat:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if root then
        -- Блок всегда ровно над твоим RootPart на высоте 50 студов
        RainPart.CFrame = CFrame.new(root.Position + Vector3.new(0, 50, 0))
    else
        -- Если ты умер/респавнишься, дождь ждет над камерой
        local cam = workspace.CurrentCamera
        if cam then
            RainPart.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(0, 50, 0))
        end
    end
end)

print("Дождь теперь привязан к тебе навсегда!")
