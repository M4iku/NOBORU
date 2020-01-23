utf8L = {
	["а"] = "А",
	["б"] = "Б",
	["в"] = "В",
	["г"] = "Г",
	["д"] = "Д",
	["е"] = "Е",
	["ё"] = "Ё",
	["ж"] = "Ж",
	["з"] = "З",
	["и"] = "И",
	["й"] = "Й",
	["к"] = "К",
	["л"] = "Л",
	["м"] = "М",
	["н"] = "Н",
	["о"] = "О",
	["п"] = "П",
	["р"] = "Р",
	["с"] = "С",
	["т"] = "Т",
	["у"] = "У",
	["ф"] = "Ф",
	["х"] = "Х",
	["ц"] = "Ц",
	["ч"] = "Ч",
	["ш"] = "Ш",
	["щ"] = "Щ",
	["ъ"] = "Ъ",
	["ы"] = "Ы",
	["ь"] = "Ь",
	["э"] = "Э",
	["ю"] = "Ю",
	["я"] = "Я"
}

utf8U = {
	["А"] = "а",
	["Б"] = "б",
	["В"] = "в",
	["Г"] = "г",
	["Д"] = "д",
	["Е"] = "е",
	["Ё"] = "ё",
	["Ж"] = "ж",
	["З"] = "з",
	["И"] = "и",
	["Й"] = "й",
	["К"] = "к",
	["Л"] = "л",
	["М"] = "м",
	["Н"] = "н",
	["О"] = "о",
	["П"] = "п",
	["Р"] = "р",
	["С"] = "с",
	["Т"] = "т",
	["У"] = "у",
	["Ф"] = "ф",
	["Х"] = "х",
	["Ц"] = "ц",
	["Ч"] = "ч",
	["Ш"] = "ш",
	["Щ"] = "щ",
	["Ъ"] = "ъ",
	["Ы"] = "ы",
	["Ь"] = "ь",
	["Э"] = "э",
	["Ю"] = "ю",
	["Я"] = "я"
}
utf8ascii = {
	["А"] = "%%C0",
	["Б"] = "%%C1",
	["В"] = "%%C2",
	["Г"] = "%%C3",
	["Д"] = "%%C4",
	["Е"] = "%%C5",
	["Ё"] = "%%A8",
	["Ж"] = "%%C6",
	["З"] = "%%C7",
	["И"] = "%%C8",
	["Й"] = "%%C9",
	["К"] = "%%CA",
	["Л"] = "%%CB",
	["М"] = "%%CC",
	["Н"] = "%%CD",
	["О"] = "%%CE",
	["П"] = "%%CF",
	["Р"] = "%%D0",
	["С"] = "%%D1",
	["Т"] = "%%D2",
	["У"] = "%%D3",
	["Ф"] = "%%D4",
	["Х"] = "%%D5",
	["Ц"] = "%%D6",
	["Ч"] = "%%D7",
	["Ш"] = "%%D8",
	["Щ"] = "%%D9",
	["Ъ"] = "%%DA",
	["Ы"] = "%%DB",
	["Ь"] = "%%DC",
	["Э"] = "%%DD",
	["Ю"] = "%%DE",
	["Я"] = "%%DF",
	["а"] = "%%E0",
	["б"] = "%%E1",
	["в"] = "%%E2",
	["г"] = "%%E3",
	["д"] = "%%E4",
	["е"] = "%%E5",
	["ё"] = "%%B8",
	["ж"] = "%%E6",
	["з"] = "%%E7",
	["и"] = "%%E8",
	["й"] = "%%E9",
	["к"] = "%%EA",
	["л"] = "%%EB",
	["м"] = "%%EC",
	["н"] = "%%ED",
	["о"] = "%%EE",
	["п"] = "%%EF",
	["р"] = "%%F0",
	["с"] = "%%F1",
	["т"] = "%%F2",
	["у"] = "%%F3",
	["ф"] = "%%F4",
	["х"] = "%%F5",
	["ц"] = "%%F6",
	["ч"] = "%%F7",
	["ш"] = "%%F8",
	["щ"] = "%%F9",
	["ъ"] = "%%FA",
	["ы"] = "%%FB",
	["ь"] = "%%FC",
	["э"] = "%%FD",
	["ю"] = "%%FE",
	["я"] = "%%FF",
}
function it_utf8(str)
	return string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)")
end

