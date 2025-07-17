{ inputs, system, ... }:
let
  quickshell = inputs.quickshell.packages."${system}".default;
in
{
  home.packages = [ quickshell ];
}
