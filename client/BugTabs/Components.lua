local _, AddonNamespace = ...
local Theme = AddonNamespace.Theme
AddonNamespace.Components = {}
local Components = AddonNamespace.Components

local PANEL_TEX = Theme.PANEL_TEX
local TC = 0.25 -- inset texcoord : 16/64 (coins de la texture panel.tga)

-- 9-slice portable (9 textures + SetTexCoord) — API anciennes, OK de Classic Era à Retail.
-- (On évite SetTextureSliceMargins, indisponible sur les vieux clients 1.15.x.)
local function BuildNineSlice(frame, layer, slice, inset, color)
    local function t()
        local tx = frame:CreateTexture(nil, layer)
        tx:SetTexture(PANEL_TEX); tx:SetVertexColor(color[1], color[2], color[3], color[4] or 1); return tx
    end
    local i = inset
    local tl, tr, bl, br = t(), t(), t(), t()
    local tm, bm, ml, mr, c = t(), t(), t(), t(), t()
    tl:SetSize(slice, slice); tl:SetPoint("TOPLEFT", i, -i); tl:SetTexCoord(0, TC, 0, TC)
    tr:SetSize(slice, slice); tr:SetPoint("TOPRIGHT", -i, -i); tr:SetTexCoord(1 - TC, 1, 0, TC)
    bl:SetSize(slice, slice); bl:SetPoint("BOTTOMLEFT", i, i); bl:SetTexCoord(0, TC, 1 - TC, 1)
    br:SetSize(slice, slice); br:SetPoint("BOTTOMRIGHT", -i, i); br:SetTexCoord(1 - TC, 1, 1 - TC, 1)
    tm:SetPoint("TOPLEFT", tl, "TOPRIGHT"); tm:SetPoint("BOTTOMRIGHT", tr, "BOTTOMLEFT"); tm:SetTexCoord(TC, 1 - TC, 0, TC)
    bm:SetPoint("TOPLEFT", bl, "TOPRIGHT"); bm:SetPoint("BOTTOMRIGHT", br, "BOTTOMLEFT"); bm:SetTexCoord(TC, 1 - TC, 1 - TC, 1)
    ml:SetPoint("TOPLEFT", tl, "BOTTOMLEFT"); ml:SetPoint("BOTTOMRIGHT", bl, "TOPRIGHT"); ml:SetTexCoord(0, TC, TC, 1 - TC)
    mr:SetPoint("TOPLEFT", tr, "BOTTOMLEFT"); mr:SetPoint("BOTTOMRIGHT", br, "TOPRIGHT"); mr:SetTexCoord(1 - TC, 1, TC, 1 - TC)
    c:SetPoint("TOPLEFT", tl, "BOTTOMRIGHT"); c:SetPoint("BOTTOMRIGHT", br, "TOPLEFT"); c:SetTexCoord(TC, 1 - TC, TC, 1 - TC)
    return { tl, tr, bl, br, tm, bm, ml, mr, c }
end

-- Panneau arrondi : couche bordure + couche remplissage (inset 1px). Teinté via SetPanelColor.
-- opts = { fill = Theme.panel, border = Theme.border, slice = Theme.radius }
function Components:CreatePanel(parent, opts)
    opts = opts or {}
    local fill   = opts.fill   or Theme.panel
    local border = opts.border or Theme.border
    local slice  = opts.slice  or (Theme.radius or 12)
    local p = CreateFrame("Frame", nil, parent)
    p._border = BuildNineSlice(p, "BACKGROUND", slice, 0, border)
    p._fill   = BuildNineSlice(p, "BORDER", slice, 1, fill)
    function p:SetPanelColor(fl, bd)
        if bd then for _, tx in ipairs(self._border) do tx:SetVertexColor(bd[1], bd[2], bd[3], bd[4] or 1) end end
        if fl then for _, tx in ipairs(self._fill)   do tx:SetVertexColor(fl[1], fl[2], fl[3], fl[4] or 1) end end
    end
    return p
end
