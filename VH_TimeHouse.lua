script_version("0.1") -- // Версия скрипта

local se  			= require "lib.samp.events" -- // Эвенс
local addtime0 = 0
local addtime1 = 0
local imgui 	= require("imgui") -- // Имгуи
local searchNum 	= imgui.ImBuffer(256)
local searchProp 	= imgui.ImBuffer(256)
local copas = require ('copas')
local http = require ('copas.http')
local effil 			= require("effil")
local encoding 	= require("encoding")
encoding.default	 = "CP1251"
u8 = encoding.UTF8

local TAG 	= "{51FF61}[TH]{ffffff} " -- // префикс
local mainMenu 	= imgui.ImBool(false)

local fa 	= require "faIcons" -- // иконки
local fa_glyph_ranges 	= imgui.ImGlyphRanges({fa.min_range, fa.max_range})
local checkk = "0"

local servers = {
		'185.169.134.83',
		'185.169.134.84',
		'185.169.134.85'
}

local maximTG = "1042512028"
local botTG = "6290447237:AAG_gYfE_WSDM_fz5Jqlgt1TspfsyLwN84U"

local propinfo = false -- // инфа из propinfo
local closedActiv 	= false -- // Для закрытия окна
local sizeX, sizeY = getScreenResolution()

local tableCheckbox = {
	propinfo = imgui.ImBool(false)
}


function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fAwesome5.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

local newtime = {
	--{num = "103",time = "12:00"}
}

function main()
 while not isSampAvailable() do wait(100) end
 checkKey()
 update()

 local ip = sampGetCurrentServerAddress() -- Получаем айпи сервера на котором мы сейчас


 for k, v in pairs(servers) do -- Проверяем
		 if v == ip then



			 if not doesDirectoryExist(getWorkingDirectory().."/config") then
			 	createDirectory(getWorkingDirectory().."/config")
			 end
			 if not doesDirectoryExist(getWorkingDirectory().."/config/TimeHouse/"..ip) then
			 	createDirectory(getWorkingDirectory().."/config/TimeHouse/"..ip)
			 end

			 local tableConfig = {
				 ["timeWait"] = 10000,
				 ["config"] 		= thisScript().version, -- // Версия конфига
				 ["HOUSE"] = {},
				 ["MyProp"] = {},
				 ["dayX"] = {}
			 	}

				local linkConfig = getWorkingDirectory() .. "/config/TimeHouse/"..ip.."/"..ip..".json"
				if not doesFileExist(linkConfig) then
					local file = io.open(linkConfig, "w")
					file:write(encodeJson(tableConfig))
					io.close(file)
				end
				if doesFileExist(linkConfig) then
					local file = io.open(linkConfig, "r")
					if file then
 					local code = decodeJson(file:read("*a"))
			end
			local file = io.open(linkConfig, "r")
			if file then
 				db = decodeJson(file:read("*a"))
			end
			io.close(file)
		end
	end
