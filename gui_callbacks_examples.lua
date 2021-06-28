if not client.set_callback then LoadScript('lib_callback.lua') end

local tab = gui.Tab(gui.Reference('Settings'), 'temp_tab', 'Example tab')
local group = gui.Groupbox(tab, 'Examples', 16, 16)

local enable = gui.Checkbox(group, 'temp_checkbox', 'Enable', false)
local combobox = gui.Combobox( group , 'temp_combobox', 'Options', 'Value 1', 'Value 2', 'Value 3', 'Value 4')
local editbox = gui.Editbox( group, 'temp_editbox', 'Message' )
local slider = gui.Slider( group, 'temp_slider', 'slider', 1, 0, 100 )
local colorpicker = gui.ColorPicker( group, 'temp_color', 'Color thing', 255, 255, 255, 255 )


-- "self" represents the gui object
local function on_enable_change(self)
	print( string.format('%s has changed to %s', self:GetName(), self:GetValue()) )
end

local function on_combobox_change(self)
	print( string.format('%s has changed to "%s"', self:GetName(), self:GetString()) )
end

local function on_editbox_change(self)
	print( string.format('%s has changed to "%s"', self:GetName(), self:GetString()) )
end

local function on_slider_change(self)
	print( string.format('%s has changed to %s', self:GetName(), self:GetValue()) )
end

local function on_colorpicker_change(self)
	print( string.format('%s has changed to %s %s %s %s', self:GetName(), self:GetValue()) )
end


-- Calls the functions on lua load
-- params: (gui object)
--on_enable_change( enable )
--on_combobox_change( combobox )
--on_editbox_change( editbox )


-- Sets up the function to get called whenever the value changes
-- params: (gui object), (callback)
client.set_callback( enable, on_enable_change )
client.set_callback( combobox, on_combobox_change )
client.set_callback( editbox, on_editbox_change )
client.set_callback( slider, on_slider_change )
client.set_callback( colorpicker, on_colorpicker_change )

gui.Button(group, 'Unset the callbacks', function()
	print('Called button')

	-- To stop the callbacks you can unset them by passing the gui object
	-- params: (gui object)
	client.unset_callback( enable )
	client.unset_callback( combobox )
	client.unset_callback( editbox )
	client.unset_callback( slider )
	client.unset_callback( colorpicker )
end)