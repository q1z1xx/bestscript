-- Saturn Hub: Визуальный скрипт с ползунком обхода и ссылкой
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SaturnHub"
gui.Parent = player:WaitForChild("PlayerGui")

local bypassActivated = false
local bypassLoading = false

-- Функция уведомлений
local function notify(blockName, percent)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(0, 450, 0, 40)
    msg.Position = UDim2.new(0.5, -225, 0, -50)
    msg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    msg.TextColor3 = Color3.fromRGB(255, 255, 255)
    msg.Text = "Шанс выпадения хорошего брейнрота из " .. blockName .. " повышен на " .. percent .. "%!"
    msg.Font = Enum.Font.GothamBold
    msg.TextSize = 14
    msg.Parent = gui
    Instance.new("UICorner", msg).CornerRadius = UDim.new(0, 8)

    TweenService:Create(msg, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -225, 0, 20)}):Play()
    task.wait(3)
    TweenService:Create(msg, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -225, 0, -50)}):Play()
    task.wait(0.5)
    msg:Destroy()
end

-- Функция фейкового ползунка обхода
local function showBypassLoading()
    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(0, 300, 0, 50)
    bg.Position = UDim2.new(0.5, -150, 0, -60)
    bg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local text = Instance.new("TextLabel", bg)
    text.Size = UDim2.new(1, 0, 0, 25)
    text.Position = UDim2.new(0, 0, 0, 5)
    text.BackgroundTransparency = 1
    text.Text = "Обход античита..."
    text.TextColor3 = Color3.fromRGB(255, 200, 0)
    text.Font = Enum.Font.GothamBold
    text.TextSize = 14

    local barBg = Instance.new("Frame", bg)
    barBg.Size = UDim2.new(0.9, 0, 0, 8)
    barBg.Position = UDim2.new(0.05, 0, 0, 32)
    barBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 4)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(170, 85, 255)
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 4)

    -- Анимация появления
    TweenService:Create(bg, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
    
    -- Анимация заполнения ползунка (120 секунд)
    local fillTween = TweenService:Create(barFill, TweenInfo.new(120, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    fillTween:Play()

    fillTween.Completed:Connect(function()
        text.Text = "Успешно!"
        text.TextColor3 = Color3.fromRGB(100, 255, 100)
        task.wait(1.5)
        TweenService:Create(bg, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0, -60)}):Play()
        task.wait(0.5)
        bg:Destroy()
    end)
end

-- Главный фрейм
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.4, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Заголовок
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Saturn Hub"
title.TextColor3 = Color3.fromRGB(170, 85, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.BackgroundTransparency = 1

-- Подзаголовок
local subtitle = Instance.new("TextLabel", mainFrame)
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.Text = "Выбери лаки блок"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.Font = Enum.Font.GothamSemibold
subtitle.TextSize = 14
subtitle.BackgroundTransparency = 1

-- Ввод процента
local percentInput = Instance.new("TextBox", mainFrame)
percentInput.Size = UDim2.new(0.8, 0, 0, 30)
percentInput.Position = UDim2.new(0.1, 0, 0, 70)
percentInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
percentInput.TextColor3 = Color3.fromRGB(255, 255, 255)
percentInput.PlaceholderText = "Введите % (например: 99)"
percentInput.Font = Enum.Font.Gotham
percentInput.TextSize = 14
Instance.new("UICorner", percentInput).CornerRadius = UDim.new(0, 6)

-- Фрейм для кнопок
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(0.9, 0, 0, 260)
scrollFrame.Position = UDim2.new(0.05, 0, 0, 110)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Фрейм профиля
local profileFrame = Instance.new("Frame", mainFrame)
profileFrame.Size = UDim2.new(1, 0, 0, 60)
profileFrame.Position = UDim2.new(0, 0, 1, 5)
profileFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(0, 10)

local avatar = Instance.new("ImageLabel", profileFrame)
avatar.Size = UDim2.new(0, 50, 0, 50)
avatar.Position = UDim2.new(0, 5, 0, 5)
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
avatar.BackgroundTransparency = 1
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

local nameLabel = Instance.new("TextLabel", profileFrame)
nameLabel.Size = UDim2.new(0, 150, 0, 20)
nameLabel.Position = UDim2.new(0, 65, 0, 10)
nameLabel.Text = player.Name
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.BackgroundTransparency = 1
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

local bypassStatus = Instance.new("TextLabel", profileFrame)
bypassStatus.Size = UDim2.new(0, 150, 0, 20)
bypassStatus.Position = UDim2.new(0, 65, 0, 30)
bypassStatus.Text = "Обход - Не активирован"
bypassStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
bypassStatus.Font = Enum.Font.Gotham
bypassStatus.TextSize = 12
bypassStatus.BackgroundTransparency = 1
bypassStatus.TextXAlignment = Enum.TextXAlignment.Left

-- Ссылка на Telegram снизу
local tgLink = Instance.new("TextLabel", mainFrame)
tgLink.Size = UDim2.new(1, 0, 0, 20)
tgLink.Position = UDim2.new(0, 0, 1, 70)
tgLink.Text = "T.ME/SABSCRIPTER"
tgLink.TextColor3 = Color3.fromRGB(150, 150, 255)
tgLink.Font = Enum.Font.GothamBold
tgLink.TextSize = 12
tgLink.BackgroundTransparency = 1

-- Логика кнопок
local blocks = {
    "Secret Lucky Block", "OG Lucky Block", "Leprechaun Lucky Block",
    "Taco Lucky Block", "Admin Lucky Block", "Los Lucky Blocks", "Los Taco Lucky Blocks"
}

for _, block in ipairs(blocks) do
    local btn = Instance.new("TextButton", scrollFrame)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Text = block
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        local percent = percentInput.Text
        if percent == "" then percent = "???" end

        if bypassActivated then
            notify(block, percent)
        elseif not bypassLoading then
            bypassLoading = true
            bypassStatus.Text = "Обход - Загрузка..."
            bypassStatus.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            showBypassLoading()

            task.spawn(function()
                task.wait(120) -- Ожидание 120 секунд
                bypassActivated = true
                bypassLoading = false
                bypassStatus.Text = "Обход - Активирован"
                bypassStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
                notify(block, percent)
            end)
        end
    end)
end

-- Авто-размер скролла
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)
