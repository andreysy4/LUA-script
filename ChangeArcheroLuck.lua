-- Script created for GameGuardian 89.1
-- Lua help: http://gameguardian.net/help/

-- options
local scriptName = [=====[Search and fill]=====]
local scriptVersion = '1.0.1'
local scriptAuthor = 'Andrey'
local sequence = "4000;2800;2800;2200;2200;2200::512"
local value = "20000"

-- init
gg.require('89.0')
gg.toast(scriptName..' v'..scriptVersion..' by '..scriptAuthor)

-- main code
gg.processPause()	
gg.searchNumber(sequence, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
gg.editAll(value, gg.TYPE_DWORD)
gg.clearResults()
gg.setVisible(false)
gg.processResume()