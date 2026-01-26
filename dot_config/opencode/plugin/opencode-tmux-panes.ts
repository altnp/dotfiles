import type { Plugin } from "@opencode-ai/plugin";
import { loadPluginConfig, type TmuxConfig } from "./opencode-tmux-panes/config";
import { TmuxSessionManager } from "./opencode-tmux-panes/features/tmux-session-manager";
import { startTmuxCheck } from "./opencode-tmux-panes/utils/tmux";
import { log } from "./opencode-tmux-panes/shared/logger";

export const OpencodeTmuxPanes: Plugin = async (ctx) => {
  const config = loadPluginConfig(ctx.directory);

  const tmuxConfig: TmuxConfig = {
    enabled: config.tmux?.enabled ?? false,
    layout: config.tmux?.layout ?? "main-vertical",
    main_pane_size: config.tmux?.main_pane_size ?? 60,
  };

  log("[plugin] initialized with tmux config", {
    tmuxConfig,
    rawTmuxConfig: config.tmux,
    directory: ctx.directory,
  });

  if (tmuxConfig.enabled) {
    startTmuxCheck();
  }

  const tmuxSessionManager = new TmuxSessionManager(ctx, tmuxConfig);

  return {
    name: "opencode-tmux-panes",
    event: async (input) => {
      await tmuxSessionManager.onSessionCreated(
        input.event as {
          type: string;
          properties?: { info?: { id?: string; parentID?: string; title?: string } };
        },
      );
    },
  };
};

export default OpencodeTmuxPanes;