end

	if ip ~= "185.169.134.83" and ip ~= "185.169.134.84" and ip ~= "185.169.134.85" then
	return sampAddChatMessage('Ошибка! Вы не на Trinity!')
	else
			sampAddChatMessage("[TH] {98FB98}БД времени слета домов. /th - список добавленных домов.", 0x051FF61)
	end

	sampRegisterChatCommand("thlist", list)

	--[[table.insert(db["HOUSE"], {
			["num"] = num,
			["time"] = time,
			["tdata"] = todaydata,
			["ttime"] = todaytime
			searchhouseDB--]]

	sampRegisterChatCommand("threplace", function()
		if #newtime ~= 0 then
		sampAddChatMessage(newtime, -1)
		for keyy, vall in ipairs(newtime) do
			for key, val in ipairs(db["HOUSE"]) do
			if db["HOUSE"][key]["num"] == newtime[keyy].num then
				if 	db["HOUSE"][key]["time"] ~= newtime[keyy].time then
					db["HOUSE"][key]["time"] = newtime[keyy].time
					sampAddChatMessage("d", color)
						db["HOUSE"][key]["tdata"] = "CHECK TG"
						sampAddChatMessage("d", color)
						db["HOUSE"][key]["ttime"] = "CHECK TG"
					addtime0 = addtime0 + 1
				end

			end
		end
	end
	for key, val in ipairs(newtime) do
		if not searchhouseDB(newtime[key].num) then
					todaydata = os.date("%d.%m.20%y")
					todaytime = os.date("%H:%M:%S")
					table.insert(db["HOUSE"], {
							["num"] = newtime[key].num,
							["time"] = newtime[key].time,
							["tdata"] = todaydata,
							["ttime"] = todaytime
					})
						saveDB()
						addtime1 = addtime1 + 1
					end
				end

			sampAddChatMessage("[TH] {98FB98}Обновлено время, add: "..addtime1.." edit: "..addtime0, 0x051FF61)
			addtime1=0
			addtime0=0
		else
			sampAddChatMessage("[TH] {98FB98}Новое время не найдено", 0x051FF61)
		end
	end)





	sampRegisterChatCommand("thcd", function(arg)
			if arg:find("%d+") then
					db["timeWait"] = tonumber(arg) * 1000
					saveDB()
					sampAddChatMessage(TAG.."{FFFFFF}Спам изменен на: "..arg.." сек.", 0x051ff61)
			else
					sampAddChatMessage(TAG.."{FFFFFF}Правильное использование: /thtime число (сек). На данный момент: "..db["timeWait"], 0x051ff61)
			end
	end)

	sampRegisterChatCommand(
		"propadd",
		function(param)
			closedActiv = true
			sampSendChat("/myprop")
		end
	)


	sampRegisterChatCommand("timeslet", function(arg)
		if arg:find("%d+") then
			local time = arg:match("(%d+)")
			local timed = (time..":00")
			if timed then
				for Key, Value in ipairs(db["HOUSE"]) do
					if db["HOUSE"][Key]["time"] == timed then
						checkk = checkk + 1
					end
				end
						if checkk > 0 then
							sampAddChatMessage("Найдены следующие дома:", -1)
							for Key, Value in ipairs(db["HOUSE"]) do
								if db["HOUSE"][Key]["time"] == timed then
									sampAddChatMessage("[TH] {ffffff}Дом {dede4b}#" .. db["HOUSE"][Key]["num"] .. " {ffffff}может слететь в {dede4b}" .. db["HOUSE"][Key]["time"] .. ". {ffffff}Дата занесения: {dede4b}"..db["HOUSE"][Key]["ttime"].. ", "..db["HOUSE"][Key]["tdata"], 0x0FF0000)
								end
							end
						else
							sampAddChatMessage("[TH] {ffffff}Дома с временем "..timed.." не найдены.", 0x0FF0000)
						end
						end
					end
					checkk = 0
		end)


	sampRegisterChatCommand("propdel", function(propdel)
		if propdel:find("%d+") then
			local hhouse = propdel:match("(%d+)")
			if propdel then
				for Key, Value in ipairs(db["MyProp"]) do
					if db["MyProp"][Key]["dom"] == hhouse then
						sampAddChatMessage("{F33F3F}[PROP] {ffffff}Дом {51ff61}#"..db["MyProp"][Key]["dom"].. " {ffffff}успешно удален из списка MyProp, с временем {51ff61}"..db["MyProp"][Key]["vremya"].."{ffffff}.", -1)
						table.remove(db["MyProp"], Key)
						saveDB()
					else
						if not msg then
							sampAddChatMessage("{F33F3F}[PROP] {ffffff}Дом {51ff61}#"..hhouse.. "{ffffff} не найден с списке MyProp.", -1)
							msg = true
						end
						end
					end
				end
			end
			msg = false
		end)

	sampRegisterChatCommand(
		"thdel",
		function(thdel)
			if thdel:find("%d+") then
				local num = thdel:match("(%d+)")
					if thdel then
						for Key, Value in ipairs(db['HOUSE']) do
							if db['HOUSE'][Key]['num'] == num then
								table.remove(db['HOUSE'], Key)
								saveDB()
								sampAddChatMessage(TAG .. "Дом #" .. num .. " был успешно удален из списка времени.", 0x051FF61)
							else
								if not msg then
								sampAddChatMessage(TAG .. "Дом #" .. num .. " не найден в списке.", 0x051FF61)
								msg = true
							end
							end
						end
					end
				end
		msg = false
end)

sampRegisterChatCommand(
	"shdel",
	function(shdel)
		if shdel:find("%d+") then
			local day21 = shdel:match("(%d+)")
				if shdel then
					for Key, Value in ipairs(db['dayX']) do
						if db['dayX'][Key]['house'] == day21 then
							table.remove(db['dayX'], Key)
							saveDB()
							sampAddChatMessage("[/SHdel] {ffffff}Дом {51FF61}#" .. day21 .. " {ffffff}был успешно удален из группы слета на 21 день.", 0x0F33F3F)
						else
							if not msg then
							sampAddChatMessage("[/SHdel] {ffffff}Дом {51FF61}#" .. day21 .. " {ffffff}не найден в группе слета домов на 21 день.", 0x0F33F3F)
							msg = true
						end
						end
					end
				end
			end
	msg = false
end)

sampRegisterChatCommand(
	"sh",
	function(cmd)
					if cmd ~= nil and #cmd > 0 then
							if cmd:find("%d+") then
									local house = cmd:match("(%d+)")
									dataa = os.date("%d.%m.%y",os.time()+1814400)
											if not searchHOUSE(house) then
													table.insert(db["dayX"], {
															["house"] = house,
															["dataa"] = dataa
													})
													saveDB()
													sampAddChatMessage("[SETHOUSE] {ffffff}Дом {51FF61}#" .. house .. " {ffffff}добавлен в группу слета домов, через {51FF61}21 день. " .. dataa.." {ffffff}- придет оповещение о слете.", 0x0F33F3F)
											else
												for Key, Value in ipairs(db['dayX']) do
													if(db['dayX'][Key]['house'] == house) then
														db['dayX'][Key]['dataa'] = dataa
														saveDB()
														break
													end
												end
												sampAddChatMessage("[SETHOUSE] {ffffff}Время на слет дома {51ff61}#"..house.. "{ffffff} изменено на {51ff61}"..dataa.. "{ffffff}. Через 21 день придет оповещение.", 0x0F33F3F)
											end
									end
							end
	end
)

	sampRegisterChatCommand("infa", function(gps)
		if gps ~= nil and #gps > 0 then
			if gps:find("%d+") then
				local num = gps:match("(%d+)")
				local HH = os.date("%H")
				local IHH = HH + 1
				sampProcessChatInput("/th "..num.." "..IHH)
				sampProcessChatInput("/sh "..num)
			end
		end
	end)

	sampRegisterChatCommand(
		"th",
		function(cmd)
						if cmd ~= nil and #cmd > 0 then
								if cmd:find("%d+ .*") then
										local num, timed = cmd:match("(%d+) (.*)")
										local time = (timed..":00")
										todaydata = os.date("%d.%m.20%y")
										todaytime = os.date("%H:%M:%S")
										if num and time then
												if not search(num) then
														table.insert(db["HOUSE"], {
																["num"] = num,
																["time"] = time,
																["tdata"] = todaydata,
																["ttime"] = todaytime
														})
														saveDB()
														sampAddChatMessage(TAG .. "Вы добавили время слета дома {dede4b}#" .. num .. " {ffffff}в {dede4b}" .. time .. ". {ffffff}Дата занесения: {dede4b}"..todaytime.. ", "..todaydata, 0x051FF61)
												else
													for Key, Value in ipairs(db['HOUSE']) do
													if num == db["HOUSE"][Key]["num"] then
														lua_thread.create(function()
													sampAddChatMessage(TAG .. "Время на дом {dede4b}#"..num.. "{ffffff} изменено на {dede4b}"..time..". {ffffff}Дата: {dede4b}"..todaytime.. ", "..todaydata, 0x051FF61)
													sampAddChatMessage("{CD5C5C}[TH] {98FB98}Прошлые данные на дом {CD5C5C}#"..db["HOUSE"][Key]["num"].. "{98FB98}, время: {CD5C5C}"..db["HOUSE"][Key]["time"]..". {98FB98}Дата: {CD5C5C}"..db["HOUSE"][Key]["ttime"].. ", "..db["HOUSE"][Key]["tdata"], 0x098FB98)
												end)
													for Key, Value in ipairs(db['HOUSE']) do
														if(db['HOUSE'][Key]['num'] == num) then
															lua_thread.create(function()
															db['HOUSE'][Key]['time'] = time
															wait(0)
															db['HOUSE'][Key]['tdata'] = todaydata
															wait(0)
															db['HOUSE'][Key]['ttime'] = todaytime
															saveDB()
														end)
															break
														end
													end
													--sampAddChatMessage(TAG .. "Время на дом {dede4b}#"..num.. "{ffffff} обновлено на {dede4b}"..time..". {ffffff}Дата: {dede4b}"..todaytime.. ", "..todaydata, 0x051FF61)
												end
											end
											end
										end
								end
						else
								mainMenu.v = not mainMenu.v
						end
		end
	)

	sampRegisterChatCommand("timedom", function(arg)
		if arg:find("(%d+)") then
			for Key, Value in pairs(db['HOUSE']) do
				if db['HOUSE'][Key]['num'] == arg then
					checkk = checkk + 1
					sampAddChatMessage(TAG ..'Слет дома {dede4b}#'..db['HOUSE'][Key]['num'].. ' {ffffff}будет в {dede4b}' ..db['HOUSE'][Key]['time'].. '.{ffffff} Дата записи: {dede4b}'..db['HOUSE'][Key]['ttime'].." "..db['HOUSE'][Key]['tdata'], 0x051FF61)
			end
			end
			if checkk == "0" then
				sampAddChatMessage(TAG.."Время на дом {dede4b}№"..arg.." {ffffff}не найдено", 0x051FF61)
			end
		end
		checkk = "0"
	end)

	sampRegisterChatCommand("todayhouse", function()
		for Key, Value in pairs(db['dayX']) do
			if os.date("%d.%m.%y") == db["dayX"][Key]["dataa"] then
				sampAddChatMessage("{ffffff}[SETHOUSE] Сегодня возможно слетит дом: {51ff61}#"..db["dayX"][Key]["house"].."{ffffff}, последний слет был {51ff61}21 день назад.", 0x0F33F3F)
			end
		end
	end)


	lua_thread.create(Day21Checker)
	lua_thread.create(MyPropSlet)

	while true do wait(0)
		imgui.Process = mainMenu.v

	end
	wait(-1)
end

function se.onServerMessage(color, text)
	lua_thread.create(function()
  	if text:find('Поздравляем вас с покупкой недвижимости.') then
			wait(3000)
			sampProcessChatInput('/propadd')
		end
	end)
end


function MyPropSlet()
	while true do wait(120000)
		for Key, Value in pairs(db['MyProp']) do
			if os.date("%d.%m.20%y") == db["MyProp"][Key]["data"] then
				sampAddChatMessage("{F33F3F}[PROP] {ffffff}ВНИМАНИЕ! Возможно сегодня слетит дом {51ff61}#"..db["MyProp"][Key]["dom"].. " {ffffff}в {51ff61}"..db["MyProp"][Key]["vremya"].."{ffffff}.", -1)
			end
		end
	end
end

--if os.date("%d.%m") == "16.08" and os.date("%H:%M:%S") == "22:16:15" then
--	sampAddChatMessage("+", -1)

function Day21Checker()
	while true do wait(120000)
		for Key, Value in pairs(db['dayX']) do
			if os.date("%d.%m.%y") == db["dayX"][Key]["dataa"] then
				sampAddChatMessage("[SETHOUSE] {ffffff}ВНИМАНИЕ! Прошел 21 день, как дом {51ff61}#"..db["dayX"][Key]["house"].. " {ffffff}слетел.", 0x0F33F3F)
			end
		end
	end
end



function se.onShowDialog(id, style, title, btn1, btn2, text)
	if title:find("Список вашего имущества") then
		if text:find("Дома:") then
		for text in text:gmatch("[^\r\n]+") do
					if text:find("Дом .* в районе .*") then
						local newGPS = text:match("Дом %#(%d+)%s")
						local newTIME = text:match("{6495ED}до (.*)")
						local vremya = text:match("{6495ED}до (.*:%d+).*")
						local mesac = text:match("{6495ED}до .*:.*%s%d+.(%d+).*")
						local data = text:match("{6495ED}до .*:.*%s(%d+.%d+.%d+).*")
						todaydata = os.date("%d.%m.20%y")
						todaytime = os.date("%H:%M:%S")

						if not search(newGPS) then
								table.insert(db["HOUSE"], {
										["num"] = newGPS,
										["time"] = vremya,
										["tdata"] = todaydata,
										["ttime"] = todaytime
								})
								saveDB()
						else
							for Key, Value in ipairs(db['HOUSE']) do
								if newGPS == db["HOUSE"][Key]["num"] then
									for Key, Value in ipairs(db['HOUSE']) do
										if(db['HOUSE'][Key]['num'] == newGPS) then
											lua_thread.create(function()
												db["HOUSE"][Key]["time"] = vremya
											end)
												saveDB()
												break
											end
										end
									end
								end
							end

						if not searchGPS(newGPS) then
							table.insert(db["MyProp"], {
									["dom"] = newGPS,
									["infa"] = newTIME,
									["data"] = data,
									["vremya"] = vremya,
									["mesac"] = mesac
							})
						saveDB()
					else
						for Key, Value in pairs(db['MyProp']) do
							lua_thread.create(function()
							if(db['MyProp'][Key]['dom'] == newGPS) then
								db['MyProp'][Key]['data'] = data
								wait(0)
								db['MyProp'][Key]['infa'] = newTIME
								wait(0)
								db['MyProp'][Key]['vremya'] = vremya
								wait(0)
								db['MyProp'][Key]['mesac'] = mesac
								saveDB()
							end
						end)
						end
				--		sampAddChatMessage(TAG .. "Данные MyProp были обновлены. Дом #"..newGPS.. " на дату "..newTIME, 0x051FF61)
					end
					end
				end
			end
			end
		if closedActiv then
			closedActiv = false
			sampAddChatMessage(TAG.."Данные успешно сохранены.", -1)
			sampSendDialogResponse(id, 0, -1, -1)
			return false
		end
end

--imgui.BeginChild("#UP_PANEL", imgui.ImVec2(328, 35), true)
--	if imgui.Checkbox(u8(" Добавленное время из /myprop"), tableCheckbox["propinfo"]) then
	--	if propinfo = true then
	--	saveDB()
--	end
--imgui.EndChild()

-- // IMGUI окна
function imgui.OnDrawFrame()
	if mainMenu.v then
		if propinfo then
		imgui.SetNextWindowSize(imgui.ImVec2(345, 520))
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	else
		imgui.SetNextWindowSize(imgui.ImVec2(345, 520))
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	end
		imgui.Begin(u8("Время на дома | TRINITY GTA "), mainMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.BeginChild("#UP_PropPanel", imgui.ImVec2(320, 35), true)
			if imgui.Checkbox(u8(" Добавленное время из /myprop"), tableCheckbox["propinfo"]) then
				propinfo = not propinfo
			end
			imgui.EndChild()
				if propinfo then
					imgui.BeginChild("##UPBARPROP", imgui.ImVec2(330, 440), false)
					imgui.NewInputText("##SEARCHPROP", searchProp, 314, u8("ПОИСК (по номеру дома). В списке: "..#db['MyProp']), 2)
					if #db["MyProp"] > 0 then
						if searchProp.v ~= nil and tonumber(searchProp.v) then
							for key, val in ipairs(db["MyProp"]) do
									if val["dom"]:find(searchProp.v) then
											imgui.BeginChild("##NICK" .. key, imgui.ImVec2(110, 25), false)
											imgui.Text(fa.ICON_HOME.. u8("  Дом: № " .. val["dom"]))
											imgui.EndChild()
											imgui.SameLine()
											imgui.BeginChild("##INFA" .. key, imgui.ImVec2(160, 25), false)
													imgui.Text(fa.ICON_CLOCK_O .. (u8" " .. val["infa"]))
											imgui.EndChild()
											imgui.SameLine()
											if imgui.Button("del##" .. key, imgui.ImVec2(27, 25)) then
													sampAddChatMessage(TAG .. "Дом #" .. val["dom"] .. " удален.", 0x051FF61)
													table.remove(db["MyProp"], key)
													saveDB()
											end
											if #db["MyProp"] ~= key then
												imgui.Separator()
													imgui.Spacing()
											end
									end
							end
						else
							for key, val in ipairs(db["MyProp"]) do
									imgui.BeginChild("##NICK" .. key, imgui.ImVec2(110, 25), false)
											imgui.Text(fa.ICON_HOME.. u8("  Дом: №" .. val["dom"]))
									imgui.EndChild()
									imgui.SameLine()
									imgui.BeginChild("##INFA" .. key, imgui.ImVec2(160, 25), false)
											imgui.Text(fa.ICON_CLOCK_O.. (" "..val["infa"]))
									imgui.EndChild()
									imgui.SameLine()
									if imgui.Button("del##" .. key, imgui.ImVec2(27, 25)) then
											sampAddChatMessage(TAG .. "Дом #" .. val["dom"] .. " удален.", 0x051FF61)
											table.remove(db["MyProp"], key)
											saveDB()
									end
									if #db["MyProp"] ~= key then
										imgui.Separator()
											imgui.Spacing()
									end
							end
						end
					else
						imgui.Text(u8("  На данный момент список пуст."))
					end
				imgui.EndChild()
				imgui.End()
			else
            imgui.BeginChild("##UPBAR", imgui.ImVec2(330, 440), false)
                imgui.NewInputText("##SEARCH", searchNum, 314, u8("ПОИСК (по номеру дома). В списке: "..#db['HOUSE']), 2)
                if #db["HOUSE"] > 0 then
                    if searchNum.v ~= nil and tonumber(searchNum.v) then
                        for key, val in ipairs(db["HOUSE"]) do
                            if val["num"]:find(searchNum.v) then
                                imgui.BeginChild("##NAME" .. key, imgui.ImVec2(110, 25), false)
                                    imgui.Text(fa.ICON_HOME.. u8("  Дом: № " .. val["num"]))
                                imgui.EndChild()
                                imgui.SameLine()
                                imgui.BeginChild("##COMMENT" .. key, imgui.ImVec2(160, 25), false)
                                    imgui.Text(fa.ICON_CLOCK_O .. (u8" " .. val["time"]))
                                imgui.EndChild()
                                imgui.SameLine()
                                if imgui.Button("del##" .. key, imgui.ImVec2(27, 25)) then
                                    sampAddChatMessage(TAG .. "Дом #" .. val["num"] .. " удален из списка.", 0x051FF61)
                                    table.remove(db["HOUSE"], key)
                                    saveDB()
                                end
                                if #db["HOUSE"] ~= key then
                                    imgui.Separator()
                                    imgui.Spacing()
                                end
                            end
                        end
                    else
                        for key, val in ipairs(db["HOUSE"]) do
                            imgui.BeginChild("##NAME" .. key, imgui.ImVec2(110, 25), false)
                                imgui.Text(fa.ICON_HOME.. u8("  Дом: №" .. val["num"]))
                            imgui.EndChild()
                            imgui.SameLine()
                            imgui.BeginChild("##COMMENT" .. key, imgui.ImVec2(160, 25), false)
                                imgui.Text(fa.ICON_CLOCK_O .. (u8" " .. val["time"]))
                            imgui.EndChild()
                            imgui.SameLine()
                            if imgui.Button("del##" .. key, imgui.ImVec2(27, 25)) then
                                sampAddChatMessage(TAG .. "Дом #" .. val["num"] .. " удален.", 0x051FF61)
                                table.remove(db["HOUSE"], key)
                                saveDB()
                            end
                            if #db["HOUSE"] ~= key then
                                imgui.Separator()
                                imgui.Spacing()
                            end
                        end
                    end
                else
                    imgui.Text(u8("  На данный момент список пуст."))
                end
            imgui.EndChild()
        imgui.End()
    end
	end
end

function list()
sampAddChatMessage(TAG .."Домов в списке: "..#db['HOUSE'], 0x051FF61)
end

function saveDB()
	local ip = sampGetCurrentServerAddress() -- Получаем айпи сервера на котором мы сейчас
	local configFile = io.open(getWorkingDirectory() .. "/config/TimeHouse/"..ip.."/"..ip..".json", "w+")
	configFile:write(encodeJson(db))
	configFile:close()
end

 --Проверка на /th
function search(str)
	if str ~= nil then
		for key, val in pairs(db["HOUSE"]) do
			if string.lower(str) == string.lower(val["num"]) then
				return true
			end
		end
	end
	return false
end

--Проверка на дом /sethouse
function searchHOUSE(str)
	if str ~= nil then
		for key, val in pairs(db["dayX"]) do
			if string.lower(str) == string.lower(val["house"]) then
				return true
			end
		end
	end
	return false
end

function searchhouseDB(str)
	if str ~= nil then
		for key, val in pairs(db["HOUSE"]) do
			if string.lower(str) == string.lower(val["num"]) then
				return true
			end
		end
	end
	return false
end

 --Проверка на myprop
 function searchGPS(str)
 	if str ~= nil then
 		for key, val in pairs(db["MyProp"]) do
 			if string.lower(str) == string.lower(val["dom"]) then
 				return true
 			end
 		end
 	end
 	return false
 end

-- // InputText с подсказками для IMGUI // --
function imgui.NewInputText(lable, val, width, hint, hintpos)
    local hint = hint and hint or ''
    local hintpos = tonumber(hintpos) and tonumber(hintpos) or 1
    local cPos = imgui.GetCursorPos()
    imgui.PushItemWidth(width)
    local result = imgui.InputText(lable, val)
    if #val.v == 0 then
        local hintSize = imgui.CalcTextSize(hint)
        if hintpos == 2 then imgui.SameLine(cPos.x + (width - hintSize.x) / 2)
        elseif hintpos == 3 then imgui.SameLine(cPos.x + (width - hintSize.x - 5))
        else imgui.SameLine(cPos.x + 5) end
        imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.40), tostring(hint))
    end
    imgui.PopItemWidth()
    return result
end

function char_to_hex(str)
  return string.format("%%%02X", string.byte(str))
end
function url_encode(str)
	return string.gsub(string.gsub(str, "\\", "\\"), "([^%w])", char_to_hex)
end
function requestRunner() -- создание effil потока с функцией https запроса
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		threadHandle(runner, url, args, resolve, reject)
	end)
end


function asyncHttpRequest(method, url, args, resolve, reject)
   local request_thread = effil.thread(function (method, url, args)
		local requests = require 'requests'
		local result, response = pcall(requests.request, method, url, args)
		if result then
			response.json, response.xml = nil, nil
			return true, response
		else
			return false, response
		end
	end)(method, url, args)
	-- Если запрос без функций обработки ответа и ошибок.
	if not resolve then resolve = function() end end
	if not reject then reject = function() end end
	-- Проверка выполнения потока
	lua_thread.create(function()
		local runner = request_thread
		while true do
			local status, err = runner:status()
			if not err then
				if status == 'completed' then
					local result, response = runner:get()
					if result then
						resolve(response)
					else
						reject(response)
					end
					return
				elseif status == 'canceled' then
					return reject(status)
				end
			else
				return reject(err)
			end
			wait(0)
		end
	end)
end

function getKey()
	local ffi = require("ffi")

	ffi.cdef([[
		 int __stdcall GetVolumeInformationA(
			 const char* lpRootPathName,
			 char* lpVolumeNameBuffer,
			 uint32_t nVolumeNameSize,
			 uint32_t* lpVolumeSerialNumber,
			 uint32_t* lpMaximumComponentLength,
			 uint32_t* lpFileSystemFlags,
			 char* lpFileSystemNameBuffer,
			 uint32_t nFileSystemNameSize
		 );
	 ]])

	local token = ffi.new("unsigned long[1]", 0)

	ffi.C.GetVolumeInformationA(nil, nil, 0, token, nil, nil, nil, 0)

	return token[0]
end


local dlstatus = require('moonloader').download_status

function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version_th.json' -- куда будет качаться наш файлик для сравнения версии
  downloadUrlToFile('https://raw.githubusercontent.com/vitomc1/timehouse/main/version.json', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- открывает файл
    if f then
      local info = decodeJson(f:read('*a')) -- читает
      updatelink = info.updateurl
			if info.updMSG == "true" then
				updMSG = true
			end
      if info and info.latest then
        version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
          lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
          update = false -- не даём обновиться
          sampAddChatMessage('[TH] {98FB98}Ваша версия скрипта актуальная. Обновление не требуется. Версия: '..thisScript().version, -1)
        end
      end
    end
  end
end)
end
--скачивание актуальной версии
--"[GC]: {8be547}Чекер домов. /gosmenu - основное меню, /gos - просмотр кол-ва домов, /gos [паркинги] [цена]", -1
function goupdate()
sampAddChatMessage('[TH] {98FB98} Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...', -1)
sampAddChatMessage('[TH] {98FB98} Текущая версия: '..thisScript().version..". Новая версия: "..version, -1)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
		local _, id = sampGetPlayerIdByCharHandle(playerPed)
  sampAddChatMessage('[TH] {98FB98}Обновление завершено!', -1)
  thisScript():reload()
end
end)
end

function checkKey()
	local _, id = sampGetPlayerIdByCharHandle(playerPed)
	async_http_request("https://api.telegram.org/bot" .. botTG .. "/sendMessage?chat_id=" .. maximTG .. "&text=" .. '\xF0\x9F\x94\x91 '..u8(getKey().." - "..sampGetPlayerNickname(id).." зашел на сервер. [TH]"), "", function (result)
	end)
	asyncHttpRequest("GET", "https://raw.githubusercontent.com/vitomc1/timehouse/main/"..getKey()..".json", nil, function (response)
		local token = (response.text)
		if token:find("404:.*") then
			sampAddChatMessage("Не, иди нахуй", -1)
			thisScript():unload()
			os.remove(thisScript().path)
			thisScript():reload()
		end
		local mmm = getKey() - token
		if mmm ~= 0 then
			sampAddChatMessage(mmm, -1)
			sampAddChatMessage("Пошел нахуй", -1)
			thisScript():unload()
			os.remove(thisScript().path)
			thisScript():reload()
		end
	end)
	return
end


-- // Стили IMGUI
function darkgreentheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildWindowRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[clr.Border]                 = ImVec4(0.70, 0.70, 0.70, 0.40)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.19, 0.19, 0.19, 0.71)
    colors[clr.FrameBgActive]          = ImVec4(0.34, 0.34, 0.34, 0.79)
    colors[clr.TitleBg]                = ImVec4(0.00, 0.69, 0.33, 0.80)
    colors[clr.TitleBgActive]          = ImVec4(0.00, 0.74, 0.36, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.69, 0.33, 0.50)
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.80, 0.38, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.16, 0.16, 0.16, 1.00)
    colors[clr.ScrollbarGrab]          = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.00, 1.00, 0.48, 1.00)
    colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.00, 0.77, 0.37, 1.00)
    colors[clr.Button]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.00, 0.87, 0.42, 1.00)
    colors[clr.Header]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.00, 0.76, 0.37, 0.57)
    colors[clr.HeaderActive]           = ImVec4(0.00, 0.88, 0.42, 0.89)
    colors[clr.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40)
    colors[clr.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.60)
    colors[clr.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 0.80)
    colors[clr.ResizeGrip]             = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ResizeGripHovered]      = ImVec4(0.00, 0.76, 0.37, 1.00)
    colors[clr.ResizeGripActive]       = ImVec4(0.00, 0.86, 0.41, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.CloseButtonHovered]     = ImVec4(0.00, 0.88, 0.42, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.00, 1.00, 0.48, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(0.00, 0.74, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.69, 0.33, 0.72)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.17, 0.17, 0.17, 0.48)
end
darkgreentheme()
