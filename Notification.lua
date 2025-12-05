local NotificationFunctions = {};
local cloneref = cloneref or function(o) return o end;

local TweenService = cloneref(game:GetService('TweenService'));
local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);
local CoreGui = gethui or (function() return game:GetService('CoreGui') end);
local NotificationLibrary, NotificationTemplates, NotificationList;

local function generateString()
    local chars = {};
    for i = 1, math.random(0, 122) do
        chars[i] = string.char(math.random(0, 122));
    end;
    return table.concat(chars);
end;

function NotificationFunctions:Load()
    NotificationLibrary = game:GetObjects('rbxassetid://15133757123')[1];
    NotificationTemplates = NotificationLibrary.Templates;
    NotificationList = NotificationLibrary.list;
    NotificationLibrary.Name = generateString();
    NotificationLibrary.Parent = CoreGui;
    ProtectGui(NotificationLibrary);
end;

function NotificationFunctions:SendNotification(Mode, Text, Duration)
    if not CoreGui:FindFirstChild(generateString()) then
        NotificationFunctions:Load();
    else
        NotificationLibrary = CoreGui:FindFirstChild(generateString());
        NotificationTemplates = NotificationLibrary.Templates;
        NotificationList = NotificationLibrary.list;
    end

    if NotificationTemplates:FindFirstChild(Mode) then
        task.spawn(function()
            local success, err = pcall(function()
                local Notification = NotificationTemplates:WaitForChild(Mode):Clone();
                local filler = Notification.Filler;
                local bar = Notification.bar;
                Notification.Header.Text = Text;
                
                Notification.Visible = true;
                Notification.Parent = NotificationList;
    
                Notification.Size = UDim2.new(0, 0,0.087, 0);
                filler.Size = UDim2.new(1, 0,1, 0);
        
                local T1 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                local T2 = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                local T3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            
                TweenService:Create(Notification, T1, {Size = UDim2.new(1, 0,0.087, 0)}):Play();
                task.wait(0.2);
                TweenService:Create(filler, T3, {Size = UDim2.new(0.011, 0,1, 0)}):Play();
            
                TweenService:Create(bar, T2, {Size = UDim2.new(1, 0,0.05, 0)}):Play();
            
                task.wait(Duration);
            
                TweenService:Create(filler, T1, {Size = UDim2.new(1, 0,1, 0)}):Play();
                task.wait(0.25);
                TweenService:Create(Notification, T3, {Size = UDim2.new(0, 0,0.087, 0)}):Play();
                task.wait(0.25);
                Notification:Destroy();
            end);
        end);
    end;
end;


return NotificationFunctions;