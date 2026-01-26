import { spawn } from "bun";
import { log } from "../shared/logger";
import type { TmuxConfig, TmuxLayout } from "../config/schema";

let tmuxPath: string | null = null;
let tmuxChecked = false;

let storedConfig: TmuxConfig | null = null;

let serverAvailable: boolean | null = null;
let serverCheckUrl: string | null = null;

export async function isServerRunning(serverUrl: string): Promise<boolean> {
  if (serverCheckUrl === serverUrl && serverAvailable !== null) {
    return serverAvailable;
  }

  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 1000);

    const response = await fetch(`${serverUrl}/health`, {
      signal: controller.signal,
    }).catch(() => null);

    clearTimeout(timeout);

    serverCheckUrl = serverUrl;
    serverAvailable = response?.ok ?? false;

    log("[tmux] isServerRunning: checked", { serverUrl, available: serverAvailable });
    return serverAvailable;
  } catch {
    serverCheckUrl = serverUrl;
    serverAvailable = false;
    log("[tmux] isServerRunning: server not reachable", { serverUrl });
    return false;
  }
}

export function resetServerCheck(): void {
  serverAvailable = null;
  serverCheckUrl = null;
}

async function findTmuxPath(): Promise<string | null> {
  const isWindows = process.platform === "win32";
  const cmd = isWindows ? "where" : "which";

  try {
    const proc = spawn([cmd, "tmux"], {
      stdout: "pipe",
      stderr: "pipe",
    });

    const exitCode = await proc.exited;
    if (exitCode !== 0) {
      log("[tmux] findTmuxPath: 'which tmux' failed", { exitCode });
      return null;
    }

    const stdout = await new Response(proc.stdout).text();
    const path = stdout.trim().split("\n")[0];
    if (!path) {
      log("[tmux] findTmuxPath: no path in output");
      return null;
    }

    const verifyProc = spawn([path, "-V"], {
      stdout: "pipe",
      stderr: "pipe",
    });
    const verifyExit = await verifyProc.exited;
    if (verifyExit !== 0) {
      log("[tmux] findTmuxPath: tmux -V failed", { path, verifyExit });
      return null;
    }

    log("[tmux] findTmuxPath: found tmux", { path });
    return path;
  } catch (err) {
    log("[tmux] findTmuxPath: exception", { error: String(err) });
    return null;
  }
}

export async function getTmuxPath(): Promise<string | null> {
  if (tmuxChecked) {
    return tmuxPath;
  }

  tmuxPath = await findTmuxPath();
  tmuxChecked = true;
  log("[tmux] getTmuxPath: initialized", { tmuxPath });
  return tmuxPath;
}

export function isInsideTmux(): boolean {
  return !!process.env.TMUX;
}

async function applyLayout(tmux: string, layout: TmuxLayout, mainPaneSize: number): Promise<void> {
  try {
    const layoutProc = spawn([tmux, "select-layout", layout], {
      stdout: "pipe",
      stderr: "pipe",
    });
    await layoutProc.exited;

    if (layout === "main-horizontal" || layout === "main-vertical") {
      const sizeOption = layout === "main-horizontal" ? "main-pane-height" : "main-pane-width";

      const sizeProc = spawn([tmux, "set-window-option", sizeOption, `${mainPaneSize}%`], {
        stdout: "pipe",
        stderr: "pipe",
      });
      await sizeProc.exited;

      const reapplyProc = spawn([tmux, "select-layout", layout], {
        stdout: "pipe",
        stderr: "pipe",
      });
      await reapplyProc.exited;
    }

    log("[tmux] applyLayout: applied", { layout, mainPaneSize });
  } catch (err) {
    log("[tmux] applyLayout: exception", { error: String(err) });
  }
}

export interface SpawnPaneResult {
  success: boolean;
  paneId?: string;
}

