import { DateTime } from "./widgets/Date";

const Padding = Widget.Box({
  hexpand: true,
  vexpand: true,
});

export const Bar = (id: number) =>
  Widget.Window({
    name: `happy_bar_${id}`,
    class_names: ["bar", "transparent"],
    exclusivity: "exclusive",
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
      class_name: "bar-content",
      startWidget: Padding,
      centerWidget: Padding,
      endWidget: Widget.Box([DateTime()]),
    }),
  });
