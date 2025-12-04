if not LPH_OBFUSCATED then
    LPH_NO_VIRTUALIZE = function(f) return f end;
    LPH_JIT = function(f) return f end;
    LPH_CRASH = function() while true do end end;
end;

local hookManager = {};
hookManager.entries = {};

function hookManager:hook(label, func, replacement)
    local entry = {};
    
    if not islclosure(func) then
        entry.func = func;
        entry.old = hookfunction(func, replacement);
    else
        local funcEnv = getfenv(func);
        local env = setmetatable({hook = replacement}, {
            __index = funcEnv,
            __newindex = funcEnv,
        });
        
        entry.func = func;
        entry.old = hookfunction(func, setfenv(LPH_NO_VIRTUALIZE(function(...)
            return hook(...);
        end), env));
    end;
    
    self.entries[label] = entry;
    return entry.old;
end;

function hookManager:dispose()
    for label, entry in pairs(self.entries) do
        hookfunction(entry.func, entry.old);
    end;
    table.clear(self.entries);
end;

return hookManager;