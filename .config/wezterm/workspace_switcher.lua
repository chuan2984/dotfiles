local module = {}

function module.apply_to_config(config)
	local switcher = require("wezterm").plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
	switcher.apply_to_config(config)

	local function remove_key_binding(keys_table, mod_to_remove, key_to_remove)
		for i, binding in ipairs(keys_table) do
			if binding.mods == mod_to_remove and binding.key == key_to_remove then
				table.remove(keys_table, i)
				return -- assuming there's only one, we can return immediately after removing
			end
		end
	end

	remove_key_binding(config.keys, "ALT", "s")

	table.insert(config.keys, { key = "f", mods = "LEADER", action = switcher.switch_workspace() })
end

return module
