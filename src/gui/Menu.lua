--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A Menu is simply a Selection layered onto a Panel, at least for use in this
    game. More complicated Menus may be collections of Panels and Selections that
    form a greater whole.
]]

Menu = Class{}

function Menu:init(def)
    self.panel = Panel(def.x, def.y, def.width, def.height, def.border)

    self.selection = Selection {
        cursor = def.cursor,
        currentSelection = def.currentSelection,
        font = def.font,
        items = def.items,
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height,
        rows = def.rows,
        columns = def.columns,
        padding = def.padding,
        border = def.border,
        type = def.type,
    }
end

function Menu:update(dt)
    self.selection:update(dt)
end

function Menu:render()
    self.panel:render()
    self.selection:render()
end