--
-- Addon Initialization
-- 
Fishage = {}
Fishage.db = {}
Fishage.db.data = { sessions = {}, totals = {} }
Fishage.events = {}
Fishage.slashcmds = {}


--
-- Callbacks
--

-- RegisterEvents at OnLoad
Fishage.RegisterEvents = function(self) 
    for event_name, callback in pairs(Fishage.events) do
        self:RegisterEvent(event_name)
    end
end

-- Load saved variables from addon memeory
Fishage.events["PLAYER_LOGOUT"] = function(self)
    FISHAGE_DATABASE = Fishage.db.data 
end

-- Load saved variables from addon memeory
Fishage.events["ADDON_LOADED"] = function(self)
    if (FISHAGE_DATABASE ~= nil) then
        Fishage.db.data = FISHAGE_DATABASE
    end
end

-- When addon loaded for the first time in the session
Fishage.OnLoad = function(self)
    SendSystemMessage("Fishage 1.0 Loaded")
    Fishage.RegisterEvents(self)
end

-- Callback for all registered events 
Fishage.OnEvent = function(self, event, ...)
    if (Fishage.events[event] ~= nil) then
        Fishage.events[event](self, event, ...)
    end
end

-- Slash Command callback handler 
SLASH_FISHAGE1, SLASH_FISHAGE2 = '/fsh', '/fishage'
function SlashCmdList.FISHAGE(msg, editBox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")
    if (Fishage.slashcmds[command] ~= nil) then
        Fishage.slashcmds[command](rest, editBox)
    end
end

-- Logger functions
Fishage.debug = false
Fishage.slashcmds["debug"] = function(msg, editBox)
    Fishage.debug = not Fishage.debug
end

Fishage.logger = function(msg)
    local ts = date("%H:%M:%S")
    print("|cFF0000FF Fishage |r ["..ts.."] "..msg)

end


