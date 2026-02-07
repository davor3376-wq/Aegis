--[[
    Aegis Ultimate - The Brain (Data Manifest)
    Single Source of Truth for the Swarm Protocol.
]]

local Manifest = {}

-- 1. FIELDS (25 Fields with Vector3 Centers and Nectar Multipliers)
-- Note: Vector3 coordinates are approximations for the game map.
Manifest.Fields = {
    ["Sunflower Field"] = {
        Center = Vector3.new(100, 5, 100),
        Size = Vector3.new(60, 0, 60), -- Used for Pattern Scaling
        Nectar = { Motivating = 1.0, Satisfying = 1.1 }
    },
    ["Dandelion Field"] = {
        Center = Vector3.new(50, 5, 150),
        Size = Vector3.new(50, 0, 50),
        Nectar = { Comforting = 1.2 }
    },
    ["Mushroom Field"] = {
        Center = Vector3.new(-50, 5, 100),
        Size = Vector3.new(40, 0, 40),
        Nectar = { Motivating = 1.2, Refreshing = 1.1 }
    },
    ["Blue Flower Field"] = {
        Center = Vector3.new(150, 5, 50),
        Size = Vector3.new(55, 0, 55),
        Nectar = { Refreshing = 1.3 }
    },
    ["Clover Field"] = {
        Center = Vector3.new(200, 5, 150),
        Size = Vector3.new(60, 0, 60),
        Nectar = { Invigorating = 1.1 }
    },
    ["Spider Field"] = {
        Center = Vector3.new(-20, 5, 200),
        Size = Vector3.new(45, 0, 45),
        Nectar = { Satisfying = 1.0 }
    },
    ["Bamboo Field"] = {
        Center = Vector3.new(80, 5, 250),
        Size = Vector3.new(50, 0, 90),
        Nectar = { Comforting = 1.1, Refreshing = 1.2 }
    },
    ["Strawberry Field"] = {
        Center = Vector3.new(-80, 5, 250),
        Size = Vector3.new(50, 0, 60),
        Nectar = { Invigorating = 1.3, Motivating = 1.1 }
    },
    ["Pineapple Patch"] = {
        Center = Vector3.new(250, 15, 100),
        Size = Vector3.new(50, 0, 50),
        Nectar = { Satisfying = 1.4 }
    },
    ["Stump Field"] = {
        Center = Vector3.new(-100, 20, 100),
        Size = Vector3.new(60, 0, 60),
        Nectar = { Motivating = 1.0 }
    },
    ["Cactus Field"] = {
        Center = Vector3.new(300, 10, 200),
        Size = Vector3.new(55, 0, 55),
        Nectar = { Refreshing = 1.1, Invigorating = 1.1 }
    },
    ["Pumpkin Patch"] = {
        Center = Vector3.new(-150, 10, 200),
        Size = Vector3.new(60, 0, 60),
        Nectar = { Satisfying = 1.2, Comforting = 1.1 }
    },
    ["Pine Tree Forest"] = {
        Center = Vector3.new(350, 15, 250),
        Size = Vector3.new(70, 0, 70),
        Nectar = { Satisfying = 1.3 }
    },
    ["Rose Field"] = {
        Center = Vector3.new(-200, 15, 250),
        Size = Vector3.new(60, 0, 60),
        Nectar = { Motivating = 1.4, Invigorating = 1.2 }
    },
    ["Mountain Top Field"] = {
        Center = Vector3.new(0, 30, -50),
        Size = Vector3.new(80, 0, 80),
        Nectar = { Invigorating = 1.0 }
    },
    ["Coconut Field"] = {
        Center = Vector3.new(500, 15, 300),
        Size = Vector3.new(70, 0, 70),
        Nectar = { Comforting = 1.5 }
    },
    ["Pepper Patch"] = {
        Center = Vector3.new(500, 25, 400),
        Size = Vector3.new(65, 0, 65),
        Nectar = { Invigorating = 1.5, Motivating = 1.1 }
    },
    -- Placeholder for others to reach 25 if needed, typically top tier fields are fewer.
    -- Common ones listed above cover most farming strategies.
}

