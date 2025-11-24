local M = {}

M.is_available = function()
  return vim.fn.filereadable 'build.gradle' == 1
end

M.tasks = {
  {
    name = 'Run serivce',
    builder = function()
      vim.fn.system 'rm gradle-logs.log 2>/dev/null || true'
      local task = {
        cmd = {
          "LOCALSTACK_HOST=localstack ./gradlew :deploy:tomcatRunWar -'Pno-versioning' --continuous 2>&1 | tee gradle-logs.log",
        },
      }
      return task
    end,
  },
  {
    name = 'Tail log',
    builder = function()
      local task = {
        cmd = {
          'lnav gradle-logs',
        },
      }
      return task
    end,
  },
  {
    name = 'Run integration test',
    builder = function()
      local task = {
        cmd = {
          './gradlew :deploy:runIntegrationTest',
        },
      }
      return task
    end,
  },
  {
    name = 'Run nearest test',

    builder = function()
      local function parsef_file_structure()
        local file_path = vim.fn.expand '%:p'
        local line_number = vim.fn.line '.'
        local lines = vim.fn.getline(1, '$')
        if type(lines) == 'string' then
          lines = { lines }
        end
        local flattened_lines = vim.fn.join(lines, '\n')

        local package_name = string.match(flattened_lines, 'package%s+([%w%.]+)')
        local class_name = string.match(flattened_lines, 'class%s+([%w_]+)')
        local module = string.match(file_path, '/([%w_]+)/src/')

        if not (package_name and class_name and module) then
          vim.notify('Error: Could not extract required test information', vim.log.levels.ERROR)
          return
        end

        return {
          file_path = file_path,
          current_line_num = line_number,
          content = lines,
          module = module,
          class_name = class_name,
          package_name = package_name,
        }
      end

      local function find_nearest_test(content, curr_line_num)
        local test_method = nil

        local total_line_num = #content

        -- Search backward from current line
        for i = math.min(curr_line_num, total_line_num), 1, -1 do
          if string.match(content[i], '@Test') or string.match(content[i], '@ParameterizedTest') then
            -- Look for method name in next few lines
            for j = i + 1, math.min(i + 5, total_line_num) do
              local method_name = string.match(content[j], 'fun%s+([%w_]+)%(')
              if method_name then
                test_method = method_name
                break
              end
            end
            if test_method then
              break
            end
          end
        end

        -- If not found, search forward
        if not test_method then
          for i = curr_line_num + 1, total_line_num do
            if string.match(content[i], '@Test') or string.match(content[i], '@ParameterizedTest') then
              for j = i + 1, math.min(i + 5, total_line_num) do
                local method_name = string.match(content[j], 'fun%s+([%w_]+)%(')
                if method_name then
                  test_method = method_name
                  break
                end
              end
              if test_method then
                break
              end
            end
          end
        end

        return test_method
      end

      local function generate_test_cmd(method)
        if method == nil then
          method = 'nearest'
        end

        local test_file = parsef_file_structure()
        local module = test_file.module
        local package_name = test_file.package_name
        local class_name = test_file.class_name

        local gradle_cmd = './gradlew ' .. module .. ':test'
        -- short-cirut to running whole test if cursor is at the top
        if test_file.current_line_num == 1 then
          gradle_cmd = gradle_cmd .. ' --tests "' .. package_name .. '.' .. class_name .. '"'
          return gradle_cmd
        end

        if test_file.current_line_num == 1 then
          gradle_cmd = gradle_cmd .. ' --tests "' .. package_name .. '.' .. class_name .. '"'
          return gradle_cmd
        end

        local test_method = find_nearest_test(test_file.content, test_file.current_line_num)
        if test_method then
          gradle_cmd = gradle_cmd .. ' --tests "' .. package_name .. '.' .. class_name .. '.' .. test_method .. '"'
        else
          gradle_cmd = gradle_cmd .. ' --tests "' .. package_name .. '.' .. class_name .. '"'
        end

        return gradle_cmd
      end

      local nearest_cmd = generate_test_cmd()

      local task = {
        cmd = {
          nearest_cmd,
        },
      }

      return task
    end,
  },
}

return M
