local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local guiName = "XIVIHUB_SAFE"
if CoreGui:FindFirstChild(guiName) then
    CoreGui[guiName]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local bgDark = Color3.fromRGB(12, 12, 14)
local panelDark = Color3.fromRGB(18, 18, 20)
local textWhite = Color3.fromRGB(255, 255, 255)
local textGray = Color3.fromRGB(150, 150, 150)
local linkColor = Color3.fromRGB(100, 150, 255) -- Синий цвет как у спиннера

local ToggleBtnMain = Instance.new("TextButton")
ToggleBtnMain.Size = UDim2.new(0, 50, 0, 50)
ToggleBtnMain.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtnMain.BackgroundColor3 = bgDark
ToggleBtnMain.Text = "⚡"
ToggleBtnMain.TextColor3 = linkColor
ToggleBtnMain.TextSize = 28
ToggleBtnMain.ZIndex = 10
ToggleBtnMain.Parent = ScreenGui
Instance.new("UICorner", ToggleBtnMain).CornerRadius = UDim.new(1, 0)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 400, 0, 550)
Container.Position = UDim2.new(0.5, -200, 0.5, -275)
Container.BackgroundTransparency = 1
Container.Visible = false
Container.Parent = ScreenGui

ToggleBtnMain.MouseButton1Click:Connect(function()
    Container.Visible = not Container.Visible
end)

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Container.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = bgDark
MainFrame.ZIndex = 1
MainFrame.Parent = Container
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
MakeDraggable(MainFrame)

-- Новая ссылка слева
local LinkLabel = Instance.new("TextLabel")
LinkLabel.Parent = MainFrame
LinkLabel.Position = UDim2.new(0, 20, 0, 20) -- Слева
LinkLabel.Size = UDim2.new(0, 160, 0, 40) -- Фиксированная ширина для ссылки
LinkLabel.BackgroundTransparency = 1
LinkLabel.Text = "t.me/bestscriptfree"
LinkLabel.TextColor3 = linkColor
LinkLabel.TextSize = 14
LinkLabel.Font = Enum.Font.GothamBold
LinkLabel.TextXAlignment = Enum.TextXAlignment.Left
LinkLabel.ZIndex = 2

-- Заголовок (сдвинут вправо)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.Position = UDim2.new(0, 20 + 160, 0, 20) -- Сдвиг вправо на ширину ссылки
TitleLabel.Size = UDim2.new(1, -40 - 160, 0, 40) -- Уменьшенная ширина
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "XIVI HUB"
TitleLabel.TextColor3 = textWhite
TitleLabel.TextSize = 32
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -40, 0, 20)
SubTitle.Position = UDim2.new(0, 20, 0, 55)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "ВЫБЕРИТЕ СКРИПТ"
SubTitle.TextColor3 = textGray
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 2
SubTitle.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -40, 1, -140)
ScrollFrame.Position = UDim2.new(0, 20, 0, 90)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ZIndex = 2
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

local SubMenuFrame = Instance.new("Frame")
SubMenuFrame.Size = UDim2.new(1, 0, 1, 0)
SubMenuFrame.BackgroundColor3 = bgDark
SubMenuFrame.Visible = false
SubMenuFrame.ZIndex = 1
SubMenuFrame.Parent = Container
Instance.new("UICorner", SubMenuFrame).CornerRadius = UDim.new(0, 15)
MakeDraggable(SubMenuFrame)

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 30, 0, 30)
BackBtn.Position = UDim2.new(0, 20, 0, 20)
BackBtn.BackgroundColor3 = panelDark
BackBtn.Text = "<"
BackBtn.TextColor3 = textWhite
BackBtn.TextSize = 16
BackBtn.Font = Enum.Font.GothamBold
BackBtn.ZIndex = 2
BackBtn.Parent = SubMenuFrame
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(1, 0)

local SubMenuTitle = Instance.new("TextLabel")
SubMenuTitle.Size = UDim2.new(1, -80, 0, 30)
SubMenuTitle.Position = UDim2.new(0, 60, 0, 20)
SubMenuTitle.BackgroundTransparency = 1
SubMenuTitle.TextColor3 = textWhite
SubMenuTitle.TextSize = 22
SubMenuTitle.Font = Enum.Font.GothamBold
SubMenuTitle.TextXAlignment = Enum.TextXAlignment.Left
SubMenuTitle.ZIndex = 2
SubMenuTitle.Parent = SubMenuFrame

local SubMenuContent = Instance.new("Frame")
SubMenuContent.Size = UDim2.new(1, -40, 1, -80)
SubMenuContent.Position = UDim2.new(0, 20, 0, 70)
SubMenuContent.BackgroundTransparency = 1
SubMenuContent.ZIndex = 2
SubMenuContent.Parent = SubMenuFrame

