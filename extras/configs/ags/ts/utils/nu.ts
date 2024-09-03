export function nu(command: string | string[]) {
  if (typeof command === "string") {
    command.replaceAll('"', '\\"');
    return Utils.exec(`nu -c "${command}"`);
  }
  let combined = command.join(" | ");
  return Utils.exec(`nu -c "${combined}"`);
}
