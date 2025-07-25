return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            {
                "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
                version = "2.*",
                config = function()
                    require("window-picker").setup({
                        filter_rules = {
                            include_current_win = false,
                            autoselect_one = true,
                            bo = {
                                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                                buftype = { "terminal", "quickfix" },
                            },
                        },
                    })
                end,
            },
        },
        lazy = false,
        config = function()
            vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")

            require("neo-tree").setup({
                close_if_last_window = false,
                popup_border_style = "NC",
                enable_git_status = true,
                enable_diagnostics = true,
                open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
                open_files_using_relative_paths = false,
                sort_case_insensitive = false,
                sort_function = function(a, b)
                    if a.type == "directory" and b.type ~= "directory" then
                        return true -- a is a directory, b is not, so a comes first
                    elseif a.type ~= "directory" and b.type == "directory" then
                        return false -- b is a directory, a is not, so b comes first
                    elseif a.hidden and not b.hidden then
                        return true -- a is hidden, b is not, so a comes last
                    elseif not a.hidden and b.hidden then
                        return false -- b is hidden, a is not, so a comes first
                    elseif a.hidden and b.hidden then
                        return a.name > b.name -- sort hidden items by name
                    else
                        -- Ensure both a.name and b.name are not nil before comparing
                        if a.name and b.name then
                            return a.name < b.name
                        else
                            return a.name ~= nil -- If a.name is nil, b should come first
                        end
                    end
                end,
                default_component_configs = {
                    container = {
                        enable_character_fade = true,
                    },
                    indent = {
                        indent_size = 2,
                        padding = 1,
                        with_markers = true,
                        indent_marker = "│",
                        last_indent_marker = "└",
                        highlight = "NeoTreeIndentMarker",
                        with_expanders = nil,
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "󰜌",
                        provider = function(icon, node, state)
                            if node.type == "file" or node.type == "terminal" then
                                local success, web_devicons = pcall(require, "nvim-web-devicons")
                                local name = node.type == "terminal" and "terminal" or node.name
                                if success then
                                    local devicon, hl = web_devicons.get_icon(name)
                                    icon.text = devicon or icon.text
                                    icon.highlight = hl or icon.highlight
                                end
                            end
                        end,
                        default = "*",
                        highlight = "NeoTreeFileIcon",
                    },
                    modified = {
                        symbol = "[+]",
                        highlight = "NeoTreeModified",
                    },
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true,
                        highlight = "NeoTreeFileName",
                    },
                    git_status = {
                        symbols = {
                            added = "",
                            modified = "",
                            deleted = "✖",
                            renamed = "󰁕",
                            untracked = "",
                            ignored = "",
                            unstaged = "󰄱",
                            staged = "",
                            conflict = "",
                        },
                    },
                    file_size = {
                        enabled = true,
                        width = 12,
                        required_width = 64,
                    },
                    type = {
                        enabled = true,
                        width = 10,
                        required_width = 122,
                    },
                    last_modified = {
                        enabled = true,
                        width = 20,
                        required_width = 88,
                    },
                    created = {
                        enabled = true,
                        width = 20,
                        required_width = 110,
                    },
                    symlink_target = {
                        enabled = false,
                    },
                },
                commands = {},
                window = {
                    position = "left",
                    width = 40,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    mappings = {
                        ["<space>"] = {
                            "toggle_node",
                            nowait = false,
                        },
                        ["<2-LeftMouse>"] = "open",
                        ["<cr>"] = "open",
                        ["<esc>"] = "cancel",
                        ["P"] = {
                            "toggle_preview",
                            config = {
                                use_float = true,
                                use_snacks_image = true,
                                use_image_nvim = true,
                            },
                        },
                        ["l"] = "focus_preview",
                        ["S"] = "open_split",
                        ["s"] = "open_vsplit",
                        ["t"] = "open_tabnew",
                        ["w"] = "open_with_window_picker",
                        ["C"] = "close_node",
                        ["z"] = "close_all_nodes",
                        ["a"] = {
                            "add",
                            config = {
                                show_path = "none",
                            },
                        },
                        ["A"] = "add_directory",
                        ["d"] = "delete",
                        ["r"] = "rename",
                        ["b"] = "rename_basename",
                        ["y"] = "copy_to_clipboard",
                        ["x"] = "cut_to_clipboard",
                        ["p"] = "paste_from_clipboard",
                        ["c"] = "copy",
                        ["m"] = "move",
                        ["q"] = "close_window",
                        ["R"] = "refresh",
                        ["?"] = "show_help",
                        ["<"] = "prev_source",
                        [">"] = "next_source",
                        ["i"] = "show_file_details",
                    },
                },
                nesting_rules = {},
                filesystem = {
                    filtered_items = {
                        visible = false,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_hidden = true,
                        hide_by_name = {},
                        hide_by_pattern = {},
                        always_show = {},
                        always_show_by_pattern = {},
                        never_show = {},
                        never_show_by_pattern = {},
                    },
                    follow_current_file = {
                        enabled = false,
                        leave_dirs_open = false,
                    },
                    group_empty_dirs = false,
                    hijack_netrw_behavior = "open_default",
                    use_libuv_file_watcher = false,
                    window = {
                        mappings = {
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root",
                            ["H"] = "toggle_hidden",
                            ["/"] = "fuzzy_finder",
                            ["D"] = "fuzzy_finder_directory",
                            ["#"] = "fuzzy_sorter",
                            ["f"] = "filter_on_submit",
                            ["<c-x>"] = "clear_filter",
                            ["[g"] = "prev_git_modified",
                            ["]g"] = "next_git_modified",
                            ["o"] = {
                                "show_help",
                                nowait = false,
                                config = { title = "Order by", prefix_key = "o" },
                            },
                            ["oc"] = { "order_by_created", nowait = false },
                            ["od"] = { "order_by_diagnostics", nowait = false },
                            ["og"] = { "order_by_git_status", nowait = false },
                            ["om"] = { "order_by_modified", nowait = false },
                            ["on"] = { "order_by_name", nowait = false },
                            ["os"] = { "order_by_size", nowait = false },
                            ["ot"] = { "order_by_type", nowait = false },
                        },
                        fuzzy_finder_mappings = {
                            ["<down>"] = "move_cursor_down",
                            ["<C-n>"] = "move_cursor_down",
                            ["<up>"] = "move_cursor_up",
                            ["<C-p>"] = "move_cursor_up",
                            ["<esc>"] = "close",
                            ["<S-CR>"] = "close_keep_filter",
                            ["<C-CR>"] = "close_clear_filter",
                            ["<C-w>"] = { "<C-S-w>", raw = true },
                            n = {
                                ["j"] = "move_cursor_down",
                                ["k"] = "move_cursor_up",
                                ["<S-CR>"] = "close_keep_filter",
                                ["<C-CR>"] = "close_clear_filter",
                                ["<esc>"] = "close",
                            },
                        },
                    },
                    commands = {},
                },
                buffers = {
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false,
                    },
                    group_empty_dirs = true,
                    show_unloaded = true,
                    window = {
                        mappings = {
                            ["d"] = "buffer_delete",
                            ["bd"] = "buffer_delete",
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root",
                            ["o"] = {
                                "show_help",
                                nowait = false,
                                config = { title = "Order by", prefix_key = "o" },
                            },
                            ["oc"] = { "order_by_created", nowait = false },
                            ["od"] = { "order_by_diagnostics", nowait = false },
                            ["om"] = { "order_by_modified", nowait = false },
                            ["on"] = { "order_by_name", nowait = false },
                            ["os"] = { "order_by_size", nowait = false },
                            ["ot"] = { "order_by_type", nowait = false },
                        },
                    },
                },
                git_status = {
                    window = {
                        position = "float",
                        mappings = {
                            ["A"] = "git_add_all",
                            ["gu"] = "git_unstage_file",
                            ["gU"] = "git_undo_last_commit",
                            ["ga"] = "git_add_file",
                            ["gr"] = "git_revert_file",
                            ["gc"] = "git_commit",
                            ["gp"] = "git_push",
                            ["gg"] = "git_commit_and_push",
                            ["o"] = {
                                "show_help",
                                nowait = false,
                                config = { title = "Order by", prefix_key = "o" },
                            },
                            ["oc"] = { "order_by_created", nowait = false },
                            ["od"] = { "order_by_diagnostics", nowait = false },
                            ["om"] = { "order_by_modified", nowait = false },
                            ["on"] = { "order_by_name", nowait = false },
                            ["os"] = { "order_by_size", nowait = false },
                            ["ot"] = { "order_by_type", nowait = false },
                        },
                    },
                },
            })
        end,
    },
}
