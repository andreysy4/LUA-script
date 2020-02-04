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

VERSION = "1.0.2"
ERROR_RANGE = 5													-- Ошибка цвета пикселя (Color +- ERROR_RANGE)
MAX_ITER = 1000000												-- Максимальная длинна циклов while
WAIT_TIME = 0.05												-- Задержка перед очередной итерацией поиска
GAME_PACK_NAME = "com.habby.archero"							-- Имя пакета Archaro
ANKULUA_PACK_NAME = "com.appautomatic.ankulua.pro2"				-- Имя пакета AnkuLua
GG_PACK_NAME = "com.blwxahnttq"									-- Имя пакета GameGuardian

--[[ Функция ввода переменных пользователем. Т.к. они глобальные, то сохраняются после перезапуска ]]
function setProperties()
	dialogInit()
    addTextView("  Повторов. 0 - бесконечно: ")
    addEditNumber("times", 0)
    newRow()
    addTextView("  Время ожидания перед повтором: ")
    addEditNumber("gap", 1)
    newRow()
	
	addSeparator()
	addTextView("  Имя пакета Archaro: ")
	newRow()
	addEditText("GAME_PACK_NAME", "com.habby.archero")
	newRow()
	addTextView("  Имя пакета AnkuLua: ")
	newRow()
	addEditText("ANKULUA_PACK_NAME", "com.appautomatic.ankulua.pro2")
	newRow()
	addTextView("  Имя пакета GameGuardian: ")
	newRow()
	addEditText("GG_PACK_NAME", "com.blwxahnttq")
	newRow()
	
	addSeparator()
	addTextView("  МАКС итераций поиска пикселя: ")
	addEditNumber("MAX_ITER", 1000000)
	newRow()
	addTextView("  Задержка поиска: ")
	addEditNumber("WAIT_TIME", 0.05)
	newRow()
	addTextView("  Погрешность цвета: ")
	addEditNumber("ERROR_RANGE", 5)
	newRow()
	
	dialogShow("Settings. Version: "..VERSION)
end

--[[ Функция сравнения ожидаемого цвета пикселя с его фактическим + погрешность (ERROR_RANGE)
--   Принемает: 	expR, expG, expB - ожидаемый цвет канала пикселя 0..256
-- 		x, y - позиция пикселя на экране
--   Возвращает:	True, если цвета примерно равны, иначе False ]]
function colorTest(expR, expG, expB, x, y)
	local r, g, b = getColor(Location(x, y))
	if (expR + ERROR_RANGE > r and r > expR - ERROR_RANGE
		and expG + ERROR_RANGE > g and g > expG - ERROR_RANGE
		and expB + ERROR_RANGE > b and b > expB - ERROR_RANGE) then
			return true
	end
	return false
end

--[[ Функция ожидания пикселя на экране. Ожидает MAX_ITER с паузами в WAIT_TIME.
--   Если пиксель найден, то скрипт выполняется далее, иначе выход и закрывает
-- 		открытые приложения (Archaro, AnkuLua, GG) ]]
function waitColor(expR, expG, expB, x, y)						
	for i = 1, MAX_ITER do
		if colorTest(expR, expG, expB, x, y) then
			return
		end
		wait(WAIT_TIME)
	end
	scriptExit("Превышено максимальное число итераций поиска")
	killApp(GAME_PACK_NAME)
	killApp(GG_PACK_NAME)
	killApp(ANKULUA_PACK_NAME)
end

--[[ Основной метод скрипта. Выполняет все поставленные задачи ]]
function mainActivity()
	local actionList
	-- setManualTouchParameter - плавность движения. 1мс ожидания каждые 5 пикселей
	setManualTouchParameter(5, 1)
	
	actionList = {												-- Ускорить время через GG
		{action = "touchDown", target = Location(690, 145)},
		{action = "touchUp", target = Location(690, 145)}	
	}
	manualTouch(actionList)

	waitColor(117, 252, 28, 380, 125)							-- Ждём заполнения стамины
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
	
	waitColor(254, 197, 20, 670, 1765)							-- Ожидаем колесо удачи
	actionList = {
		{action = "touchUp", target = Location(670, 1765)},
		{action = "touchDown", target = Location(850, 145)},	-- Открыть GG
		{action = "touchUp", target = Location(850, 145)},
		{action = "wait", target = 0.4},
		{action = "touchDown", target = Location(235, 1215)},	-- Перезапустить скрипт GG
		{action = "touchUp", target = Location(235, 1215)}
	}
	manualTouch(actionList)

	waitColor(254, 197, 20, 670, 1765)							-- Ожидаем колесо удачи
	actionList = {
		{action = "touchDown", target = Location(670, 1765)},	-- Тыкнуть по колесу удачи
		{action = "touchUp", target = Location(670, 1765)}
	}
	manualTouch(actionList)
		
	waitColor(0, 82, 174, 525, 2000)							-- Ждём возможности передвигаться
	actionList = {
		{action = "touchDown", target = Location(525, 2000)},	-- Движемся в соседнюю комнату
		{action = "touchMove", target = Location(525, 1600)}
	}
	manualTouch(actionList)

	waitColor(255, 255, 255, 900, 2000)							-- Ждём следующую комнату
	actionList = {
		{action = "touchUp", target = Location(525, 2000)},		-- Останавливаем персонажа
		{action = "touchDown", target = Location(525, 2000)}	
	}
	manualTouch(actionList)
	
	waitColor(223, 216, 208, 850, 1150)							-- Ожидаем экран смерти	
	while not colorTest(248, 54, 45, 690, 1750) do				-- Ждём начального экрана
		actionList = {
			{action = "touchDown", target = Location(910, 1800)},	-- Нажать на пустое место
			{action = "touchUp", target = Location(910, 1800)},
		}
		manualTouch(actionList)
		wait(0.2)
	end
end

---------------------------------------------------
---------------------   Main   --------------------
---------------------------------------------------
local dec = 1
setProperties()
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
print("Конец")