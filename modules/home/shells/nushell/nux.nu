# Nix switch using flakes
def "nux rebuild" [] {
  print "Rebuilding system with flake\n"
  nh os switch
}

# Nix switch using flakes with updating configuration
def "nux update" [] {
  print "Updating system\n"
  nh os switch -u
}

# Search nix packages
def "nux search" [
  pkg: string,          # The name of the package to find
  --limit (-l): int = 4   # Amount of packages to limit by
] {
  nh search -l $limit $pkg
}

# Clean up nix
def "nux clean" [
  dry?: string, # If executed as `nux clean dry ...` will run a dry clean
  --keep (-k): int = 5, # How many of the last iterations to keep
  --since (-S): string = "5h" # Keep packages at least this old
] {
  if $dry == "dry" {
    nh clean all -n -k $keep -K $since -a
  } else {
    nh clean all -k $keep -K $since -a
  }
}

def "nux edit" [] {
  let commitmsg = nixos-rebuild list-generations --json
    | from json
    | reject specialisations configurationRevision
    | where current
    | update generation {|g| $g.generation + 1 }
    | format pattern 'NixOS generation -[{generation}]- {date}'
}