local old_lower = string.lower
function string:lower()
	local str = {}
	for c in it_utf8(self) do
		if utf8U[c] == nil then
			str[#str+1] = old_lower(c)
		else
			str[#str+1] = utf8U[c]
		end
	end
	return table.concat(str)
end

local old_upper = string.upper
function string:upper()
	local str = {}
	for c in it_utf8(self) do
		if utf8L[c] == nil then
			str[#str + 1] = old_upper(c)
		else
			str[#str + 1] = utf8L[c]
		end
	end
	return table.concat(str)
end

function string:sub(i, k)
	k = k or -1
	local text = {}
	for c in it_utf8(self) do
		if i == 1 then
			if k ~= 0 then
				text[#text + 1] = c
				k = k - 1
			else
				break
			end
		else
			i = i - 1
		end
	end
	return table.concat(text)
end
--[[
function string:len()
	return select(2, string.gsub(self, "[^\128-\193]", ""))
end]]

function table.serialize(t, name)
    local format = string.format
    local concat = table.concat
    local type = type
    local function serialize(_t, _name)
        local _ = {}
        for k, v in pairs(_t) do
            if type(v) == "string" then
                if type(k) == "string" then
                    _[#_ + 1] = format('%s = \"%s\"', k, v)
                else
                    _[#_ + 1] = format('[%d] = \"%s\"', k, v)
                end
            elseif type(v) == "table" then
                if type(k) == "string" then
                    _[#_ + 1] = format('%s%s', k, serialize(v,''))
                else
                    _[#_ + 1] = format('[%d]%s', k, serialize(v,''))
                end
            else
                if type(k) == "string" then
                    _[#_ + 1] = format('%s = %s', k, v)
                else
                    _[#_ + 1] = format('[%d] = %s', k, v)
                end
            end
        end
        return format('%s = {%s}',_name,concat(_,', '))
    end
    return serialize(t,name)
end

function table.reverse(t)
    local i, j = 1, #t
    while i < j do
		t[i], t[j] = t[j], t[i]
		i = i + 1
		j = j - 1
	end
end

function table.clone(t)
	local pairs = pairs
	local type = type
	local function clone(_t)
		local new_t = {}
		for k, v in pairs(_t) do
			if type(v) == "table" then
				new_t[k] = clone(v)
			else
				new_t[k] = v
			end
		end
		return new_t
	end
	return clone(t)
end

local a2u8 = {
	[128]='\208\130',[129]='\208\131',[130]='\226\128\154',[131]='\209\147',[132]='\226\128\158',[133]='\226\128\166',
	[134]='\226\128\160',[135]='\226\128\161',[136]='\226\130\172',[137]='\226\128\176',[138]='\208\137',[139]='\226\128\185',
	[140]='\208\138',[141]='\208\140',[142]='\208\139',[143]='\208\143',[144]='\209\146',[145]='\226\128\152',
	[146]='\226\128\153',[147]='\226\128\156',[148]='\226\128\157',[149]='\226\128\162',[150]='\226\128\147',[151]='\226\128\148',
	[152]='\194\152',[153]='\226\132\162',[154]='\209\153',[155]='\226\128\186',[156]='\209\154',[157]='\209\156',
	[158]='\209\155',[159]='\209\159',[160]='\194\160',[161]='\209\142',[162]='\209\158',[163]='\208\136',
	[164]='\194\164',[165]='\210\144',[166]='\194\166',[167]='\194\167',[168]='\208\129',[169]='\194\169',
	[170]='\208\132',[171]='\194\171',[172]='\194\172',[173]='\194\173',[174]='\194\174',[175]='\208\135',
	[176]='\194\176',[177]='\194\177',[178]='\208\134',[179]='\209\150',[180]='\210\145',[181]='\194\181',
	[182]='\194\182',[183]='\194\183',[184]='\209\145',[185]='\226\132\150',[186]='\209\148',[187]='\194\187',
	[188]='\209\152',[189]='\208\133',[190]='\209\149',[191]='\209\151'
}
local byte, char = string.byte, string.char
function AnsiToUtf8(s)
	local r, b = {}
		for i = 1, s and s:len() or 0 do
			b = byte(s, i)
			if b < 128 then
				r[#r + 1] = char(b)
			else
				if b > 239 then
					r[#r+1] = '\209'
					r[#r+1] = char(b - 112)
				elseif b > 191 then
					r[#r+1] = '\208'
					r[#r+1] = char(b - 48)
				elseif a2u8[b] then
					r[#r+1] = a2u8[b]
				else
					r[#r+1] = '_'
				end
			end
		end
	return table.concat(r)
end