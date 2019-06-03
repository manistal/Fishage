
-- 
-- Meter show/hide functions
-- 
Fishage.slashcmds["hide"] = function(msg, editBox)
    FishageMeter:Hide()
end

Fishage.slashcmds["show"] = function(msg, editBox)
    FishageMeter:Show()
end

Fishage.slashcmds[""] = function(msg, editBox)
    if FishageMeter:IsShown() then
        FishageMeter:Hide()
    else
        FishageMeter:Show()
    end
end

-- 
-- Events
-- 
Fishage.eventHistory = {}
Fishage.events["CHAT_MSG_LOOT"] = function(self, event, ...)
    local text = select(1, ...) 
    local playerName = select(2, ...)
    local playerName2 = select(5, ...)
    local itemId = string.match(text, ".*item:(%w+)::")
    local itemName = string.match(text, "\[(%w+)\]")
    Fishage.logger(" ID="..itemId)
    Fishage.logger(" name="..itemName)
    table.insert(Fishage.eventHistory, text)
end

-- https://wow.gamepedia.com/LOOT_OPENED
-- https://wow.gamepedia.com/API_GetLootInfo
-- https://wow.gamepedia.com/API_IsFishingLoot
local function log_pairs(k, v) Fishage.logger(" k="..k.." v="..tostring(v)) end
Fishage.events["LOOT_OPENED"] = function(self, event, ...)
    if (not IsFishingLoot()) then return end 
    local lootInfo = GetLootInfo()
    FLL.table.apply(lootInfo, log_pairs)
    -- SendSystemMessage(" Name="..lootInfo.name)
end


