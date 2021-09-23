
local desired_fps=30
local desired_percentage = 1 / (desired_fps/60)

local exoName = 'DoubleSpeedSpidertron_exoskeleton-equipment'
local reactorName = 'DoubleSpeedSpidertron_fusion-reactor-equipment'

local info = function(entity)
    if entity.name then
        game.print(serpent.block('name='..entity.name))
    end
    if entity.type then
        game.print(serpent.block('type='..entity.type))
    end
    if entity.object_name then
        game.print(serpent.block('object_name='..entity.object_name))
    end
end

local add_exos = function (count, entity)
    -- game.print("Adding exos")
    -- game.print(count)
    if count > 0 then
        for i = 1, count, 1 do
            if entity.grid.put({name=exoName}) == nil then
                game.print("Spidertron Double Speed: Could not add DoubleSpeedSpidertron_exoskeleton-equipment");
            end
            if entity.grid.put({name=reactorName}) == nil then
                game.print("Spidertron Double Speed: Could not add DoubleSpeedSpidertron_fusion-reactor-equipment");
            end 
        end
        
    -- game.print(serpent.block(entity.grid.get_contents()))
    else
        local exos_to_take = -count;
        local reactors_to_take = -count;
        local discard;
        for i, equipment in ipairs(entity.grid.equipment) do
            if (equipment and equipment.valid) then
                if equipment.name == exoName and exos_to_take > 0 then
                    discard = entity.grid.take({equipment=equipment})
                    exos_to_take = exos_to_take - 1;
                else
                    if equipment.name == reactorName and reactors_to_take > 0 then
                        discard = entity.grid.take({equipment=equipment})
                        reactors_to_take = reactors_to_take - 1;
                    end
                end
            end
        end
    end
end

local adjust_spidertron = function(spidertron)
    local spidertron_base_speed = 1;
    for key, value in pairs(spidertron.grid.get_contents()) do
        if game.equipment_prototypes[key].type == "movement-bonus-equipment" then
            if key ~= "DoubleSpeedSpidertron_exoskeleton-equipment" then
                spidertron_base_speed = spidertron_base_speed + game.equipment_prototypes[key].movement_bonus * value
            end
        end
    end
    local desired_speed = spidertron_base_speed * desired_percentage;
    local desired_speed_percent = (100 * desired_speed)
    local exoskeletons_needed = desired_speed_percent - (spidertron_base_speed * 100)
    local exoskeletons_current = spidertron.grid.get_contents()["DoubleSpeedSpidertron_exoskeleton-equipment"];
 
    if exoskeletons_current ~= nil then
        exoskeletons_needed = exoskeletons_needed - exoskeletons_current;
    end
    if exoskeletons_needed ~= 0 then
        add_exos(exoskeletons_needed, spidertron);
    end
end

local remove_internal_items_from_player_inventory = function(player)
    for _, inv in pairs({defines.inventory.character_main}) do
        local inventory = player.get_inventory(inv)
        if inventory then
            local itemsRemoved = 1;
            while itemsRemoved ~= 0 do
                itemsRemoved = 0
                itemsRemoved = itemsRemoved + inventory.remove(exoName);
                itemsRemoved = itemsRemoved + inventory.remove(reactorName);
            end
        end
    end
end

local reevaluate = function(event)
    -- game.print("Reevaluating")
    local player = game.get_player(event.player_index)
    if player.opened_gui_type ~= defines.gui_type.entity then return end
  
  
    local opened = player.opened
    if not (opened and opened.valid and opened.object_name == "LuaEntity" and opened.type == "spider-vehicle") then return end

    adjust_spidertron(opened)
    remove_internal_items_from_player_inventory(player)
end

local on_built_entity = function(event)
    -- game.print("on_built_entity")
    local entity = event.created_entity;
    if entity.type == 'spider-vehicle' then
        adjust_spidertron(entity)
    end
end

local lib = {}

lib.events =
{
    [defines.events.on_player_placed_equipment] = reevaluate,
    [defines.events.on_player_removed_equipment] = reevaluate,
    [defines.events.on_built_entity] = on_built_entity,
}

lib.on_init = function()
    for name, surface in pairs(game.surfaces) do
        for i, spider in ipairs(surface.find_entities_filtered({type='spider-vehicle'})) do
            adjust_spidertron(spider)
        end
    end
end

return lib