local SubUIListLayout = Instance.new("UIListLayout")
SubUIListLayout.Padding = UDim.new(0, 15)
SubUIListLayout.Parent = SubMenuContent

BackBtn.MouseButton1Click:Connect(function()
    SubMenuFrame.Visible = false
    MainFrame.Visible = true
end)

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Overlay.BackgroundTransparency = 0.1
Overlay.ZIndex = 20
Overlay.Visible = false
Overlay.Parent = Container
Instance.new("UICorner", Overlay).CornerRadius = UDim.new(0, 15)

local Spinner = Instance.new("ImageLabel")
Spinner.Size = UDim2.new(0, 50, 0, 50)
Spinner.Position = UDim2.new(0.5, -25, 0, 100)
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://3602422090"
Spinner.ImageColor3 = linkColor
Spinner.ZIndex = 21
Spinner.Parent = Overlay

local spinTween = TweenService:Create(Spinner, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})

local ActTitle = Instance.new("TextLabel")
ActTitle.Size = UDim2.new(1, 0, 0, 40)
ActTitle.Position = UDim2.new(0, 0, 0, 180)
ActTitle.BackgroundTransparency = 1
ActTitle.Text = "Обходим..."
ActTitle.TextColor3 = linkColor
ActTitle.TextSize = 26
ActTitle.Font = Enum.Font.GothamBold
ActTitle.ZIndex = 21
ActTitle.Parent = Overlay

local ActDesc = Instance.new("TextLabel")
ActDesc.Size = UDim2.new(0.9, 0, 0, 60)
ActDesc.Position = UDim2.new(0.05, 0, 0, 220)
ActDesc.BackgroundTransparency = 1
ActDesc.Text = "Обходим античит игры: Займет примерно до 2-ух минут, пожалуйста не выходите из игры."
ActDesc.TextColor3 = textGray
ActDesc.TextSize = 14
ActDesc.Font = Enum.Font.Gotham
ActDesc.TextWrapped = true
ActDesc.ZIndex = 21
ActDesc.Parent = Overlay

local ProgressBarBg = Instance.new("Frame")
ProgressBarBg.Size = UDim2.new(0.8, 0, 0, 8)
ProgressBarBg.Position = UDim2.new(0.1, 0, 0, 310)
ProgressBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ProgressBarBg.ZIndex = 21
ProgressBarBg.Parent = Overlay
Instance.new("UICorner", ProgressBarBg).CornerRadius = UDim.new(1, 0)

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = linkColor
ProgressBarFill.ZIndex = 22
ProgressBarFill.Parent = ProgressBarBg
Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(1, 0)

local bypassConnection = nil

local function ShowBypass(callback)
    Overlay.Visible = true
    ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
    spinTween:Play()
    
    local waitTime = math.random(10, 120) 
    
    local fillTween = TweenService:Create(ProgressBarFill, TweenInfo.new(waitTime, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    fillTween:Play()
    
    if bypassConnection then bypassConnection:Disconnect() end
    bypassConnection = fillTween.Completed:Connect(function()
        Overlay.Visible = false
        spinTween:Pause()
        if callback then callback() end
    end)
end

local function ClearSubMenu()
    for _, child in pairs(SubMenuContent:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end
end

local function CreateToggle(parent, text)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, 0, 0, 50)
    Panel.BackgroundColor3 = panelDark
    Panel.ZIndex = 3
    Panel.Parent = parent
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 12)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 200, 1, 0)
    Lbl.Position = UDim2.new(0, 20, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = textGray
    Lbl.TextSize = 12
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 4
    Lbl.Parent = Panel

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 4
    ToggleBtn.Parent = Panel
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 4, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Circle.ZIndex = 5
    Circle.Parent = ToggleBtn
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        if not toggled then
            ShowBypass(function()
                toggled = true
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = textWhite}):Play()
                TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            end)
        else
            toggled = false
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
        end
    end)
end

local function CreateSingleButton(parent, text)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 50)
    Btn.BackgroundColor3 = textWhite
    Btn.Text = text
    Btn.TextColor3 = bgDark
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamBold
    Btn.ZIndex = 3
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)
end

