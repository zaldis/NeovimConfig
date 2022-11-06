local dap = require('dap')

local get_python_path = function()
    local env_path = os.getenv("VIRTUAL_ENV")
    if env_path ~= nil then
        if vim.fn.executable(env_path .. "/bin/python") then
            return env_path .. "/bin/python"
        end
    end

    local work_dir = vim.fn.getcwd()
    if vim.fn.executable(work_dir .. "/venv/bin/python") == 1 then
        return work_dir .. "/venv/bin/python"
    elseif vim.fn.executable(work_dir .. "/.venv/bin/python") then
        return work_dir .. "/.venv/bin/python"
    end
    return "/usr/bin/python"
end;


dap.adapters.python = {
    type = 'executable';
    command = get_python_path();
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch';
        name = "Launch file";

        -- Options below are for debugpy 
        -- see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        program = "${file}"; -- This configuration will launch the current file if used.
	    pythonPath = get_python_path;
    },
}


local show_scopes = function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end

local show_frames = function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>dr', dap.repl.open, {})
vim.keymap.set('n', '<leader>ds', show_scopes, {})
vim.keymap.set('n', '<leader>df', show_frames, {})
vim.keymap.set('n', '<leader>de', require('dap.ui.widgets').hover, {})
vim.keymap.set('n', '<F5>', dap.continue, {})
vim.keymap.set('n', '<F10>', dap.step_over, {})
vim.keymap.set('n', '<F11>', dap.step_into, {})
vim.keymap.set('n', '<F12>', dap.step_out, {})

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})


require('dap.ext.vscode').load_launchjs('.nvim/launch.json')
