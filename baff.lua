-- Защита от двойного запуска (чтобы меню не плодилось, если ты запустишь скрипт дважды)
if getgenv().EwasionScriptLoaded then
    -- Rayfield сам умеет уничтожать старые окна, но на всякий случай
    warn("Скрипт уже запущен!") 
    return 
end
getgenv().EwasionScriptLoaded = true

-- Глобальные переменные для наших циклов
getgenv().AutoRoll = false
getgenv().AutoSprouts = false

-- Загружаем Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Создаем главное окно
local Window = Rayfield:CreateWindow({
    Name = "Ewasion Hub 🚀",
    LoadingTitle = "Грузим рофляново...",
    LoadingSubtitle = "by ewasion137",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil, 
       FileName = "EwasionHub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink", 
       RememberJoins = true 
    },
    KeySystem = false, 
})

-- Создаем вкладку
local MainTab = Window:CreateTab("Главная", 4483362458) 

-- ТУТ БУДЕТ ЛОГИКА АВТО-РОЛЛА
MainTab:CreateToggle({
    Name = "Моментальный Auto Roll",
    CurrentValue = false,
    Flag = "AutoRollToggle",
    Callback = function(Value)
        getgenv().AutoRoll = Value
        
        if getgenv().AutoRoll then
            task.spawn(function()
                while getgenv().AutoRoll do
                    task.wait() -- задержка, чтобы не крашнуть игру
                    -- СЮДА ВСТАВИМ ТВОЙ REMOTE EVENT ДЛЯ РОЛЛА, когда найдешь
                    -- Пример: game:GetService("ReplicatedStorage").RollRemote:FireServer()
                end
            end)
        end
    end,
})

-- ТУТ БУДЕТ ЛОГИКА АВТО-РОСТКОВ
MainTab:CreateToggle({
    Name = "Auto Click Sprouts",
    CurrentValue = false,
    Flag = "AutoSproutsToggle",
    Callback = function(Value)
        getgenv().AutoSprouts = Value
        
        if getgenv().AutoSprouts then
            task.spawn(function()
                while getgenv().AutoSprouts do
                    task.wait(0.2)
                    -- СЮДА ВСТАВИМ ЛОГИКУ ПОИСКА РОСТКОВ
                    -- Как только скажешь, как они называются и что внутри (ClickDetector/ProximityPrompt)
                end
            end)
        end
    end,
})

Rayfield:Notify({
    Title = "Скрипт загружен!",
    Content = "Дарооууу! Погнали.",
    Duration = 5,
    Image = 4483362458,
})