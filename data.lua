require("prototypes/external-drive-unit")
require("prototypes/torment-nexus")
require("prototypes/breaker-box")

local n = 1
local profile = {}

while n < 100 do
    table.insert(profile, 1 / n)
    n = n + 1
end

data.raw.beacon.beacon.profile = profile
data.raw.beacon.beacon.distribution_effectivity = 1
data.raw.beacon.beacon.distribution_effectivity_bonus_per_quality_level = 0.1
data.raw.beacon.beacon.allowed_effects = { "speed", "consumption", "productivity", "pollution", "quality" }
data.raw.beacon.beacon.allowed_module_categories = { "speed", "efficiency" }

if settings.startup["pf-overclocked-modules"].value and (mods["enable-all-feature-flags"] or mods["space-age"]) then
    require("prototypes/overclocked-modules")
end

if tune_up_data then
    tune_up_data.recipes["breaker-box"] = {
        categories = { "tuning-up" },
        count = 1,
        energy_required = 1,
        ingredients = { { { "processing-unit", 1 }, {"copper-cable", 5, "byproduct"} } },
        scrap_types = { { "electrical-scrap", 4 }, { "electronic-scrap", 1 } },
        scrap_yield = 30,
    }

    tune_up_data.recipes["external-drive-unit"] = {
        categories = { "tuning-up" },
        count = 1,
        energy_required = 1,
        ingredients = { { { "pump", 2 }, { "electronic-circuit", 5 } } },
        scrap_types = { { "plumbing-scrap", 5 }, { "robotic-scrap", 1 } },
        scrap_yield = mods["IfNickel"] and 30 or 20
    }

    tune_up_data.ReplaceIngredientProportional("centrifuge", "electric-engine-unit", "external-drive-unit", 0.2)
end

data:extend({
    {
        type = "tips-and-tricks-item",
        name = "new-beacon-mechanics",
        tag = "[item=beacon]",
        order = "oa",
        indent = 0,
        trigger =
        {
            type = "or",
            triggers =
            {
                {
                    type = "unlock-recipe",
                    recipe = "breaker-box"
                },
                {
                    type = "unlock-recipe",
                    recipe = "beacon"
                },
                {
                    type = "unlock-recipe",
                    recipe = "external-drive-unit"
                },
                {
                    type = "unlock-recipe",
                    recipe = "torment-nexus"
                }
            }
        },
        simulation = {
            init_update_count = 600,
            init =
            [[
        game.simulation.camera_zoom = 2
        game.simulation.camera_alt_info = true
        game.surfaces[1].build_checkerboard{{-80, -80}, {80, 80}}
        game.surfaces[1].create_entities_from_blueprint_string
        {
          string = "0eNrtW9tyozgQ/ReeYQqhG8qvpFwubMseajCwArLxpvzvK0x8SYxsHVyz44fNS8oIuvu01E2flvgIFkWna5OXbfDyEeTLqmyCl9ePoMk3ZVb018psq4OXYKEzOxjswyAvV/o9eCH7cOQ2/V4b3TRRa7KyqSvTRgtdtBePJftZGOiyzdtcD6oOP3bzstsutLFyw6OsvFznpR2Klj910wZhUFeNfcxaYfVZUZT/4GGws4+Q5Ac/qBgemDe6bfNy0/Q3Gr2t3vS8s2NFq41ezfNWb+1Qazq970F8MyC5NqDOa31TP3Xr/5RVdAuTL7PygEObpVWabfQBrjXHXsnaztjfiRW5rVb9I1kbFTqzyMespBPclMQT3LTOikaHwXB5mLGjYlOVUV1kbe+bZdX1a4jE8bX9F2tmNoaFnbA4HC2+OHpEAg+/L8CiylZ25FqW/LJkVrnRy2GY2Ilvd/Xg0rrrF+2VHnHSs7bA7ir5dPiFEnbSUXWtQ4m85w55zx1peCcer2Wm32Lpi2NGVKgvRkZtFW2MXQKrm6Kpl2gSf/Wyv+0j/h6Tf04xurA32riMdKnNZhfZPKjNOluOeV19gug1LLr1Wpt5k/+jD2v++DemLcEnQ4GTQSjoMQV6jMEYWIxi4BiGswJPDOfYbbpF02aHW6/FktM0jwmRuCMI6ogUdAQBHaFwDAmIIQFD+KzAD0NCcAwUxZCAGCiIgeIYGIqBgRgYiIHjGDiKQYAYOIhhQkwLFAMa0wLEMCGmJYiBojEtMQx0QkyjVQtNvMsWdqNsGTUffAczsGqhE97BaB1B+Z3S80Kio/Skwl8Ec4iQ/iK4Q8RlBWxLOktSo5XJ33TUWeZzU6IYONJAfizZyVcXLK6ptV5Flt90hY5ocL7R3lfO8/LN2lGZ3fDg+Zdd2bbgWP4KXuKeAc3GLFaTLZZ/xmIWT7Y4/UMWEzBEwTKZ4aU+R8tkRh/RwbxgnDPNoit+WVLUaNOO8dwLyfy7ZBuB29yYynx2Wkb08Al61JWeMclgycBBLsHwkoGjNIClj+hwZGemHhHqyNf8nAiyptHbRZGXm2ibLX/mZR/Bt0QOuct6Iq9PLaWmzW0YH6/O/+qywqqzo2VltlkRODNHbWzSsD5967thcAJhFwkkdIwQ50jiHKGudMSJ9/on2PrnIHXhIIXkE5JQ4k5Co+uf+2eh5JEsxPkEPX6zgGYhkARzCcoHCSo/Z6DP7v+1SPafVSGhY4Q4w0uB7gG5rwD5EAd5qQCrFQ5yRoEmCZDPCZAQcZAQCebV0OPqVkNPXES/0dkvbaJF9X5DinQvcr1e58tcl8vd71rprpHEOeJ8+YhvyclyYG0GLuyan1vVsMfWibybTQT59o54omwiUsT8p0uGQgHmH/cJn8d8GcMFh6AY65He1diFZO5TB8hkgmSvCkNSNIgF9QniG3uTeBdK3Ghaj04Ef0SFg/hI8YhQB/GREiQ+gv1PfHq/pd4BwcCAAGs+AdZ86YQ8xLHln5JHVPhxq9Q/I3Es16V0gmSvqU0ZnOv4QwVLOiEPCXCuJ2QlCarwKLvk85ZdaYqY/3RlV6oA85+v7FIT0l2KrU81Id0pUEUCZw71WJWk8P6YjEFQ4M6+BFvcCs9+koAQwP6YBLuUCu/SywSEAO7rS7DFp/B+vaQYhMOJTQgD2EYkMR7ikqEgwGaWZCiICSHNURBoTHMUxISgFigINKoFCkJ69f2kvHmQL8a316REXQGyESnRg6z4+1mC72dCwDa0hE/j4rvmUqEgwF60RA/ITjghm8YoCPCEbIqekCXC+xh9zyAdpt9nVoRIv3P0Ry2T+Bu5OEh77xuJlP6WT0nIxVlbfxMmfaYxmDALg7+tk3r68Gpnk4eChXwWvvb/wj5z8tlsIA49Izl9+hMGb9o0B1u4SBRnCVOCUqmS/f5f6lYjWQ==",
          position = {0,0},
        }

        game.forces.player.technologies["railway"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-1"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-2"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-3"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-4"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-5"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-6"].researched = true
        game.forces.player.technologies["inserter-capacity-bonus-7"].researched = true

      ]]
        }
    }
})