-- 2. BOSSES (8 Bosses with Specific Settings)
Manifest.Bosses = {
    ["Tunnel Bear"] = {
        Coordinates = Vector3.new(200, 10, 50),
        RespawnTime = 0,
        Settings = { "Auto Kill", "Tween Method" }
    },
    ["King Beetle"] = {
        Coordinates = Vector3.new(150, 5, 200),
        RespawnTime = 0,
        Settings = { "Auto Kill", "Auto Amulet", "Keep Old" }
    },
    ["Stump Snail"] = {
        Coordinates = Vector3.new(-100, 20, 100),
        RespawnTime = 0,
        Settings = { "Train Snail", "Auto Shell Amulet", "Keep Old" } -- "Train" vs "Kill"
    },
    ["Coconut Crab"] = {
        Coordinates = Vector3.new(500, 15, 300),
        RespawnTime = 0,
        Settings = { "Auto Kill", "Kill Method: Tween" } -- Tween/Stationary
    },
    ["Commando Chick"] = {
        Coordinates = Vector3.new(50, 15, -20),
        RespawnTime = 0,
        Settings = { "Auto Kill", "Kill Method: Tween", "Respawn When Shell", "Help Alt" }
    },
    ["Mondo Chick"] = {
        Coordinates = Vector3.new(0, 30, -50), -- Mountain Top
        RespawnTime = 0,
        Settings = { "Auto Kill", "Time To Kill: 15m", "Prepare Time: 10s" }
    },
    ["Windy Bee"] = {
        Coordinates = Vector3.new(0, 0, 0), -- Dynamic, but spawns in fields
        RespawnTime = 0,
        Settings = { "Auto Kill", "Donate Cloud Vials", "Min Level: 5", "Max Level: 15" }
    },
    ["Vicious Bee"] = {
        Coordinates = Vector3.new(0, 0, 0), -- Dynamic (Spike Field)
        RespawnTime = 0,
        Settings = { "Auto Kill", "Server Hop" }
    }
}

-- 3. NPCs (10 NPCs for Quests)
Manifest.NPCs = {
    ["Black Bear"] = { Coordinates = Vector3.new(110, 5, 110) },
    ["Brown Bear"] = { Coordinates = Vector3.new(210, 5, 160) },
    ["Panda Bear"] = { Coordinates = Vector3.new(90, 5, 260) },
    ["Polar Bear"] = { Coordinates = Vector3.new(-100, 5, 50) }, -- Approximate
    ["Science Bear"] = { Coordinates = Vector3.new(160, 15, 60) }, -- Requires jumping path
    ["Dapper Bear"] = { Coordinates = Vector3.new(30, 5, 300) },
    ["Mother Bear"] = { Coordinates = Vector3.new(-40, 5, 100) },
    ["Spirit Bear"] = { Coordinates = Vector3.new(500, 15, 350) }, -- Petal area
    ["Bucko Bee"] = { Coordinates = Vector3.new(160, 5, 40) },
    ["Riley Bee"] = { Coordinates = Vector3.new(-100, 5, 240) },
    ["Honey Bee"] = { Coordinates = Vector3.new(100, 20, 100) },
    ["Onett"] = { Coordinates = Vector3.new(0, 40, -50) }, -- Top of mountain
    ["Stick Bug"] = { Coordinates = Vector3.new(-50, 5, 80) },
    ["Gummy Bear"] = { Coordinates = Vector3.new(0, 100, 0) }, -- Gummy Lair
    ["Bee Bear"] = { Coordinates = Vector3.new(120, 5, 120) } -- Beesmas
}

-- 4. TOKENS (Priority List)
Manifest.Tokens = {
    "Bubbles", "Fire", "Precise Mark", "Fuzz Bomb", "Petal", "Mark",
    "Coconut", "Cloud", "Meteor", "Festive Gift", "Token Link"
}

-- 5. FARMING PATTERNS
Manifest.Patterns = {
    ["Snake"] = "Snake",
    ["Super-Spiral"] = "Super-Spiral",
    ["E_lol"] = "E_lol", -- Optimized square pattern
    ["Corner-X"] = "Corner-X"
}

-- 6. TOYS & DISPENSERS
Manifest.Toys = {
    ["Samovar"] = { Coordinates = Vector3.new(50, 5, 50), Cooldown = 3600 },
    ["Glue Dispenser"] = { Coordinates = Vector3.new(60, 20, 60), Cooldown = 79200 }, -- 22h
    ["Coconut Dispenser"] = { Coordinates = Vector3.new(500, 15, 300), Cooldown = 14400 }, -- 4h
    ["Blueberry Dispenser"] = { Coordinates = Vector3.new(100, 5, 100), Cooldown = 3600 },
    ["Strawberry Dispenser"] = { Coordinates = Vector3.new(120, 5, 120), Cooldown = 3600 },
    ["Onett's Lid Art"] = { Coordinates = Vector3.new(300, 30, 300), Cooldown = 28800 }, -- 8h
    ["Wealth Clock"] = { Coordinates = Vector3.new(20, 5, 20), Cooldown = 3600 },
    ["Free Royal Jelly"] = { Coordinates = Vector3.new(10, 50, 10), Cooldown = 79200 },
    ["Ant Challenge"] = { Coordinates = Vector3.new(100, 5, 100), Cooldown = 7200 }
}

-- 7. PLANTERS (Nectar Types)
Manifest.Planters = {
    ["Red Clay Planter"] = { Nectar = "Invigorating" },
    ["Blue Clay Planter"] = { Nectar = "Refreshing" },
    ["Candy Planter"] = { Nectar = "Motivating" },
    ["Tacky Planter"] = { Nectar = "Satisfying" },
    ["Pesticide Planter"] = { Nectar = "Comforting" },
    ["Petal Planter"] = { Nectar = "Satisfying" }, -- And others
    ["The Planter of Plenty"] = { Nectar = "All" }
}

return Manifest
