-- Script created for GameGuardian 89.1
-- Lua help: http://gameguardian.net/help/

-- options
local scriptName = [=====[HP freezer]=====]
local scriptVersion = '0.0.0'
local scriptAuthor = 'Andrey'

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



-- init
gg.require('89.0')
gg.toast(scriptName..' v'..scriptVersion..' by '..scriptAuthor)

-- main code
local startHP = 0
local newHP = 0

--while 1 do
	sleepScript()
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
	t = gg.getResults(5, nil, nil, nil, nil, nil, nil, nil, nil)
	gg.editAll(startHP, gg.TYPE_DWORD)
	t[1].freeze = true
	--gg.clearResults()
	gg.setVisible(false)
	gg.toast('Бесконечное здоровье успешно активировано')
--end













