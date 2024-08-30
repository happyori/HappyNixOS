const Bar = (monitor: number) =>
  Widget.Window({
    name: `bar-${monitor}`,
    child: Widget.Label("Hello World"),
  });

App.config({
  windows: [Bar(0)],
});
