-- Port scanning script in Lua

local nmap = require "nmap"
local shortport = require "shortport"

description = [[
Simple port scanner script written in Lua.
]]

author = "Anjeeshnu"

categories = {"default", "safe"}

-- Define command-line arguments
portrange = "1-1000"
target = "localhost"

-- Parse command-line arguments
local function parse_args()
    local argparse = require "argparse"
    local parser = argparse()
    parser:option("-p --portrange", "Port range to scan"):default(portrange)
    parser:option("-t --target", "Target host to scan"):default(target)
    local args = parser:parse()
    portrange = args.portrange
    target = args.target
end

-- Port scanning function
portrule = function(host, port)
    if shortport.port_is_open(host, port) then
        return true
    end
end

-- Main function
local function main()
    parse_args()
    nmap.scan({target=target, ports=portrange, script="portscan.lua"})
    local results = nmap.registry.targets[target].ports
    for _, port in ipairs(results) do
        if port.state == "open" then
            print(port.service.name .. " (" .. port.service.product .. ") on port " .. port.number .. "/" .. port.protocol)
        end
    end
end

main()
