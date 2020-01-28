-- Скрипт для Archaro. AndreySy4
--
-- Можно использовать и другие методы для работы с экраном:
--		"click", "longClick", "doubleClick", "continueClick", "swipe", "dragDrop"
--		все эти методы работают через manualTouch(actionTable) с обвязкой.
-- manualTouch(actionTable) - основная функция работы с экраном. Основана на примитивах:
-- 		touchDown(), touchMove(), touchUp(), wait().
-- manualTouch(Табл) принемает в качестве аргумента таблицу действий.
-- Можно использовать низкоуровневые команды (touchDown и др), но
--		они работают медленней (из-за постоянного запроса получения Root).
-- manualTouch запрашивает Root 1 раз для всей таблицы.

version = "1.0.2"
eR = 5															-- Ошибка цвета пикселя (Color +- eR)

function setTimes()
	dialogInit()
    addTextView("Replay count. 0 to infinity: ")
    addEditNumber("times", 0)
    newRow()

    addTextView("Delay in seconds: ")
    addEditNumber("gap", 1)
    newRow()
    dialogShow("Settings")
end

function colorTest(expR, expG, expB, x, y)
	local r, g, b = getColor(Location(x, y))
	if (expR + eR > r and r > expR - eR
		and expG + eR > g and g > expG - eR
		and expB + eR > b and b > expB - eR) then
			return true
	end
	return false
end

function mainActivity()
	local actionList
	-- setManualTouchParameter - плавность движения. 1мс wait каждые 5 пикселей
	setManualTouchParameter(5, 1)
	
	actionList = {												-- Ускорить время через GG
		{action = "touchDown", target = Location(690, 145)},
		{action = "touchUp", target = Location(690, 145)}	
	}
	manualTouch(actionList)

	while not colorTest(117, 252, 28, 380, 125) do				-- Ждём заполнения стамины		
		wait(0.1)
	end

	actionList = {												-- Замедлить время через GG
		{action = "touchDown", target = Location(1020, 145)},
		{action = "touchUp", target = Location(1020, 145)}	
	}
	manualTouch(actionList)

	-- Кнопка игры
	if (colorTest(248, 54, 45, 690, 1750)) then
		actionList = {
			{action = "touchDown", target = Location(690, 1750)},
			{action = "touchUp", target = Location(690, 1750)}
		}
		manualTouch(actionList)
	end	
	
	while not (colorTest(0, 82, 174, 525, 2000)) do				-- Ждём возможности передвигаться
		wait(0.1)
		actionList = {											-- Выбрать центральную способность
			{action = "touchDown", target = Location(435, 1630)},
			{action = "touchUp", target = Location(435, 1630)}
		}
		manualTouch(actionList)
	end
	
	actionList = {												-- Двигаемся к колесу удачи
		{action = "touchDown", target = Location(525, 2000)},
		{action = "touchMove", target = Location(525, 1600)}
	}
	manualTouch(actionList)
	
	-- Ожидаем колесо удачи
	while not (colorTest(254, 197, 20, 670, 1765)) do
		wait(0.1)
	end
	actionList = {
		{action = "touchUp", target = Location(670, 1765)},
		{action = "touchDown", target = Location(850, 145)},	-- Открыть GG
		{action = "touchUp", target = Location(850, 145)},
		{action = "wait", target = 0.4},
		{action = "touchDown", target = Location(235, 1215)},	-- Перезапустить скрипт GG
		{action = "touchUp", target = Location(235, 1215)}
	}
	manualTouch(actionList)

	-- Ожидаем колесо удачи
	while not (colorTest(254, 197, 20, 670, 1765)) do
		wait(0.1)
	end
	actionList = {
		{action = "touchDown", target = Location(670, 1765)},	-- Тыкнуть по колесу удачи
		{action = "touchUp", target = Location(670, 1765)}
	}
	manualTouch(actionList)

	while not (colorTest(0, 82, 174, 525, 2000)) do				-- Ждём возможности передвигаться
		wait(0.1)
	end
	actionList = {
		{action = "touchDown", target = Location(525, 2000)},	-- Движемся в соседнюю комнату
		{action = "touchMove", target = Location(525, 1600)}
	}
	manualTouch(actionList)

	while not colorTest(0, 0, 0, 900, 2000) do 					-- Ждём следующую комнату
		wait(0.1)
	end
	actionList = {
		{action = "touchUp", target = Location(525, 2000)},		-- Останавливаем персонажа
		{action = "touchDown", target = Location(525, 2000)}	
	}
	manualTouch(actionList)

	while not colorTest(248, 54, 45, 690, 1750) do				-- Ждём начального экрана
		actionList = {
			{action = "touchDown", target = Location(910, 1800)},	-- Нажать на пустое место
			{action = "touchUp", target = Location(910, 1800)},
		}
		manualTouch(actionList)
		wait(0.2)
	end
end

-- main
local dec = 1
setTimes()
toast ("Times = " .. times .. ", gap = "..gap)
if times == 0 then
	dec = 0
end

local i = times
while i > -1 do
	mainActivity()
	toast ("Success !")
	wait(gap)
	i = i - dec;
end