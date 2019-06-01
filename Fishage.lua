
--
-- Addon Initialization
-- 
Fishage = {};
Fishage.RegisterEvents = function(self) 
    for event_name, callback in pairs(Fishage.events) do
        self:RegisterEvent(event_name)
        SendSystemMessage(event_name)
    end
end

Fishage.OnLoad = function(self)
    SendSystemMessage("Fishage 1.0 Loaded")
    Fishage.RegisterEvents(self)
end

Fishage.OnEvent = function(self, event, ...)
    SendSystemMessage(event)
    if (Fishage.events[event] ~= nil) then
        Fishage.events[event](self, event, ...)
    end
end

-- 
-- Events
-- 
Fishage.events = {}
Fishage.events["CHAT_MSG_LOOT"] = function(self, event, ...)
    local text = select(1, ...) 
    local playerName = select(2, ...)
    SendSystemMessage(" P="..playerName.." T="..text)
end
