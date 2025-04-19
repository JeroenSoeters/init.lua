-- In ~/.config/nvim/lua/custom/java_test.lua
local M = {}

-- Utility function to check if file is an integration test
local function is_integration_test(filename)
    return string.match(filename, "IT%.java$") or       -- Matches *IT.java
           string.match(filename, "IntTest%.java$") or  -- Matches *IntTest.java
           string.match(filename, "E2ETest%.java$")     -- Matches *E2ETest.java
end

-- Function to execute a test
local function run_test_command(command, buf, output_win, source_win)
    vim.defer_fn(function()
        -- Switch back to source window before running test
        if vim.api.nvim_win_is_valid(source_win) then
            vim.api.nvim_set_current_win(source_win)
        end
        
        -- Run the test command
        if command == 'method' then
            vim.cmd('JavaTestRunCurrentMethod')
        elseif command == 'class' then
            vim.cmd('JavaTestRunCurrentClass')
        elseif command == 'debug_method' then
            vim.cmd('JavaTestDebugCurrentMethod')
        elseif command == 'debug_class' then
            vim.cmd('JavaTestDebugCurrentClass')
        end
    end, 100)
end

-- Utility function to handle docker compose operations
local function handle_docker_compose(test_command)
    -- Get the project root directory (where gradlew is located)
    local root_dir = vim.fn.getcwd()
    local gradlew = root_dir .. '/gradlew'
    
    -- Store the source window
    local source_win = vim.api.nvim_get_current_win()
    
    -- Create a unique buffer name using timestamp
    local buffer_name = string.format('Test-Output-%d', os.time())
    
    -- Create a buffer for output
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, buffer_name)
    
    -- Create a window split below the current window
    vim.cmd('belowright split')
    local output_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(output_win, buf)
    vim.api.nvim_win_set_height(output_win, 15)  -- Set a reasonable height
    
    -- Switch back to source window
    vim.api.nvim_set_current_win(source_win)
    
    local function append_output(data)
        if data and vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
        end
    end

    append_output({'=== Starting Docker Compose ===', ''})
    
    local compose_up_job = vim.fn.jobstart({gradlew, 'composeUp'}, {
        cwd = root_dir,
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data and #data > 1 then
                append_output(data)
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 1 then
                append_output(data)
            end
        end,
        on_exit = function(_, code)
            if code == 0 then
                append_output({'', 'composeUp succeeded, running tests...', ''})
                
                -- Run the test in the original window
                run_test_command(test_command, buf, output_win, source_win)
                
                -- Set up an autocommand to watch for test completion
                local augroup = vim.api.nvim_create_augroup('JavaTestComplete', { clear = true })
                vim.api.nvim_create_autocmd('BufDelete', {
                    group = augroup,
                    pattern = 'junit-test-results*',
                    callback = function()
                        if vim.api.nvim_buf_is_valid(buf) then
                            append_output({'', '=== Stopping Docker Compose ===', ''})
                            vim.fn.jobstart({gradlew, 'composeDown'}, {
                                cwd = root_dir,
                                stdout_buffered = true,
                                stderr_buffered = true,
                                on_stdout = function(_, data)
                                    if data and #data > 1 then
                                        append_output(data)
                                    end
                                end,
                                on_stderr = function(_, data)
                                    if data and #data > 1 then
                                        append_output(data)
                                    end
                                end,
                                on_exit = function(_, down_code)
                                    if down_code ~= 0 then
                                        append_output({'', 'composeDown failed'})
                                    else
                                        append_output({'', 'composeDown succeeded'})
                                    end
                                end
                            })
                        end
                        return true  -- Delete the autocmd after it runs
                    end
                })
            else
                append_output({'', 'composeUp failed'})
                -- Run compose down if compose up failed
                if vim.api.nvim_buf_is_valid(buf) then
                    append_output({'', '=== Stopping Docker Compose ===', ''})
                    vim.fn.jobstart({gradlew, 'composeDown'}, {
                        cwd = root_dir,
                        stdout_buffered = true,
                        stderr_buffered = true,
                        on_stdout = function(_, data)
                            if data and #data > 1 then
                                append_output(data)
                            end
                        end,
                        on_stderr = function(_, data)
                            if data and #data > 1 then
                                append_output(data)
                            end
                        end,
                        on_exit = function(_, down_code)
                            if down_code ~= 0 then
                                append_output({'', 'composeDown failed'})
                            else
                                append_output({'', 'composeDown succeeded'})
                            end
                        end
                    })
                end
            end
        end
    })
end

-- Core function to run or debug tests
local function execute_test(is_method, is_debug)
    local buf = vim.api.nvim_buf_get_name(0)
    
    local command
    if is_debug then
        command = is_method and 'debug_method' or 'debug_class'
    else
        command = is_method and 'method' or 'class'
    end
    
    if is_integration_test(buf) then
        handle_docker_compose(command)
    else
        if is_debug then
            if is_method then
                vim.cmd('JavaTestDebugCurrentMethod')
            else
                vim.cmd('JavaTestDebugCurrentClass')
            end
        else
            if is_method then
                vim.cmd('JavaTestRunCurrentMethod')
            else
                vim.cmd('JavaTestRunCurrentClass')
            end
        end
    end
end

-- Public functions for different test execution modes
M.run_method = function()
    execute_test(true, false)
end

M.run_class = function()
    execute_test(false, false)
end

M.debug_method = function()
    execute_test(true, true)
end

M.debug_class = function()
    execute_test(false, true)
end

return M
