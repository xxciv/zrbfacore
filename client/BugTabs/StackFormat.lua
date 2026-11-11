local _, AddonNamespace = ...
-- Mise en forme de la pile d'appels et des variables locales pour le panneau
-- d'erreurs : une ligne par frame, emplacement court ("Addon/Fichier.lua:12"),
-- frames de l'addon de l'onglet distinguées des autres. Pur travail de chaînes :
-- la copie garde la pile brute.

local SF = {}
AddonNamespace.StackFormat = SF

local SEP = "  " -- entre l'emplacement et la fonction

-- "Addon/sous/Fichier.lua" + dossier de l'addon, depuis un chemin Interface/AddOns.
local function AddonPath(path)
    path = path:gsub("\\", "/")
    local rel = path:match("[Aa]dd[Oo]ns/+(.+)$")
    if rel then return rel, rel:match("^[^/]+") end
end

-- Une ligne de pile -> { loc, func, addon? }. Une ligne qui n'est pas
-- "<où>: in <quoi>" garde son texte comme emplacement.
function SF.Parse(line)
    local where, what = line:match("^(.-): in (.+)$")
    if not where then return { loc = line, func = "" } end
    local frame = { loc = where }
    local path, num = where:match("^%[string \"@?(.-)\"%]:(%d+)$")
    if not path then path, num = where:match("^%[(.-)%]:(%d+)$") end
    if not path then path, num = where:match("^(.-):(%d+)$") end
    if path then
        local rel, addon = AddonPath(path)
        if rel then frame.loc, frame.addon = rel .. ":" .. num, addon end
    end
    -- "function <Interface/AddOns/Addon/Fichier.lua:451>" -> "function <Fichier.lua:451>"
    frame.func = (what:gsub("<(.-)>", function(inner)
        local base = inner:gsub("\\", "/"):match("([^/]+:%d+)$")
        if base then return "<" .. base .. ">" end
    end))
    return frame
end

local function Escape(s) return (s:gsub("|", "||")) end

-- Texte de FontString pour `stack`. owner = addon de l'onglet ("Blizzard_UI"
-- possède tous les dossiers Blizzard_*). hex = { loc, func, other } ("rrggbb").
function SF.Render(stack, owner, hex)
    local out = {}
    for line in stack:gmatch("[^\r\n]+") do
        local f = SF.Parse(line)
        local a = f.addon
        local own = a ~= nil and (a == owner or (owner == "Blizzard_UI" and a:find("^Blizzard_") ~= nil))
        local loc, func = Escape(f.loc), Escape(f.func)
        if own then
            out[#out + 1] = "|cff" .. hex.loc .. loc .. "|r"
                .. (func ~= "" and (SEP .. "|cff" .. hex.func .. func .. "|r") or "")
        else
            out[#out + 1] = "|cff" .. hex.other .. loc .. (func ~= "" and (SEP .. func) or "") .. "|r"
        end
    end
    return table.concat(out, "\n")
end

-- Locales "nom = valeur" : nom en hex.name, valeur en hex.value.
function SF.RenderLocals(locals, hex)
    local out = {}
    for line in locals:gmatch("[^\r\n]+") do
        local name, value = line:match("^([%a_][%w_]*) = (.*)$")
        if name then
            out[#out + 1] = "|cff" .. hex.name .. name .. "|r = |cff" .. hex.value .. Escape(value) .. "|r"
        else
            out[#out + 1] = "|cff" .. hex.value .. Escape(line) .. "|r"
        end
    end
    return table.concat(out, "\n")
end
