return {
  {
    "rachartier/tiny-glimmer.nvim",
    dependencies = { "gbprod/yanky.nvim" },
    event = "VeryLazy",
    priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
    opts = {
      enabled = true,
      disable_warnings = true,
      refresh_interval_ms = 8,

      overwrite = {
        auto_map = true,
        yank = {
          enabled = true,
          default_animation = "fade",
        },
        search = {
          enabled = false,
          default_animation = "pulse",
          next_mapping = "n",
          prev_mapping = "N",
        },
        paste = {
          enabled = true,
          default_animation = "reverse_fade",
          paste_mapping = "p",
          Paste_mapping = "P",
        },
        undo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "#fb4934", -- Gruvbox red
              max_duration = 500,
              min_duration = 500,
            },
          },
          undo_mapping = "u",
        },
        redo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "#b8bb26", -- Gruvbox green
              max_duration = 500,
              min_duration = 500,
            },
          },
          redo_mapping = "<c-r>",
        },
      },

      support = {
        substitute = {
          enabled = true,
          default_animation = "fade",
        },
      },

      presets = {
        pulsar = {
          enabled = false,
          on_events = { "CursorMoved", "CmdlineEnter", "WinEnter" },
          default_animation = {
            name = "fade",
            settings = {
              max_duration = 1000,
              min_duration = 1000,
              from_color = "DiffDelete",
              to_color = "Normal",
            },
          },
        },
      },

      transparency_color = nil,

      animations = {
        fade = {
          max_duration = 400,
          min_duration = 300,
          easing = "outQuad",
          chars_for_max_duration = 10,
          from_color = "Visual",
          to_color = "Normal",
        },
        reverse_fade = {
          max_duration = 380,
          min_duration = 300,
          easing = "outBack",
          chars_for_max_duration = 10,
          from_color = "Visual",
          to_color = "Normal",
        },
        bounce = {
          max_duration = 500,
          min_duration = 400,
          chars_for_max_duration = 20,
          oscillation_count = 1,
          from_color = "Visual",
          to_color = "Normal",
        },
        left_to_right = {
          max_duration = 350,
          min_duration = 350,
          min_progress = 0.85,
          chars_for_max_duration = 25,
          lingering_time = 50,
          from_color = "Visual",
          to_color = "Normal",
        },
        pulse = {
          max_duration = 600,
          min_duration = 400,
          chars_for_max_duration = 15,
          pulse_count = 2,
          intensity = 1.2,
          from_color = "Visual",
          to_color = "Normal",
        },
        rainbow = {
          max_duration = 600,
          min_duration = 350,
          chars_for_max_duration = 20,
        },
        hijack_ft_disabled = {
          "alpha",
          "snacks_dashboard",
        },
      },

      virt_text = {
        priority = 2048,
      },
    },
  },
}
