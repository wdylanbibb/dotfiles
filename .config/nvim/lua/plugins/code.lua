return {
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = function()
        -- Update this path
        local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb"
        local this_os = vim.uv.os_uname().sysname

        -- The liblldb extension is .so for Linux and .dylib for MacOS
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")

        local cfg = require("rustaceanvim.config")
        return {
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
          },
          server = {
            on_attach = function(_, bufnr)
              vim.lsp.inlay_hint.enable(bufnr, true)
              vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<cr>", { buffer = bufnr, desc = "Hover" })
            end,
          },
        }
      end
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function(_)
      require("dapui").setup()
    end,
    keys = {
      {
        "<leader>cDu",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
    },
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({
        virt_text_pos = "inline",
      })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    config = function(_)
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
      require("dap").configurations.rust = {
        {
          name = "Debug Executable",
          type = "codelldb",
          request = "launch",
          program = function()
            vim.fn.system("cargo build")
            -- local execute = require("qss_nvim.utils").execute_and_capture_output
            local output = vim.fn.system("find target/debug -name $(basename $(pwd))")
            output = string.gsub(tostring(output), "^%s*(.-)%s*$", "%1")
            -- return output
            return output
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          showDisassembly = "never",
        },
      }
    end,
    keys = {
      {
        "<leader>cb",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>cbc",
        function()
          local condition = vim.fn.input("Condition: ")
          local message = vim.fn.input("Log point message: ")
          require("dap").set_breakpoint(condition == "" and nil or condition, nil, message == "" and nil or message)
        end,
        desc = "Set Custom Breakpoint",
      },
      {
        "<F5>",
        function()
          require("dapui").open()
          require("dap").continue()
        end,
      },
      {
        "<F6>",
        function()
          require("dapui").close()
          require("dap").close()
        end,
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
      },
    },
  },
}
