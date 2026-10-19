local item_sounds = require("__base__.prototypes.item_sounds")

local n = 5
local profile = {1, 1, 1, 1}

while n < 100 do
    table.insert(profile, 4/n)
    n = n + 1
end

local distribution_per_quality = 0.05
if mods["tuner-upper"] then
    if settings.startup["tuner-upper-nerf-quality-power"].value then
        distribution_per_quality = 0.1
    end
end

local consumer_pipes = table.deepcopy(require("__base__/prototypes/entity/assembler-pictures").assembler2pipepictures)
consumer_pipes.south =
{
  filename = "__pf-beacon-rework__/graphics/entity/pipe_connector.png",
  priority = "extra-high",
  width = 88,
  height = 61,
  shift = util.by_pixel(0, -31.25),
  scale = 0.5
}

data:extend({
    {
        type = "beacon",
        name = "external-drive-unit",
        icon = "__pf-beacon-rework__/graphics/entity/external-drive-unit-full.png",
        icon_size = 128,
        max_health = 200,
        flags = {"placeable-neutral","placeable-player", "player-creation"},
        fast_replaceable_group = "external-drive-unit",
        minable = {mining_time = 0.3, result = "external-drive-unit"},
        dying_explosion = "beacon-explosion",
        corpse = "beacon-remnants",
        damaged_trigger_effect = table.deepcopy(data.raw.beacon.beacon.damaged_trigger_effect),
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        module_slots = 1,
        allowed_effects = {"consumption", "speed", "quality", "productivity", "pollution"},
        allowed_module_categories = {"speed"},
        distribution_effectivity = 0.75,
        distribution_effectivity_bonus_per_quality_level = distribution_per_quality,
        profile = profile,
        supply_area_distance = 1,
        beacon_counter = "same_type",
        animation = {
            layers = {
            {
                filename = "__pf-beacon-rework__/graphics/entity/external-drive-unit.png",
                width = 64,
                height = 128,
                frame_count = 1,
                line_length = 1,
                scale = 0.5,
                shift = {0, -0.5}
            }
            }
        },
        radius_visualisation_picture = table.deepcopy(data.raw.beacon.beacon.radius_visualisation_picture),
        impact_category = "metal-large",
        open_sound = {filename = "__base__/sound/machine-open.ogg", volume = 0.5},
        close_sound = {filename = "__base__/sound/machine-close.ogg", volume = 0.5},
        working_sound = table.deepcopy(data.raw["generator"]["steam-turbine"].working_sound),
        energy_usage = "100kW",
        energy_source = {
            type="electric",
            emissions_per_minute = {pollution = 1},
            usage_priority = "secondary-input"
        }
    },
    {
        type = "storage-tank",
        name = "external-drive-unit-lubricant-consumer",
        icon = "__pf-beacon-rework__/graphics/entity/external-drive-unit-full.png",
        icon_size = 128,
        max_health = 200,
        flags = {"not-blueprintable", "not-deconstructable", "placeable-off-grid", "no-automated-item-removal", "no-automated-item-insertion", "not-flammable", "not-upgradable", "not-selectable-in-game", "not-in-kill-statistics", "no-copy-paste"},
        fast_replaceable_group = "external-drive-unit",
        dying_explosion = "beacon-explosion",
        damaged_trigger_effect = table.deepcopy(data.raw.beacon.beacon.damaged_trigger_effect),
        heating_energy = mods["space-age"] and "20kW" or nil,
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        selection_box = {{0, 0}, {0, 0}},
        selection_priority = 1,
        show_fluid_icon = false,
        quality_indicator_scale = 0,
        pictures = {
            picture = {
                layers = {
                    {
                        filename = "__pf-beacon-rework__/graphics/entity/external-drive-unit.png",
                        width = 64,
                        height = 128,
                        frame_count = 1,
                        line_length = 1,
                        scale = 0.5,
                        shift = {0, -0.5}
                    }
              }
            }
        },
        window_bounding_box = {{0, 0}, {0, 0}},
        flow_length_in_ticks = 1,
        fluid_box = {
            production_type = "none",
            pipe_picture = consumer_pipes,
            pipe_covers = pipecoverspictures(),
            volume = 200,
            filter = "lubricant",
            pipe_connections =
            {
                {
                    flow_direction="input-output",
                    direction = defines.direction.north,
                    position = {0, 0},
                },
                {
                    flow_direction="input-output",
                    direction = defines.direction.east,
                    position = {0, 0},
                },
                {
                    flow_direction="input-output",
                    direction = defines.direction.south,
                    position = {0, 0},
                },
                {
                    flow_direction="input-output",
                    direction = defines.direction.west,
                    position = {0, 0},
                }
            },
            secondary_draw_orders = {north = -1, west = -1, east = -1}
        }
    },
    {
        type = "item",
        name = "external-drive-unit",
        icon = "__pf-beacon-rework__/graphics/entity/external-drive-unit-full.png",
        icon_size = 128,
        subgroup = "module",
        order = "a[beacon]b",
        place_result = "external-drive-unit",
        stack_size = 50,
        weight = 50 * kg,
        inventory_move_sound = item_sounds.mechanical_inventory_move,
        pick_sound = item_sounds.mechanical_inventory_pickup,
        drop_sound = item_sounds.mechanical_inventory_move
    },
    {
      type="sprite",
      name="pf-fluid-alert",
      filename="__core__/graphics/icons/alerts/fluid-icon-red.png",
      size=64, icon_mipmaps=4,
      draw_as_glow=true
    },
    {
        type = "recipe",
        name = "external-drive-unit",
        ingredients = {
            {type="item", name="pipe", amount=5},
            {type="item", name="electric-engine-unit", amount=5},
            {type="item", name="advanced-circuit", amount=5},
            {type="fluid", name="lubricant", amount=50}
        },
        results = {
            {type="item", name="external-drive-unit", amount=1}
        },
        energy_required = 3,
        categories = {"crafting-with-fluid"},
        enabled = false
    },
    {
        type = "technology",
        name = "external-drive-unit",
        icon = "__pf-beacon-rework__/graphics/entity/external-drive-unit-full.png",
        icon_size = 128,
        unit = {
            count = 250,
            time = 30,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1}
            }
        },
        prerequisites = {"electric-engine", "speed-module"},
        effects = {
            {
                type = "unlock-recipe",
                recipe = "external-drive-unit"
            }
        }
    }
})
