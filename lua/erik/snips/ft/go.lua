require("luasnip.session.snippet_collection").clear_snippets "go"

local ls = require "luasnip"

local snippet_from_nodes = ls.sn

local s = ls.s
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local fmt = require("luasnip.extras.fmt").fmt

local ts_locals = require "nvim-treesitter.locals"
local ts_utils = require "nvim-treesitter.ts_utils"

local get_node_text = vim.treesitter.get_node_text


local default_values = {
    int = "0",
    bool = "false",
    string = '""',

    error = function(_, info)
        if info then
            info.index = info.index + 1

            return c(info.index, {
                t(info.err_name),
                t(string.format('errors.Wrap(%s, "%s")', info.err_name, info.func_name)),
            })
        else
            return t "err"
        end
    end,

    -- Types with a "*" mean they are pointers, so return nil
    [function(text)
        return string.find(text, "*", 1, true) ~= nil
    end] = function(_, _)
        return t "nil"
    end,

    -- Convention: Usually no "*" and Capital is a struct type, so give the option
    -- to have it be with {} as well.
    [function(text)
        return not string.find(text, "*", 1, true) and string.upper(string.sub(text, 1, 1)) == string.sub(text, 1, 1)
    end] = function(text, info)
        info.index = info.index + 1

        return c(info.index, {
            t(text .. "{}"),
            t(text),
        })
    end,
}

local transform = function(text, info)
    -- Determine whether the key mathes the condition
    local condition_matches = function(condition, ...)
        if type(condition) == "string" then
            return condition == text
        else
            return condition(...)
        end
    end

    -- Find the matchign condition to get the correct default value
    for condition, result in pairs(default_values) do
        if condition_matches(condition, text, info) then
            if type(result) == "string" then
                return t(result)
            else
                return result(text, info)
            end
        end
    end

    -- If no mathes are found, just return the text
    return t(text)
end

local handlers = {
    parameter_list = function(node, info)
        local result = {}

        local count = node:named_child_count()
        for idx = 0, count - 1 do
            local matching_node = node:named_child(idx)
            local type_node = matching_node:field("type")[1]
            table.insert(result, transform(get_node_text(type_node, 0), info))
            if idx ~= count - 1 then
                table.insert(result, t { ", " })
            end
        end

        return result
    end,

    type_identifier = function(node, info)
        local text = get_node_text(node, 0)
        return { transform(text, info) }
    end,
}

---@param info table
local function go_result_type(info)
    local function_node_types = {
        function_declaration = true,
        method_declaration = true,
        func_literal = true,
    }
    -- Find the first function node that's a parent of the cursor.
    local node = vim.treesitter.get_node()
    while node ~= nil do
        if function_node_types[node:type()] then
            break
        end

        node = node:parent()
    end

    local query = assert(vim.treesitter.query.get("go", "return-snippet"), "No query")
    for _, capture in query:iter_captures(node, 0) do
        if handlers[capture:type()] then
            return handlers[capture:type()](capture, info)
        end
    end
end

local go_return_values = function(args)
    return snippet_from_nodes(
        nil,
        go_result_type {
            index = 0,
            err_name = args[1][1],
            func_name = args[2][1],
        }
    )
end

ls.add_snippets("go", {
    s(
        "efi",
        fmta(
            [[
<val>, <err> := <f>(<args>)
if <err_same> != nil {
	return <result>
}
<finish>
]],
            {
                val = i(1),
                err = i(2, "err"),
                f = i(3),
                args = i(4),
                err_same = rep(2),
                result = d(5, go_return_values, { 2, 3 }),
                finish = i(0),
            }
        )
    ),
})
