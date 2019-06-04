
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
