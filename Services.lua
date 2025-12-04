local Services = {};
local vim = getvirtualinputmanager and getvirtualinputmanager();

if not vim then
    pcall(function()
        local v = game:GetService('VirtualInputManager');
        if v then
            vim = v;
        end;
    end);
end;

function Services:Get(...)
    local result = {};
    local args = {...};

    for i = 1, #args do
        result[i] = self[args[i]];
    end;

    return unpack(result);
end;

setmetatable(Services, {
    __index = function(self, key)
        if key == 'VirtualInputManager' and vim then
            return vim;
        end;

        if key == 'CurrentCamera' then
            return workspace.CurrentCamera;
        end;

        local ok, service = pcall(game.GetService, game, key);

        if ok and service then
            rawset(self, key, service); 
            return service;
        end;

        return nil;
    end;
});

return Services;
