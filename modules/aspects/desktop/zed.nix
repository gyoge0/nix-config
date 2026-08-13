{
  den.aspects.desktop.zed.homeManager = {
    programs.zed-editor = {
      enable = true;
      userKeymaps = [
        {
          context = "ProjectPanel && not_editing";
          bindings = {
            "j" = "menu::SelectNext";
            "k" = "menu::SelectPrevious";
            "h" = "project_panel::CollapseSelectedEntry";
            "l" = "project_panel::ExpandSelectedEntry";
            "alt-n" = "project_panel::NewFile";
          };
        }
        {
          context = "Editor && vim_mode == normal";
          bindings = {
            "alt-h" = "workspace::ActivatePaneLeft";
            "alt-j" = "workspace::ActivatePaneDown";
            "alt-k" = "workspace::ActivatePaneUp";
            "alt-l" = "workspace::ActivatePaneRight";
          };
        }
        {
          context = "Workspace";
          bindings = {
            "tab" = "pane::ActivateNextItem";
            "shift-tab" = "pane::ActivatePreviousItem";
          };
        }
        {
          context = "Editor && vim_mode == normal";
          bindings = {
            "g d" = "editor::GoToDefinition";
            "g i" = "editor::GoToImplementation";
            "g b" = "pane::GoBack";
            "g f" = "pane::GoForward";
            "g e" = "editor::GoToDiagnostic";
            "g E" = "editor::GoToPreviousDiagnostic";
            "space" = "editor::ToggleCodeActions";
            "m r" = "editor::ToggleCodeActions";
            "m l" = "editor::Format";
          };
        }
        {
          context = "Workspace";
          bindings = {
            ", r" = "task::Rerun";
            ", d" = "debugger::Start";
          };
        }
        {
          context = "Editor && vim_mode == normal";
          bindings = {
            "m d r" = "debugger::Continue";
            "m d i" = "debugger::StepInto";
            "m d o" = "debugger::StepOver";
            "m d I" = "debugger::StepOut";
            "m d d" = "editor::ToggleBreakpoint";
          };
        }
        {
          context = "Workspace";
          bindings = {
            ". e" = "project_panel::ToggleFocus";
            ". p" = "diagnostics::Deploy";
            ". t" = "terminal_panel::Toggle";
            ". g" = "git_panel::ToggleFocus";
            ". d" = "debug_panel::ToggleFocus";
          };
        }
        {
          context = "Workspace";
          bindings = {
            "alt-escape" = "workspace::ToggleLeftDock";
          };
        }
        {
          context = "vim_mode == visual";
          bindings = {
            "shift-x" = "vim::Exchange";
          };
        }
      ];
      userSettings = {
        vim_mode = true;
        relative_line_numbers = "enabled";
        tab_size = 4;
        hard_tabs = false;
        soft_wrap = "none";
        scroll_beyond_last_line = "off";
        vertical_scroll_margin = 0;
        auto_update = false;
        load_direnv = "direct";
        project_panel = {
          starts_open = true;
          auto_reveal_entries = true;
          auto_fold_dirs = true;
          sort_mode = "directories_first";
          folder_icons = true;
          file_icons = true;
          git_status = true;
          show_diagnostics = "all";
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };
    };
  };
}
