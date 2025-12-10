local function drawRetrowave()
    local w, h = draw.GetScreenSize()
    local midX = math.floor(w / 2)
    local oceanY = math.floor(h / 2)
    local sunRadius = 70
    local sunY = oceanY - sunRadius + 10
    local time = globals.CurTime()

    -- Colors
    local stripeColor = {255, 75, 160}
    local topColor = {255, 240, 100}
    local gridColor = {255, 0, 255, 100}
    local glowColor = {0, 255, 255, 20}

    -- === SUN (gradient semicircle with stripes) ===
    local sunTop = sunY - sunRadius
    for i = 0, sunRadius do
        local y = sunTop + i
        -- gradient blend (ensure ints)
        local t = i / sunRadius
        local r = math.floor(topColor[1] + (stripeColor[1] - topColor[1]) * t)
        local g = math.floor(topColor[2] + (stripeColor[2] - topColor[2]) * t)
        local b = math.floor(topColor[3] + (stripeColor[3] - topColor[3]) * t)

        -- semicircle mask
        local dy = i - sunRadius
        local dx = math.sqrt(math.max(0, sunRadius ^ 2 - dy ^ 2))
        local x1, x2 = math.floor(midX - dx), math.floor(midX + dx)

        -- top half solid, bottom half striped
        if i < sunRadius * 0.5 or (i % 4 < 2) then
            draw.Color(r, g, b, 255)
            draw.FilledRect(x1, y, x2, y + 1)
        end
    end

    -- === Horizon glow ===
    draw.Color(glowColor[1], glowColor[2], glowColor[3], glowColor[4])
    draw.FilledRect(0, oceanY - 2, w, oceanY + 2)

    -- === Ocean grid (very lightweight) ===
    local gridLines = 9
    local spacingY = h / 2 / gridLines
    for i = 1, gridLines do
        local t = i / gridLines
        local y = oceanY + (t ^ 1.4) * (h / 2)
        local wave = math.sin(time * 2 + i) * 2
        draw.Color(gridColor[1], gridColor[2], gridColor[3], gridColor[4])
        draw.Line(0, math.floor(y + wave), w, math.floor(y - wave))
    end

    local vanishX = midX
    local stepX = 60
    for x = -w / 2, w / 2, stepX do
        local sx = math.floor(vanishX + x)
        draw.Color(gridColor[1], gridColor[2], gridColor[3], gridColor[4])
        draw.Line(sx, h, vanishX, oceanY)
    end
end

callbacks.Register("Draw", "RetrowaveVisual", drawRetrowave)
