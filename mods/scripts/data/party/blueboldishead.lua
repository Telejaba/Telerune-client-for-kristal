local character, super = Class(PartyMember, "bluebold")

function character:init()
    super.init(self)

    -- Display name
    self.name = "Blue"

    -- Actor (handles overworld/battle sprites)
    self:setActor("blueboldishead")
    self:setLightActor("blueboldishead_lw")

    -- Display level (saved to the save file)
    self.level = 1
    -- Default title / class (saved to the save file)
    self.title = "BlueBoldIsHead\nSome goofball toad\nthat just likes fun"

    -- Determines which character the soul comes from (higher number = higher priority)
    self.soul_priority = 2
    -- The color of this character's soul (optional, defaults to red)
    self.soul_color = {0, 0.5, 1}

    -- Whether the party member can act / use spells
    self.has_act = true
    self.has_spells = false

    -- Whether the party member can use their X-Action
    self.has_xact = true
    -- X-Action name (displayed in this character's spell menu)
    self.xact_name = "T-Action"

    -- Current health (saved to the save file)
    self.health = 115

    -- Base stats (saved to the save file)
    self.stats = {
        health = 115,
        attack = 13,
        defense = 15,
        magic = 0.5
    }
    -- Max stats from level-ups
     self.max_stats = {
        health = 265
    }

    -- Weapon icon in equip menu
    self.weapon_icon = "ui/menu/equip/bbgum"

    -- Equipment (saved to the save file)
    self:setWeapon(nil)

    self:setArmor(1, nil)
    self:setArmor(2, nil)

    -- Default light world equipment item IDs (saves current equipment)
    self.lw_weapon_default = "light/pencil"
    self.lw_armor_default = "light/bandage"

    -- Character color (for action box outline and hp bar)
    self.color = {0, 0.5, 1}
    -- Damage color (for the number when attacking enemies) (defaults to the main color)
    self.dmg_color = {0, 1, 1}
    -- Attack bar color (for the target bar used in attack mode) (defaults to the main color)
    self.attack_bar_color = nil
    -- Attack box color (for the attack area in attack mode) (defaults to darkened main color)
    self.attack_box_color = {0, 1, 1}
    -- X-Action color (for the color of X-Action menu items) (defaults to the main color)
    self.xact_color = nil

    -- Head icon in the equip / power menu
    self.menu_icon = "party/blueboldishead/head"
    -- Path to head icons used in battle
    self.head_icons = "party/blueboldishead/icon"
    -- Name sprite
    self.name_sprite = "party/blueboldishead/name"

    -- Effect shown above enemy after attacking it
    self.attack_sprite = "effects/attack/cut"
    -- Sound played when this character attacks
    self.attack_sound = "egg"
    -- Pitch of the attack sound
    self.attack_pitch = 1

    -- Battle position offset (optional)
    self.battle_offset = {2, 1}
    -- Head icon position offset (optional)
    self.head_icon_offset = nil
    -- Menu icon position offset (optional)
    self.menu_icon_offset = nil

    -- Message shown on gameover (optional)
    self.gameover_message = nil

    -- Character flags (saved to the save file)
    self.flags = {}

    -- Temporary stat buffs in battles
    self.stat_buffs = {}

    -- Light world EXP requirements
    self.lw_exp_needed = {
        [ 1] = 0,
        [ 2] = 10,
        [ 3] = 30,
        [ 4] = 70,
        [ 5] = 120,
        [ 6] = 200,
        [ 7] = 300,
        [ 8] = 500,
        [ 9] = 800,
        [10] = 1200,
        [11] = 1700,
        [12] = 2500,
        [13] = 3500,
        [14] = 5000,
        [15] = 7000,
        [16] = 10000,
        [17] = 15000,
        [18] = 25000,
        [19] = 50000,
        [20] = 99999
    }
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:onPowerSelect(menu)
    if Utils.random() < ((Game.chapter == 1) and 0.02 or 0.04) then
        menu.kris_dog = true
    else
        menu.kris_dog = false
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1 then
        local icon = Assets.getTexture("ui/menu/icon/mushroom")
        Draw.draw(icon, x+125, y+5, 0, 2, 2)
        love.graphics.print("Mushroom:", x, y)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        Draw.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Cooking:", x, y)
        Draw.draw(icon, x+110, y+6, 0, 2, 2)
        return true
    end
end

return character