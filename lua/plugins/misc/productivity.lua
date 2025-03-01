return {
    {
        "quentingruber/pomodoro.nvim",
        keys = {
            {'<leader>ps', ':PomodoroStart<CR>', desc = 'Pomodoro Start'},
            {'<Leader>pS', ':PomodoroStop<CR>', desc = 'Pomodoro Stop'},
            {'<Leader>pu', ':PomodoroUI<CR>', desc = 'Pomodoro UI'},
            {'<Leader>pd', ':PomodoroDelayBreak<CR>', desc = 'Pomodoro Delay Break'},
            {'<Leader>pb', ':PomodoroForceBreak<CR>', desc = 'Pomodoro Force Break'},
            {'<Leader>pB', ':PomodoroSkipBreak<CR>', desc = 'Pomodoro Skip Break'},
        } ,
        opts = {
            start_at_launch = false,
            work_duration = 25,
            break_duration = 5,
            delay_duration = 1,
            long_break_duration = 15,
            breaks_before_long = 4,
        },
    }, -- Simple pomodoro timer
    {
        'backdround/global-note.nvim',
        keys = {
            {"<leader>ng", "<cmd>GlobalNote<cr>", desc = "Global Note"},
            {"<leader>np", "<cmd>ProjectNote<cr>", desc = "Project Note"},
        },
        config = function () 
            local gloabl_note = require('global-note')
            local get_project_name = function()
                local project_directory, err = vim.loop.cwd()
                if project_directory == nil then
                    vim.notify(err, vim.log.levels.WARN)
                    return nil
                end

                local project_name = vim.fs.basename(project_directory)
                if project_name == nil then
                    vim.notify("Unable to get the project name", vim.log.levels.WARN)
                    return nil
                end

                return project_name
            end

            gloabl_note.setup({
                additional_presets = {
                    project_local = {
                        command_name = "ProjectNote",
                        filename = function() return get_project_name() .. ".md" end,
                        title = "Project note",
                    },
                }
            })
        end
    }, -- note taking 
}
