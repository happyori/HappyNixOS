const time = Variable("00:00 AM", {
  poll: [500, ["nu", "-c", "date now | format date `%I:%M %p`"]],
});

const date = Variable("", {
  poll: [500, ["nu", "-c", "date now | format date %v"]],
});

const Time = () =>
  Widget.Label({
    label: time.bind(),
    class_name: "time-label",
  });

const Date = () =>
  Widget.Label({
    label: date.bind(),
    class_name: "date-label",
  });

export const DateTime = () =>
  Widget.Box({
    class_name: "date-time",
    vertical: false,
    hpack: "center",
    children: [Date(), Time()],
  });
