local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
local elements = {}

local function get_random()
	local s = ''

	for _=1, 16 do
		local r = math.random(#chars)
		s = s .. chars:sub(r, r)
	end

	return s
end

client.set_callback = function(element, callback)
	if element == nil or element:GetValue() == nil or type(callback) ~= 'function' then
		return 
	end

	local id, last = get_random(), { element:GetValue() }

	local function main()
		local val, val2, val3, val4 = element:GetValue()

		if val ~= nil and (val ~= last[1] or val2 ~= last[2] or val3 ~= last[3] or val4 ~= last[4]) then
			callback( element )
			last = { val, val2, val3, val4 }
		end
	end

	callbacks.Register('Draw', id, main)
	elements[element] = id
end

client.unset_callback = function(element)
	local id = elements[element]

	if id then
		callbacks.Unregister('Draw', id)
	end
end

callbacks.Register('Unload', function()
	-- Only here to show the lua as loaded.
end)