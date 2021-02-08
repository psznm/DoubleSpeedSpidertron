
local desired_fps=30
local desired_percentage = 1 / (desired_fps/60)

local add_exos = function (count, entity)
    if count > 0 then
        for i = 1, count, 1 do
            entity.grid.put({name='exoskeleton-equipment-custom'})
            entity.grid.put({name='fusion-reactor-equipment-custom'})
        end
    else
        local exos_to_take = -count;
        local reactors_to_take = -count;
        local discard;
        for i, equipment in ipairs(entity.grid.equipment) do
            
             game.print(equipment.name);
            if (equipment and equipment.valid) then
                if equipment.name == 'exoskeleton-equipment-custom' and exos_to_take > 0 then
                    discard = entity.grid.take({equipment=equipment})
                    exos_to_take = exos_to_take - 1;
                else
                    if equipment.name == 'fusion-reactor-equipment-custom' and reactors_to_take > 0 then
                        discard = entity.grid.take({equipment=equipment})
                        reactors_to_take = reactors_to_take - 1;
                    end
                end
            end
        end
    end
end

local reevaluate = function(event)

    local player = game.get_player(event.player_index)
    if player.opened_gui_type ~= defines.gui_type.entity then return end
  
  
    local opened = player.opened
    if not (opened and opened.valid) then return end

    local spidertron_base_speed = 1;
    for key, value in pairs(opened.grid.get_contents()) do
        if game.equipment_prototypes[key].type == "movement-bonus-equipment" then
            if key ~= "exoskeleton-equipment-custom" then
                spidertron_base_speed = spidertron_base_speed + game.equipment_prototypes[key].movement_bonus * value
            end
        end
    end
    local desired_speed = spidertron_base_speed * desired_percentage;
    local desired_speed_percent = (100 * desired_speed)
    local exoskeletons_needed = desired_speed_percent - (spidertron_base_speed * 100)
    local exoskeletons_current = opened.grid.get_contents()["exoskeleton-equipment-custom"];
 
    if exoskeletons_current ~= nil then
        exoskeletons_needed = exoskeletons_needed - exoskeletons_current;
    end
    if exoskeletons_needed ~= 0 then
        add_exos(exoskeletons_needed, opened);
    end
end

local adjust_spidertron = function(event)
    local entity = event.created_entity;
    if entity.type == 'spider-vehicle' then
        local iterations = (100 * desired_percentage) - 100
        add_exos(iterations, entity);
    end
end

local lib = {}

lib.events =
{
    [defines.events.on_player_placed_equipment] = reevaluate,
    [defines.events.on_player_removed_equipment] = reevaluate,
    [defines.events.on_built_entity] = adjust_spidertron,
}


return lib