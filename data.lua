

data:extend({
  {
    type = "movement-bonus-equipment",
    name = "DoubleSpeedSpidertron_exoskeleton-equipment",
    sprite =
    {
      filename = "__base__/graphics/equipment/exoskeleton-equipment.png",
      width = 64,
      height = 128,
      priority = "medium",
      hr_version =
      {
        filename = "__base__/graphics/equipment/hr-exoskeleton-equipment.png",
        width = 128,
        height = 256,
        priority = "medium",
        scale = 0.5
      }
    },
    shape =
    {
      width = 0,
      height = 0,
      type = "full"
    },
    energy_source =
    {
      type = "void",
      usage_priority = "secondary-input"
    },
    energy_consumption = "0.1W",
    movement_bonus = 0.01,
    categories = {"armor"}
  },
  {
    type = "item",
    name = "DoubleSpeedSpidertron_exoskeleton-equipment",
    icon = "__base__/graphics/icons/exoskeleton-equipment.png",
    icon_size = 64, icon_mipmaps = 4,
    placed_as_equipment_result = "exoskeleton-equipment",
    subgroup = "equipment",
    order = "d[exoskeleton]-a[exoskeleton-equipment]",
    default_request_amount = 5,
    stack_size = 20
  },
  {
    type = "generator-equipment",
    name = "DoubleSpeedSpidertron_fusion-reactor-equipment",
    sprite =
    {
      filename = "__base__/graphics/equipment/fusion-reactor-equipment.png",
      width = 128,
      height = 128,
      priority = "medium",
      hr_version =
      {
        filename = "__base__/graphics/equipment/hr-fusion-reactor-equipment.png",
        width = 256,
        height = 256,
        priority = "medium",
        scale = 0.5
      }
    },
    shape =
    {
      width = 0,
      height = 0,
      type = "full"
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "primary-output"
    },
    power = "0.1W",
    categories = {"armor"}
  },
  {
    type = "item",
    name = "DoubleSpeedSpidertron_fusion-reactor-equipment",
    icon = "__base__/graphics/icons/fusion-reactor-equipment.png",
    icon_size = 64, icon_mipmaps = 4,
    placed_as_equipment_result = "DoubleSpeedSpidertron_fusion-reactor-equipment",
    subgroup = "equipment",
    order = "a[energy-source]-b[fusion-reactor]",
    default_request_amount = 1,
    stack_size = 1
  },
})
