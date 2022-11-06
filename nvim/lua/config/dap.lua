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


pcall(function()
    require('dap.ext.vscode').load_launchjs('.nvim/launch.json')
end)


vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
