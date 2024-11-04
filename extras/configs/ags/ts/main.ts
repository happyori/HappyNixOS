import { Bar } from "./bar/Bar";

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
