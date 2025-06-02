-- إعداد المتغيرات
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- متغير لتشغيل/إيقاف الضرب
local AttackEnabled = false

-- تحميل الصورة للزر
local buttonImageUrl = "https://cdn.discordapp.com/attachments/1378469118935695501/1379132477515501670/bf8dac5f342138228cb69fdcdc909265-23219524.jpg"

-- إنشاء الـ ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoAttackGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- زر صغير لفتح/إغلاق القائمة
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0,50,0,50)
ToggleButton.Position = UDim2.new(0,10,0.5,-25)
ToggleButton.Image = buttonImageUrl
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.AutoButtonColor = true

-- القائمة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0, 70, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 85, 255)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Visible = false

-- زر تشغيل الضرب
local StartButton = Instance.new("TextButton")
StartButton.Parent = MainFrame
StartButton.Size = UDim2.new(0, 230, 0, 50)
StartButton.Position = UDim2.new(0, 10, 0, 20)
StartButton.Text = "تشغيل الضرب"
StartButton.TextColor3 = Color3.new(1,1,1)
StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.TextSize = 22

-- زر إيقاف الضرب
local StopButton = Instance.new("TextButton")
StopButton.Parent = MainFrame
StopButton.Size = UDim2.new(0, 230, 0, 50)
StopButton.Position = UDim2.new(0, 10, 0, 85)
StopButton.Text = "إيقاف الضرب"
StopButton.TextColor3 = Color3.new(1,1,1)
StopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 22

-- تفعيل/إيقاف القائمة عند الضغط على الزر الصغير
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- وظيفة ضرب الموبات بسرعة
local function AutoAttack()
    spawn(function()
        while AttackEnabled do
            -- محاولة إيجاد أقرب موب
            local closestMob = nil
            local shortestDistance = math.huge
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    local distance = (mob.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance and distance < 100 then
                        shortestDistance = distance
                        closestMob = mob
                    end
                end
            end

            if closestMob then
                -- إرسال ريموت الضرب
                local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
                remote:FireServer("Attack", closestMob)
            end

            wait(0.001) -- سرعة الضرب
        end
    end)
end

-- زر تشغيل الضرب
StartButton.MouseButton1Click:Connect(function()
    if not AttackEnabled then
        AttackEnabled = true
        AutoAttack()
    end
end)

-- زر إيقاف الضرب
StopButton.MouseButton1Click:Connect(function()
    AttackEnabled = false
end)