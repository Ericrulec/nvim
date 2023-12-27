require('erik.base')
require('erik.highlights')
require('erik.maps')
require('erik.plugins')

local has = vim.fn.has
local is_mac = has "macunix"
local is_linux = has "linux"
local is_win = has "win32"
local is_wsl = has "wsl"

if is_mac then
    require('erik.macos')
end
if is_linux then
    require('erik.linux')
end
if is_win then
    require('erik.windows')
end
if is_wsl then
    require('erik.wsl')
end
