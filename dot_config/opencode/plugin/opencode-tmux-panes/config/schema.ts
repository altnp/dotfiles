import { z } from "zod";

export const TmuxLayoutSchema = z.enum([
  "main-horizontal",
  "main-vertical",
  "tiled",
  "even-horizontal",
  "even-vertical",
]);

export type TmuxLayout = z.infer<typeof TmuxLayoutSchema>;

export const TmuxConfigSchema = z.object({
  enabled: z.boolean().default(false),
  layout: TmuxLayoutSchema.default("main-vertical"),
  main_pane_size: z.number().min(20).max(80).default(60),
});

export type TmuxConfig = z.infer<typeof TmuxConfigSchema>;

export const PluginConfigSchema = z.object({
  tmux: TmuxConfigSchema.optional(),
});

export type PluginConfig = z.infer<typeof PluginConfigSchema>;
