
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
    local SORT_DESCENDING = function(totals, fisha, fishb) return totals[fishb] < totals[fisha] end
    index = 1
    for fish, qty in FLL.table.sorted_iter(Fishage.db.data.totals, SORT_DESCENDING) do
        local msg = string.format("%d\. %s : %d", index, fish, qty)
        Fishage.logger(msg)
        index = index + 1
    end
end


-- TODO: Tracking namespace?
-- Events
-- 
Fishage.eventHistory = {}
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


