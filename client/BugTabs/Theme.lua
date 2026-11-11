local _, AddonNamespace = ...
-- Thème sleek sombre + accent CYAN (identité dev de BugTabs). Remplace l'ancienne table Theme de Core.lua.
AddonNamespace.Theme = {
    FONT_DIR  = "Interface\\AddOns\\BugTabs\\Media\\Fonts\\",
    PANEL_TEX = "Interface\\AddOns\\BugTabs\\Media\\Textures\\panel.tga",
    radius    = 12,
    spacing   = { xs = 4, sm = 8, md = 12, lg = 16 },

    -- Polices du client WoW couvrant nativement chaque écriture. Inter
    -- (embarquée) ne couvre que le latin — le coréen, le chinois et le
    -- cyrillique tombent sur STANDARD_TEXT_FONT (le joueur koKR voit sinon
    -- des carrés). STANDARD_TEXT_FONT est déjà le bon fallback par client :
    -- ça reste le mécanisme, on explicite seulement les cas CJK/cyrillique.
    LEGACY_FONT_LOCALES = {
        koKR = true, zhCN = true, zhTW = true, ruRU = true,
    },

    bg        = { 0.055, 0.055, 0.071, 1 },
    panel     = { 0.086, 0.086, 0.110, 1 },
    panelAlt  = { 0.102, 0.102, 0.129, 1 },
    panelHover = { 0.125, 0.125, 0.157, 1 },
    codeBg    = { 0.043, 0.043, 0.059, 1 },
    border    = { 0.137, 0.137, 0.173, 1 },
    accent     = { 0.0, 0.902, 1.0, 1 },
    accentDim  = { 0.0, 0.902, 1.0, 0.12 },
    accentText = { 0.024, 0.133, 0.169, 1 },
    text     = { 0.910, 0.910, 0.933, 1 },
    textDim  = { 0.545, 0.545, 0.596, 1 },
    label    = { 0.357, 0.357, 0.400, 1 },
    error    = { 0.878, 0.333, 0.333, 1 },
    warning  = { 0.941, 0.706, 0.161, 1 },
    locals   = { 0.420, 0.550, 0.630, 1 },
}

-- Copie d'une couleur de thème avec une autre opacité (voiles, pastilles).
function AddonNamespace.Theme:Alpha(c, a)
    return { c[1], c[2], c[3], a }
end

function AddonNamespace.Theme:Font(role)
    if role == "semibold" then return self.FONT_DIR .. "Inter-SemiBold.ttf" end
    return self.FONT_DIR .. "Inter-Regular.ttf"
end

function AddonNamespace.Theme:Apply(fs, role, size, flags)
    local font = self:Font(role)
    -- Locales CJK/cyrillique : Inter n'a pas les glyphes -> police du client
    -- directement (SetLastError silencieux, STANDARD_TEXT_FONT couvre tout).
    if self.LEGACY_FONT_LOCALES[GetLocale()] then
        font = STANDARD_TEXT_FONT
    end
    local ok = fs:SetFont(font, size, flags or "")
    if not ok then fs:SetFont(STANDARD_TEXT_FONT, size, flags or "") end
    fs:SetShadowColor(0, 0, 0, 0.6)
    fs:SetShadowOffset(1, -1)
    return fs
end

-- Convertit une couleur de thème {r,g,b} en code hex "rrggbb" (pour |cffRRGGBB...|r).
function AddonNamespace.Theme:Hex(c)
    return string.format("%02x%02x%02x",
        math.floor(c[1] * 255 + 0.5), math.floor(c[2] * 255 + 0.5), math.floor(c[3] * 255 + 0.5))
end
