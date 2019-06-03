
--  TODO: Move to FishageUI Namespace 
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

Fishage.slashcmds["stats"] = function(msg, editBox)
    local function log_pairs(k, v) Fishage.logger(" k="..k.." v="..tostring(v)) end
    Fishage.logger("huh")
    FLL.table.apply(Fishage.db.data.totals, log_pairs)
end


-- TODO: Tracking namespace?
-- Events
-- 
Fishage.eventHistory = {}
--Fishage.events["CHAT_MSG_LOOT"] = function(self, event, ...)
--    local text = select(1, ...) 
--    local playerName = select(2, ...)
--    local playerName2 = select(5, ...)
--    local itemId = string.match(text, ".*item:(%w+)::")
--    -- local itemName = string.match(text, ".*\[(%w+)\]|h|r")
--    Fishage.logger(" ID="..itemId)
--    -- Fishage.logger(" name="..itemName)
--end

Fishage.db.log_catch = function(loot)
    local catch = loot.item
    local qty = loot.quantity 

    -- Totals
    if (Fishage.db.data.totals[catch] ~= nil) then
        Fishage.db.data.totals[catch] = qty + Fishage.db.data.totals[catch]
    else
        Fishage.db.data.totals[catch] = qty
    end
    Fishage.logger(" Logged catch: c="..catch.." q="..qty)
    -- Session?
end

Fishage.events["LOOT_OPENED"] = function(self, event, ...)
    if (not IsFishingLoot()) then return end 
    local lootInfo = GetLootInfo()
    for _, catch in ipairs(lootInfo) do
        table.insert(Fishage.eventHistory, catch)
        Fishage.db.log_catch(catch)
    end
end


