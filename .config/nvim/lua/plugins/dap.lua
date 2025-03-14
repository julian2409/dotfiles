return {
    {
        'mfussenegger/nvim-dap',
        config = function()
            vim.keymap.set('n', '<F5>', require 'dap'.continue)
            vim.keymap.set('n', '<F8>', require 'dap'.step_over)
            vim.keymap.set('n', '<F9>', require 'dap'.step_into)
            vim.keymap.set('n', '<F10>', require 'dap'.step_out)
            vim.keymap.set('n', '<F12>', require 'dap'.terminate)
            vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
            vim.keymap.set('n', '<leader>vt', vim.cmd.DapVirtualTextToggle)
            vim.fn.sign_define('DapBreakpoint',{ text ='🔴', texthl ='', linehl ='', numhl =''})

            local dap = require('dap')
            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-dap',
                name = 'lldb',
            }

            dap.configurations.c = {
                {
                    name = 'Launch',
                    type = 'lldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},

                    -- 💀
                    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                    --
                    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                    --
                    -- Otherwise you might get the following error:
                    --
                    --    Error on launch: Failed to attach to the target process
                    --
                    -- But you should be aware of the implications:
                    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                    -- runInTerminal = false,
                },
            }
        end,
    },
    {
        'leoluz/nvim-dap-go',
        opts = {
            dap_configurations = {
                {
                    -- Must be "go" or it will be ignored by the plugin
                    type = "go",
                    name = "Attach remote",
                    mode = "remote",
                    request = "attach",
                },
            },
            -- delve configurations
            delve = {
                -- the path to the executable dlv which will be used for debugging.
                -- by default, this is the "dlv" executable on your PATH.
                path = "dlv",
                -- time to wait for delve to initialize the debug session.
                -- default to 20 seconds
                initialize_timeout_sec = 20,
                -- a string that defines the port to start delve debugger.
                -- default to string "${port}" which instructs nvim-dap
                -- to start the process in a random available port.
                -- if you set a port in your debug configuration, its value will be
                -- assigned dynamically.
                port = "${port}",
                -- additional args to pass to dlv
                args = {},
                -- the build flags that are passed to delve.
                -- defaults to empty string, but can be used to provide flags
                -- such as "-tags=unit" to make sure the test suite is
                -- compiled during debugging, for example.
                -- passing build flags using args is ineffective, as those are
                -- ignored by delve in dap mode.
                -- avaliable ui interactive function to prompt for arguments get_arguments
                build_flags = {},
                -- whether the dlv process to be created detached or not. there is
                -- an issue on delve versions < 1.24.0 for Windows where this needs to be
                -- set to false, otherwise the dlv server creation will fail.
                -- avaliable ui interactive function to prompt for build flags: get_build_flags
                detached = vim.fn.has("win32") == 0,
                -- the current working directory to run dlv from, if other than
                -- the current working directory.
                cwd = nil,
            },
            -- options related to running closest test
            tests = {
                -- enables verbosity when running the test.
                verbose = false,
            },
        }
    },
    {
        'rcarriga/nvim-dap-ui',
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"]=function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"]=function()
                dapui.close()
            end
           dap.listeners.before.event_exited["dapui_config"]=function()
               dapui.close()
           end
        end,
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio'
        },
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
    },
}
