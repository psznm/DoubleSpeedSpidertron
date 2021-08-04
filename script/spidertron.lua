
local desired_fps=30
local desired_percentage = 1 / (desired_fps/60)

local add_exos = function (count, entity)
    -- game.print("Adding exos")
    -- game.print(count)
    if count > 0 then
        for i = 1, count, 1 do
            if entity.grid.put({name='DoubleSpeedSpidertron_exoskeleton-equipment'}) == nil then
                game.print("Spidertron Double Speed: Could not add DoubleSpeedSpidertron_exoskeleton-equipment");
            end
            if entity.grid.put({name='DoubleSpeedSpidertron_fusion-reactor-equipment'}) == nil then
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
                if equipment.name == 'DoubleSpeedSpidertron_exoskeleton-equipment' and exos_to_take > 0 then
                    discard = entity.grid.take({equipment=equipment})
                    exos_to_take = exos_to_take - 1;
                else
                    if equipment.name == 'DoubleSpeedSpidertron_fusion-reactor-equipment' and reactors_to_take > 0 then
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

local reevaluate = function(event)
    -- game.print("Reevaluating")
    local player = game.get_player(event.player_index)
    if player.opened_gui_type ~= defines.gui_type.entity then return end
  
  
    local opened = player.opened
    if not (opened and opened.object_name == "LuaEntity" and opened.type == "spider-vehicle") then return end
    if not (opened and opened.valid) then return end

    adjust_spidertron(opened)
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
