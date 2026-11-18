{ config, pkgs, ... }: {
  sops.secrets."hermes_agent/env".sopsFile = ../../../../secrets/secrets.yaml;

  services.hermes-agent = {
    enable = true;
    gateway.enable = false;
    settings = {
      model = {
        provider = "custom";
        base_url = "\${OPENAI_BASE_URL}";
        default = "qwen3.8-27b";
        context_length = 65536;
      };
      display.interface = "tui";
      webapp.enabled = false;
      terminal = {
        backend = "local";
        cwd = ".";
        temp_dir = "~/.hermes/cache/terminal";
        timeout = 180;      # Per-command timeout in seconds
        home_mode = "auto"; # auto | real | profile — subprocess HOME policy
      };
      agent = {
        reasoning_effort = "xhigh"; # empty = medium. Options: none, minimal, low, medium, high, xhigh, max, ultra
        disabled_toolsets = [
          "vision"
          "video"
          "image_gen"
          "video_gen"
          "tts"
          "stt"
          "cronjob"
        ];
        clarify_timeout = 90;
      };
      compression = {
        enabled = true;                            # Toggle compression on/off
        progress_notices = true;                   # Opt-in: deliver routine compression progress notices to chat platforms — see below
        threshold = 10;                            # Compress at this % of context limit
        threshold_tokens = 50;                     # Absolute token cap (optional) — takes lower of ratio vs absolute
        target_ratio = 0.20;                       # Fraction of threshold to preserve as recent tail
        tail_mode = "lean";                        # Tail retention: "lean" (default — clamped 2.5% tail, 10K-25K, never above 20% of the window, with a detailed session log + anchor index + session_search recovery pointers in the summary, all from ONE auxiliary summarizer call; ~3x fewer retained tokens after compaction) or "legacy" (0.20×threshold verbatim tail)
        protect_last_n = 20;                       # Min recent messages to keep uncompressed
        protect_first_n = 3;                       # Non-system head messages pinned across compactions (0 = pin nothing)
        in_place = true;                           # Compact on the same session id (no rotation) — see below
        idle_compact_after_seconds = 0;            # Opt-in idle compaction (0 = disabled) — see below
        prepare_ahead = true;                      # Opt-in: prepare the next summary in the background — see below
        hygiene_hard_message_limit = 5000;         # Gateway safety valve — see below
        hygiene_timeout_seconds = 30;              # Max seconds of NO summary-model output before hygiene compression is cut off
        hygiene_total_ceiling_seconds = 600;       # Absolute cap on the hygiene wait even while tokens are still streaming
        hygiene_max_turn_hold_seconds = 10;        # Max wall-clock the incoming turn waits on hygiene compression before proceeding uncompressed — see below
        hygiene_failure_cooldown_seconds = 300;    # First rung of the per-session hygiene-failure backoff (x1/x3/x9, capped at 1h)
        context_timeout_seconds = 120;             # Inactivity budget for in-agent compress_context (loop /compress / preflight) — see below
        context_total_ceiling_seconds = 600;       # Absolute cap on the *pre-commit* in-agent compress_context wait even while tokens are still streaming (an already-started SessionDB commit is never abandoned; overruns are logged + surfaced)
        proactive_prune_tokens = 0;                # Opt-in tokens trigger for the no-LLM tool-result prune (0 = off; see below)
        proactive_prune_min_result_chars = 8000;   # Prune's summarize pass only touches tool results larger than this (clamped >= 200)
        proactive_prune_min_reclaim_tokens = 4096; # Prune only commits when it reclaims at least this many tokens (0 = commit any)
      };
      # The summarization model/provider is configured under auxiliary:
      auxiliary = {
        compression = {
          model = "qwen3.8-27b";
          provider = "custom";
          base_url = "\${OPENAI_BASE_URL}";
        };
      };
      plugins = {
        enabled = [
          "hermes-lcm"
          "rtk-rewrite"
        ];
        disabled = [];
        auto_apply = true;
      };
      display = {
        tool_progress = "all";      # off | new | all | verbose
        focus_view = false;       # CLI focus view (/focus) — reduced output, display-only
        platforms = {};           # Per-platform display overrides (see below)
        suppress_warning_notifications = false;  # Opt-in: hide automatic warning/diagnostic notices, incl. the silence-marker notice (see messaging guide)
        show_commentary = true;   # Codex models: deliver commentary-channel progress narration as visible mid-turn updates
        skin = "default";           # Built-in or custom CLI skin (see user-guide/features/skins)
        # personality = "";         # Legacy cosmetic field still surfaced in some summaries
        compact = true;          # Compact output mode (less whitespace)
        cli_multiline_shortcuts = true;  # CLI: Ctrl+J, \ + Enter, and supported Shift+Enter insert newlines (false = legacy c-j submit fallback)
        resume_display = "full";    # full (show previous messages on resume) | minimal (one-liner only)
        bell_on_complete = false; # Play terminal bell when agent finishes (great for long tasks)
        bell_on_prompt = false;   # Play terminal bell when a blocking prompt opens (clarify, approval, sudo password, secret capture) — works over SSH
        # Both bell flags also emit an OSC 9 desktop notification (Ghostty, iTerm2, Kitty, WezTerm raise an OS
        # notification; other terminals ignore it) and, inside Warp (TERM_PROGRAM=WarpTerminal with the CLI-agent
        # protocol advertised), a warp://cli-agent OSC 777 event (`stop` on completion, `permission_request` on
        # blocking prompts) so Warp's tab status and notification mailbox track Hermes. No extra keys needed.
        show_reasoning = false;    # Show model reasoning/thinking above each response (default: true; toggle with /reasoning show|hide). On a gateway reply that was streamed, it follows the answer as its own message
        streaming = true;        # Stream tokens to terminal as they arrive (real-time output)
        show_cost = false;        # Show estimated $ cost in the CLI status bar
        vim_mode = false;         # CLI only: vi/vim keybindings in the input composer (Esc → NORMAL, i → INSERT). The live NORMAL/INSERT/REPLACE mode shows at the right of the status bar. Config-only, read at startup.
        timestamps = false;       # When true, prefixes user and assistant labels with timestamps in the CLI / TUI transcript
        timestamp_format = "%H:%M";  # strftime format for those timestamps (e.g. "%b-%d %H:%M" for month-day)
        tool_preview_length = 0;  # Max chars for tool call previews (0 = no limit, show full paths/commands)
        turn_summary = true;      # CLI only: print a one-line post-turn accounting footer after each interactive turn
        spinner_token_flow = true; # CLI only: append live cumulative turn tokens to the spinner timer
        status_bar = {             # CLI/TUI: choose which status-bar fields are visible
          fields = [
            # "model"
            "context_detail"
            "context_pct"
            "total_tokens"
            # "cache_hit"
            # "latency"
            # "tps"
            "git_branch"
            # "title"
          ];
        };
        file_mutation_verifier = true;    # Append an advisory footer when write_file/patch calls failed this turn
        credits_notices = false;   # Nous credits status-bar notices (usage bands, grant-spent, depleted). false = silence them; /usage still works
        cli_rebuild_scrollback_on_redraw = false;  # Classic CLI: also wipe terminal scrollback (CSI 3J) on /redraw / Ctrl+L / width-change resize recovery. Enable when a terminal/tmux stack stamps stale prompt chrome into scrollback on maximize/restore.
        language = "en";            # UI language for static messages (approval prompts, some gateway replies). en | zh | zh-hant | ja | de | es | fr | tr | uk | af | ko | it | ga | pt | ru | hu
      };
      code_execution = {
        mode = "project";    # project (default) | strict
        timeout = 300;       # Max execution time in seconds
        max_tool_calls = 50; # Max tool calls within code execution
      };
      web = {
        backend = "searxng";
      };
      context = {
        engine = "lcm";
      };
      telemetry.enabled = false;
      logging.level = "info";
      data_share.enabled = false;
    };

    environmentFiles = [ config.sops.secrets."hermes_agent/env".path ];
    # environment = {
    #   SEARXNG_URL = "";
    # };
    extraPlugins = [
      (pkgs.fetchFromGitHub {
        owner = "stephenschoettler";
        repo = "hermes-lcm";
        rev = "v0.20.0";
        hash = "sha256-yJ1Nn+su7YbKd+cgVOizXChzLbKHqTprSprF1p9/HYk=";
      })
    ];
    extraPythonPackages = [
      (config.services.hermes-agent.package.python.pkgs.buildPythonPackage {
        pname = "rtk-hermes";
        version = "1.2.3";
        src = pkgs.fetchFromGitHub {
          owner = "ogallotti";
          repo = "rtk-hermes";
          rev = "v1.2.3";
          hash = "sha256-7YRW6PODrCapfYLFn3DvgHAEME//RGC48GQt+s9ot0s=";
        };
        format = "pyproject";
        build-system = [ config.services.hermes-agent.package.python.pkgs.setuptools ];
      })
    ];
  };

  programs.hermes-agent.enable = true;

  home.packages = with pkgs; [
    rtk
  ];
}
