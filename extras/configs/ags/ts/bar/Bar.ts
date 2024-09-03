import { DateTime } from "./widgets/Date";

export const Bar = (id: number) =>
  Widget.Window({
    monitor: id,
    class_names: ["bar", "transparent"],
    exclusivity: "exclusive",
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
      class_name: "bar-content",
      endWidget: Widget.Box([DateTime()]),
    }),
  });
