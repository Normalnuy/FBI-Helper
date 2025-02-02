script_name('FBI Helper')
script_author('JD-V')
script_version('1.0')
script_description('An improved version of MVD Helper with additional features. Auto-playbacks are cut.')

require 'lib.moonloader'
require 'lib.sampfuncs'
local dlstatus = require("moonloader").download_status
local inicfg = require("inicfg")
local sampev = require 'lib.samp.events'

local encoding = require 'encoding'
encoding.default = "CP1251"
u8 = encoding.UTF8

--====================================== Auto-Update parameters ====================--

update_states = false 

local script_ver = 1
local script_ver_txt = "1.0"

local update_url = "https://raw.githubusercontent.com/Normalnuy/FBI-Helper/refs/heads/main/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "https://github.com/Normalnuy/FBI-Helper/raw/refs/heads/main/FBI%20Helper.luac"
local script_path = thisScript().path

--====================================== Colors panel ==============================--

local blue_color = "{5A90CE}"
local white_color = "{FFFFFF}"
local red_color = "{FF0000}"
local default_color = 0xFFFFFF

--======================================== Text panel ==============================--

local tag = blue_color.."[ FBI Helper by "..red_color.."JD-V "..blue_color.."]: "..white_color

--========================================= Programm ===================================--

function main ()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampAddChatMessage(tag.."Скрипт запущен!", default_color)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.version.ver) > script_ver then
                -- переделать под imgui
                sampAddChatMessage(tag.."Есть обновление!\nТекущая версия: "..script_ver_txt.."\nНовая версия: ".. updateIni.version.ver_txt, -1)
                update_states = true
            end
            os.remove(update_path)
        end
    end)

    while true do wait(0)
        AutoUpdate()
    end
end

function AutoUpdate()
    if update_states then
        downloadUrlToFile(script_url, script_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
               sampAddChatMessage(tag.."Cкрипт успешно обновлён!\nТекущая версия: "..updateIni.version.ver_txt)
               thisScript():reload()
            end
        end)
        return
    end
end
