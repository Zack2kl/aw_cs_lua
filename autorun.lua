local Ref, Group, List, Read, Button, unpack, concat, Write, remove, Reg, print, pcall, format = gui.Reference, gui.Groupbox, gui.Listbox, file.Read, gui.Button, unpack, table.concat, file.Write, table.remove, callbacks.Register, print, pcall, string.format

local log_to_console = true

local files = {} do
	file.Enumerate(function(fn)
		files[#files + 1] = fn:match('(.*).lua$') or nil
	end)
end

local old_ref = Ref('Settings', 'Lua Scripts', 'Manage Scripts')
local lua_list = Ref('Settings', 'Lua Scripts', 'Manage Scripts', '')

local ref = Ref('Settings', 'Lua Scripts')
local group = Group(ref, 'Autorun scripts', 16, 528)
local list = List(group, 'luas', 150)
local luas = {} do
	local data = ''
	pcall(function() data = Read('autorun.dat') end)

	for lua in data:gmatch('([^;]+)') do
		luas[#luas + 1] = lua
	end
end

local main_check = nil
local add_lua = Button(old_ref, 'Set As Autorun', function()
	local item_index = lua_list:GetValue() + 1
	local item = files[item_index]

	if item then
		luas[#luas + 1] = item
		list:SetOptions( unpack(luas) )
		Write('autorun.dat', concat(luas, ';'))
		main_check(1)
	end
end)

local remove_lua = Button(group, 'Remove from Autorun', function()
	local item_index = list:GetValue() + 1
	local item = luas[item_index]

	if item then
		remove(luas, item_index)
		list:SetOptions( unpack(luas) )
		Write('autorun.dat', concat(luas, ';'))
		main_check(1)
	end

	if #luas == 0 then
		list:SetOptions('Empty')
	end
end)

local function change_load_priority(by)
	local index = list:GetValue() + 1
	local new_index = index + by

	local temp = {}
	temp[new_index] = luas[index]
	temp[index] = luas[new_index]

	if new_index < 1 or new_index > #luas then
		return
	end

	for i=1, #luas do
		if not temp[i] then
			temp[i] = luas[i]
		end
	end

	luas = temp
	list:SetOptions( unpack(luas) )
	list:SetValue(new_index - 1)
	Write('autorun.dat', concat(luas, ';'))
end

local move_up = Button(group, 'Move Up', function()
	change_load_priority(-1)
end)

local move_down = Button(group, 'Move Down', function()
	change_load_priority(1)
end)

do
	list:SetWidth(280)
	list:SetOptions( unpack(luas) )

	add_lua:SetPosX(296)
	add_lua:SetPosY(316)
	add_lua:SetHeight(28)
	add_lua:SetWidth(136)

	move_up:SetPosX(296)
	move_up:SetPosY(0)

	move_down:SetPosX(296)
	move_down:SetPosY(48)

	remove_lua:SetPosX(296)
	remove_lua:SetPosY(118)
end

do
	local last_check_index = 0

	main_check = function(update)
		local item_index = lua_list:GetValue() + 1

		if (last_check_index ~= item_index) or update then
			local lua = files[item_index]
			local in_list = 0

			for i=1, #luas do
				if lua == 'autorun' or luas[i] == lua then
					in_list = 1
					break
				end
			end

			add_lua:SetDisabled(in_list)
			last_check_index = item_index
		end
	end
end

do
	local old_autorun_button = Ref('Settings', 'Lua Scripts', 'Manage scripts', 'Set As Autorun')
		old_autorun_button:SetInvisible(1)

	Reg('Unload', function()
		old_autorun_button:SetInvisible(0)
	end)

	Reg('Draw', main_check)
end


for i=1, #luas do
	LoadScript(luas[i] .. '.lua')
end