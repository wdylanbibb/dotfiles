return {
  {
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<c-\>]],
      direction = "horizontal",
    },
    cmd = { "ToggleTerm" },
    keys = { [[<c-\>]] },
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "DiffviewOpen" },
    keys = {
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<cr><leader>b",
        desc = "Open Git Diff View",
      },
    },
    opts = {
      hooks = {
        view_opened = function(_)
          pcall(require("diffview.actions").toggle_files)
        end,
      },
      keymaps = {
        view = {
          { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close the diff view." } },
        },
        file_panel = {
          { "n", "<leader>q", "<cmd>DiffviewClose<cr>", { desc = "Close the diff view." } },
        },
      },
    },
  },
}
