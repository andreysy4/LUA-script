---------------------------------------------------
----- Script created for GameGuardian 89.1 --------
----- Lua help: http://gameguardian.net/help/ -----
---------------------------------------------------
local scriptName = [=====[HP freezer]=====]
local scriptVersion = '0.0.1'
local scriptAuthor = 'Andrey'
gg.require('89.0')
gg.toast(scriptName..' v'..scriptVersion..' by '..scriptAuthor)

function inputHP(massage)
	local resTable
	while resTable == nil do
		resTable = gg.prompt({massage}, {value}, {'number'})
	end
	return resTable[1]
end

function sleepScript()
	while not gg.isVisible() do
		gg.sleep(100)
	end
end

function readFromFile()
	file = io.open("Saves.txt", "r")
	first = file:read "*l"
	second = file:read "*l"
	file:close()
	return first, second
end

function saveToFile(startHP, newHP)

end

---------------------------------------------------
---------------------   Main   --------------------
---------------------------------------------------
local startHP = 0
local newHP = 0

local status, startHP_S, newHP_S = pcall(readFromFile)
if status then
	startHP = tonumber(startHP_S) and tonumber(startHP_S) or 0
	newHP = tonumber(newHP_S) and tonumber(newHP_S) or 0
else
	startHP = 0
	newHP = 0
end	

gg.clearResults()
gg.clearList()	

gg.processPause()
startHP = inputHP('Начальное количество HP:')
gg.searchNumber(startHP, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.processResume()
gg.setVisible(false)
gg.toast('Измените кол. HP, а затем откройте GG')

while true do
	sleepScript()
	gg.processPause()
	newHP = inputHP('Изменнённое значение HP:')
	gg.searchNumber(newHP, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
	if gg.getResultCount() < 5 then
		break
	end
	gg.processResume()
	gg.setVisible(false)
	gg.toast('Результатов слишком много. Ещё немного измените HP')
end

local resTable = gg.getResults(5, nil, nil, nil, nil, nil, nil, nil, nil)
for i, v in ipairs(resTable) do --gg.getResultCount()
	resTable[i].value = startHP
	resTable[i].freeze = true
end
gg.addListItems(resTable)
gg.processResume()
gg.setVisible(false)
gg.toast('Бесконечное здоровье успешно активировано')