export async function spawnTmuxPane(
  sessionId: string,
  description: string,
  config: TmuxConfig,
  serverUrl?: string
): Promise<SpawnPaneResult> {
  log("[tmux] spawnTmuxPane called", { sessionId, description, config, serverUrl });

  if (!config.enabled) {
    log("[tmux] spawnTmuxPane: config.enabled is false, skipping");
    return { success: false };
  }

  if (!isInsideTmux()) {
    log("[tmux] spawnTmuxPane: not inside tmux, skipping");
    return { success: false };
  }

  if (!serverUrl) {
    log("[tmux] spawnTmuxPane: server url missing, skipping");
    return { success: false };
  }

  const serverRunning = await isServerRunning(serverUrl);
  if (!serverRunning) {
    log("[tmux] spawnTmuxPane: OpenCode server not running, skipping", {
      serverUrl,
      hint: "Ensure this OpenCode instance is running and expose its server URL",
    });
    return { success: false };
  }

  const tmux = await getTmuxPath();
  if (!tmux) {
    log("[tmux] spawnTmuxPane: tmux binary not found, skipping");
    return { success: false };
  }

  storedConfig = config;

  try {
    const opencodeCmd = `opencode attach ${serverUrl} --session ${sessionId}`;

    const args = [
      "split-window",
      "-h",
      "-d",
      "-P",
      "-F",
      "#{pane_id}",
      opencodeCmd,
    ];

    log("[tmux] spawnTmuxPane: executing", { tmux, args, opencodeCmd });

    const proc = spawn([tmux, ...args], {
      stdout: "pipe",
      stderr: "pipe",
    });

    const exitCode = await proc.exited;
    const stdout = await new Response(proc.stdout).text();
    const stderr = await new Response(proc.stderr).text();
    const paneId = stdout.trim();

    log("[tmux] spawnTmuxPane: split result", { exitCode, paneId, stderr: stderr.trim() });

    if (exitCode === 0 && paneId) {
      const renameProc = spawn(
        [tmux, "select-pane", "-t", paneId, "-T", description.slice(0, 30)],
        { stdout: "ignore", stderr: "ignore" }
      );
      await renameProc.exited;

      const layout = config.layout ?? "main-vertical";
      const mainPaneSize = config.main_pane_size ?? 60;
      await applyLayout(tmux, layout, mainPaneSize);

      log("[tmux] spawnTmuxPane: SUCCESS, pane created and layout applied", { paneId, layout });
      return { success: true, paneId };
    }

    return { success: false };
  } catch (err) {
    log("[tmux] spawnTmuxPane: exception", { error: String(err) });
    return { success: false };
  }
}

export async function closeTmuxPane(paneId: string): Promise<boolean> {
  log("[tmux] closeTmuxPane called", { paneId });

  if (!paneId) {
    log("[tmux] closeTmuxPane: no paneId provided");
    return false;
  }

  const tmux = await getTmuxPath();
  if (!tmux) {
    log("[tmux] closeTmuxPane: tmux binary not found");
    return false;
  }

  try {
    const proc = spawn([tmux, "kill-pane", "-t", paneId], {
      stdout: "pipe",
      stderr: "pipe",
    });

    const exitCode = await proc.exited;
    const stderr = await new Response(proc.stderr).text();

    log("[tmux] closeTmuxPane: result", { exitCode, stderr: stderr.trim() });

    if (exitCode === 0) {
      log("[tmux] closeTmuxPane: SUCCESS, pane closed", { paneId });

      if (storedConfig) {
        const layout = storedConfig.layout ?? "main-vertical";
        const mainPaneSize = storedConfig.main_pane_size ?? 60;
        await applyLayout(tmux, layout, mainPaneSize);
        log("[tmux] closeTmuxPane: layout reapplied", { layout });
      }

      return true;
    }

    log("[tmux] closeTmuxPane: failed (pane may already be closed)", { paneId });
    return false;
  } catch (err) {
    log("[tmux] closeTmuxPane: exception", { error: String(err) });
    return false;
  }
}

export function startTmuxCheck(): void {
  if (!tmuxChecked) {
    getTmuxPath().catch(() => {});
  }
}
