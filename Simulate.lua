local SimulateLib = {}

local ServiceLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/AccountCelestial/Utility/refs/heads/main/Services.lua'))()

local VIM, GuiService, Players, VirtualUser, CurrentCamera = ServiceLib:Get('VirtualInputManager', 'GuiService', 'Players', 'VirtualUser')
local LocalPlayer = Players.LocalPlayer

function SimulateLib:ClickButton(target, eventName, mode)
    if mode == 'firesignal' and firesignal and target and target[eventName] then
        local ok, err = pcall(function() firesignal(target[eventName]) end)
        if not ok then warn('firesignal error: ', err) end
    elseif mode == 'replicatesignal' and replicatesignal and target and target[eventName] then
        local ok, err = pcall(function() replicatesignal(target[eventName]) end)
        if not ok then warn('replicatesignal error: ', err) end
    elseif mode == 'vim' and target and target[eventName] then
        local ok, err = pcall(function()
            GuiService.SelectedObject = target
            task.wait()
            VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait()
            VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait()
            GuiService.SelectedObject = nil
        end)
        if not ok then warn('VIM MosueClick error: ', err) end
    elseif mode == 'getconnections' and getconnections and target and target[eventName] then
        for _, v in pairs(getconnections(target[eventName])) do
            if v.Function then 
                local ok, err = pcall(v.Function) 
                if not ok then warn('Function error: ', err) end
            end
            if v.Fire then 
                local ok, err = pcall(function() v:Fire() end) 
                if not ok then warn('Fire error: ', err) end
            end
        end
    end
end

function SimulateLib:SendKeyEvent(state, key)
    local ok, err = pcall(function()
        VIM:SendKeyEvent(state, Enum.KeyCode[key], false, game)
    end)
    if not ok then warn('VIM SendKeyEvent error: ', err) end
end

function SimulateLib:SendMouseEvent(state)
    local ok, err = pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, state, game, 0)
    end)
    if not ok then warn('VIM SendMouseEvent error: ', err) end
end

function SimulateLib:Fire(target, mode)
    if mode == 'fireproximityprompt' and fireproximityprompt and target then
        local ok, err = pcall(function()
            fireproximityprompt(target)
        end)
        if not ok then warn('fireproximityprompt error: ', err) end
    elseif mode == 'fireclickdetector' and fireclickdetector and target then
        local ok, err = pcall(function()
            fireclickdetector(target)
        end)
        if not ok then warn('fireclickdetector error: ', err) end
    elseif mode == 'firetouchinterest' and firetouchinterest and target then
        local hrp = LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
        local ok, err = pcall(function()
            firetouchinterest(hrp, target, 0)
            task.wait()
            firetouchinterest(hrp, target, 1)
        end)
        if not ok then warn('firetouchinterest error: ', err) end
    end
end

local afkConnect = nil

function SimulateLib:PlayerConnect(state, mode)
    if mode == 'afk' then
        if state then
            afkConnect = LocalPlayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0,0), CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), CurrentCamera.CFrame)
            end)
        else
            if afkConnect then
                afkConnect:Disconnect()
                afkConnect = nil
            end
        end
    end
end

return SimulateLib
