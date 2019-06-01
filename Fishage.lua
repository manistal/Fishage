
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
Fishage.eventHistory = {}
Fishage.events["CHAT_MSG_LOOT"] = function(self, event, ...)
    local text = select(1, ...) 
    local playerName = select(2, ...)
    local playerName2 = select(5, ...)
    local itemId = string.match(text, ".*item:(%w+)::")
    local itemName = string.match(text, "[%w+]")
    SendSystemMessage(" ID="..itemId.." name="..itemName)
    table.insert(Fishage.eventHistory, text)

    -- Check if its a fish
    if (FISHAGE_FISH_DATA[itemId] ~= nil) then
        SendSystemMessage("Its a fish! "..FISHAGE_FISH_DATA[itemId]["Name"])
    end
end

Fishage.events["LOOT_ITEM_AVAILABLE"] = function(self, event, ...)
    local itemTooltip = select(1, ...)
    local lootHandle = select(2, ...)
    SendSystemMessage(" Tip="..itemTooltip.." lH="..lootHandle)
end
