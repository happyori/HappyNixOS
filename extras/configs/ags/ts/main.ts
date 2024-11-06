import Gtk from "types/@girs/gtk-3.0/gtk-3.0";
import { Bar } from "./bar/Bar";
import Gdk from "types/@girs/gdk-3.0/gdk-3.0";
const hyprland = await Service.import("hyprland");
const display = Gdk.Display.get_default();

function withMonitors(bar: (monitor: Gdk.Monitor) => Gtk.Widget): Gtk.Widget[] {
  const monitors = hyprland.monitors;
  let bars = [];

  const getMonitorName = (
    monitor: Gdk.Monitor | null | undefined,
  ): string | null => {
    const screen = display?.get_default_screen();
    const count = display?.get_n_screens() ?? 1;

    for (let i = 0; i < count; ++i) {
      if (monitor && monitor === display?.get_monitor(i))
        return screen?.get_monitor_plug_name(i) ?? null;
    }

    return null;
  };

  for (let monitorIndex = 0; monitorIndex < monitors.length; monitorIndex++) {
    const monitor = monitors[monitorIndex];
    const { name } = monitor;
    const monitorCount = display?.get_n_monitors() ?? 1;
    for (let index = 0; index < monitorCount; index++) {
      let monitor = display?.get_monitor(index);
      if (getMonitorName(monitor) === name) bars.push(bar(monitor));
    }
  }

  return bars;
}

App.config({
  windows: [Bar(0)],
});

async function resetCSS() {
  try {
    const scss_root = `${App.configDir}/css/`;
    const compiled_root = `/tmp/ags/css/`;

    await Utils.execAsync(`bash -c "sass ${scss_root}:${compiled_root}"`);
    App.applyCss(`${compiled_root}main.css`);
  } catch (error) {
    error instanceof Error ? logError(error) : console.error(error);
  }
}

Utils.monitorFile(`${App.configDir}/css`, resetCSS);
await resetCSS();