local function CreateDualButtons(parent, text1, text2)
    local ContainerFrame = Instance.new("Frame")
    ContainerFrame.Size = UDim2.new(1, 0, 0, 50)
    ContainerFrame.BackgroundTransparency = 1
    ContainerFrame.ZIndex = 3
    ContainerFrame.Parent = parent

    local Btn1 = Instance.new("TextButton")
    Btn1.Size = UDim2.new(0.48, 0, 1, 0)
    Btn1.BackgroundColor3 = textWhite
    Btn1.Text = text1
    Btn1.TextColor3 = bgDark
    Btn1.TextSize = 12
    Btn1.Font = Enum.Font.GothamBold
    Btn1.ZIndex = 4
    Btn1.Parent = ContainerFrame
    Instance.new("UICorner", Btn1).CornerRadius = UDim.new(0, 12)

    local Btn2 = Instance.new("TextButton")
    Btn2.Size = UDim2.new(0.48, 0, 1, 0)
    Btn2.Position = UDim2.new(0.52, 0, 0, 0)
    Btn2.BackgroundColor3 = textWhite
    Btn2.Text = text2
    Btn2.TextColor3 = bgDark
    Btn2.TextSize = 12
    Btn2.Font = Enum.Font.GothamBold
    Btn2.ZIndex = 4
    Btn2.Parent = ContainerFrame
    Instance.new("UICorner", Btn2).CornerRadius = UDim.new(0, 12)
end

local function CreateSlider(parent, text)
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, 0, 0, 70)
    Panel.BackgroundColor3 = panelDark
    Panel.ZIndex = 3
    Panel.Parent = parent
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 12)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 200, 0, 30)
    Lbl.Position = UDim2.new(0, 20, 0, 10)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = textGray
    Lbl.TextSize = 12
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 4
    Lbl.Parent = Panel

    local SliderBg = Instance.new("TextButton")
    SliderBg.Size = UDim2.new(1, -40, 0, 4)
    SliderBg.Position = UDim2.new(0, 20, 0, 50)
    SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    SliderBg.Text = ""
    SliderBg.AutoButtonColor = false
    SliderBg.ZIndex = 4
    SliderBg.Parent = Panel
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    SliderFill.BackgroundColor3 = textWhite
    SliderFill.ZIndex = 5
    SliderFill.Parent = SliderBg
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(1, -7, 0.5, -7)
    Knob.BackgroundColor3 = textWhite
    Knob.ZIndex = 6
    Knob.Parent = SliderFill
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
    end

    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

local menuData = {
    ["FREEZE DUEL"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["FREEZE TRADE"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["SEMI TP"] = { {type="toggle", text="ВКЛЮЧИТЬ"}, {type="dual_btn", text1="LEFT TP", text2="RIGHT TP"} },
    ["FLASH TP"] = { {type="toggle", text="ВКЛЮЧИТЬ"}, {type="single_btn", text="TP AND INSTANT GRAB"} },
    ["DESYNC"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["INSTANT STEAL"] = { {type="toggle", text="ВКЛЮЧИТЬ"} },
    ["TP BLOCK"] = { {type="toggle", text="ВКЛЮЧИТЬ"}, {type="toggle", text="БАНИТЬ (ДА/НЕТ)"} },
    ["BEST AUTOGRAB"] = { {type="toggle", text="ВКЛЮЧИТЬ"}, {type="slider", text="СКОРОСТЬ"} }
}

local orderedMenus = {"FREEZE DUEL", "FREEZE TRADE", "SEMI TP", "FLASH TP", "DESYNC", "INSTANT STEAL", "TP BLOCK", "BEST AUTOGRAB"}

for _, name in ipairs(orderedMenus) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 55)
    Btn.BackgroundColor3 = panelDark
    Btn.Text = ""
    Btn.ZIndex = 3
    Btn.Parent = ScrollFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0, 200, 1, 0)
    Lbl.Position = UDim2.new(0, 20, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = name
    Lbl.TextColor3 = textWhite
    Lbl.TextSize = 14
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.ZIndex = 4
    Lbl.Parent = Btn

    local OpenText = Instance.new("TextLabel")
    OpenText.Size = UDim2.new(0, 50, 1, 0)
    OpenText.Position = UDim2.new(1, -70, 0, 0)
    OpenText.BackgroundTransparency = 1
    OpenText.Text = "OPEN"
    OpenText.TextColor3 = Color3.fromRGB(80, 80, 90)
    OpenText.TextSize = 11
    OpenText.Font = Enum.Font.GothamBold
    OpenText.ZIndex = 4
    OpenText.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        SubMenuTitle.Text = name
        ClearSubMenu()
        
        for _, item in ipairs(menuData[name]) do
            if item.type == "toggle" then
                CreateToggle(SubMenuContent, item.text)
            elseif item.type == "single_btn" then
                CreateSingleButton(SubMenuContent, item.text)
            elseif item.type == "dual_btn" then
                CreateDualButtons(SubMenuContent, item.text1, item.text2)
            elseif item.type == "slider" then
                CreateSlider(SubMenuContent, item.text)
            end
        end

        MainFrame.Visible = false
        SubMenuFrame.Visible = true
    end)
end
