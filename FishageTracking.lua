
-- 
-- Stats Function - May one day be a UI!
-- 
Fishage.slashcmds["stats"] = function(msg, editBox)
    local SORT_DESCENDING = function(totals, fisha, fishb) return totals[fishb] < totals[fisha] end
    index = 1
    for fish, qty in FLL.table.sorted_iter(Fishage.db.Totals.Overall, SORT_DESCENDING) do
        local msg = string.format("%d\. %s : %d", index, fish, qty)
        Fishage.logger(msg)
        index = index + 1
    end
end

Fishage.slashcmds["zstats"] = function(msg, editBox)
    for zone, fishes in pairs(Fishage.db.Totals.byZone) do
        Fishage.logger("Zone: "..zone)
        Fishage.logger("==================================")
        index = 1
        local SORT_DESCENDING = function(totals, fisha, fishb) return totals[fishb] < totals[fisha] end
        for fish, qty in FLL.table.sorted_iter(fishes, SORT_DESCENDING) do
            local msg = string.format("%d\. %s : %d", index, fish, qty)
            Fishage.logger(msg)
            index = index + 1
        end
    end
end

-- 
-- Data handling functions
-- Fishage.db = { Sessions: {}, Totals : {} }
--     Session = { StartTime:ts, EndTime:ts, Zone:str, Subzone:str, Catches: {} }
--     Totals = { Overall: {Catches:{}}, 
--                byZone: {Subzone: Catches:{}}, 
--                bySkill: {Skilllevel: Catches:{}} }
--         Catch = { Fish:  Quantity:int }
Fishage.tracking = {}

-- Util
-- TODO: Doesn't work on classic 
Fishage.tracking.get_fishing_skill = function()
    --local currentSkillLevel = 0
    --local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
    --if (fishing ~= nil) then 
    --    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(index)
    --    currentSkillLevel = skillLevel
    --end
    for i = 2,4,1 do
        local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(4)
        Fishage.logger("Index "..i)
        Fishage.logger("Skill "..name)
        Fishage.logger(" level "..skillLevel)
    end
    return skillLevel
end

-- Lookup
Fishage.tracking.get_totals_overall = function()
end

Fishage.tracking.get_totals_byzone = function(zone)
end

Fishage.tracking.get_totals_byskill = function(zone)
end

-- Insert 
Fishage.tracking.add_totals_overall = function(loot, qty)
    local Overall = Fishage.db.Totals.Overall
    if (Overall[loot] == nil) then Overall[loot] = 0 end
    Overall[loot] = Overall[loot] + qty
    Fishage.logger(" Logged overall loot: "..loot.." : "..qty)
end

Fishage.tracking.add_totals_byzone = function(loot, qty, zone, subzone)
    local byZone = Fishage.db.Totals.byZone
    local key = zone
    if (subzone ~= "") then key = key.."-"..subzone end

    if (byZone[key] == nil) then byZone[key] = {} end
    if (byZone[key][loot] == nil) then byZone[key][loot] = 0 end

    byZone[key][loot] = byZone[key][loot] + qty
    Fishage.logger(" Logged byZone loot: "..key.." = "..loot.." : "..qty)
end

Fishage.tracking.add_totals_byskill = function(loot, qty, skill)
    local bySkill = Fishage.db.Totals.bySkill
    local key = tostring(skill)

    if (bySkill[key] == nil) then bySkill[key] = {} end
    if (bySkill[key][loot] == nil) then bySkill[key][loot] = 0 end

    bySkill[key][loot] = bySkill[key][loot] + qty
    Fishage.logger(" Logged bySkill loot: "..key.." = "..loot.." : "..qty)
end

Fishage.tracking.add_catch = function(catch)
    -- Need Zone, Subzone, Skilllevel for tracking
    local zone = GetRealZoneText()
    local subzone = GetSubZoneText()
    -- local skill = Fishage.tracking.get_fishing_skill()

    -- A catch can have more than one piece of loot 
    for _, loot in ipairs(catch) do
        Fishage.tracking.add_totals_overall(loot.item, loot.quantity)
        Fishage.tracking.add_totals_byzone(loot.item, loot.quantity, zone, subzone)
        -- Fishage.tracking.add_totals_byskill(loot.item, loot.quantity, skill)
    end
end

-- !? Sessions?!
-- create 
-- lookup
Fishage.tracking.get_session = function(index) 
end
-- insert
-- delete 

-- 
-- Events
-- 
Fishage.eventHistory = {} -- Debug list 
Fishage.events["LOOT_OPENED"] = function(self, event, ...)
    if (not IsFishingLoot()) then return end 
    local catch = GetLootInfo()
    table.insert(Fishage.eventHistory, catch)
    Fishage.tracking.add_catch(catch)
end

-- TODO: Need this one day to do group stuff, need to figure out a way to do it right
--   Could do it with addon broadcasts from the LOOT_OPENED event, but... it requires everyone to have the addon
--Fishage.events["CHAT_MSG_LOOT"] = function(self, event, ...)	
--    local text = select(1, ...) 	
--    local playerName = select(2, ...)	
--    local playerName2 = select(5, ...)	
--    local itemId = string.match(text, ".*item:(%w+)::")	
--    Fishage.logger(" ID="..itemId)	
--end	

