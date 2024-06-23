const entry = App.configDir + '/ts/main.ts';
const outDir = '/tmp/ags/js';

try {
  await Utils.execAsync([
    'bun', 'build', entry,
    '--outdir', outDir,
    '--external', 'resource://*',
    '--external', 'gi://*',
  ]);
  await import(`file://${outDir}/main.js`);
} catch (error) {
  console.error(error);
}
