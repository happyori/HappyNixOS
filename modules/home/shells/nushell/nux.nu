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
  let ask = {|msg| kitten ask -t yesno -n "nixrebuild" -m $'Commit: ($msg)\nContinue with the build?' -d n }
  print 'Starting nix editing'
  cd ~/.config/nixos/
  neovide --no-fork ~/.config/nixos/configuration.nix | complete
  print 'Editing finished, starting the diff'
  git diff main HEAD~
  let commitmsg = nixos-rebuild list-generations --json
    | from json
    | reject specialisations configurationRevision
    | where current
    | update generation {|g| $g.generation + 1 }
    | format pattern 'NixOS generation -[{generation}]- {date}'
    | first
  print $'Generated commit msg -> ($commitmsg)'
  let response = do $ask $commitmsg | from json | get response

  if $response != "y" {
    print "Aborting..."
    return
  }

  print 'Proceeding'
  git commit -am $commitmsg
  print 'Attempting to rebuild'
  try { nux rebuild } catch { 
    print 'Failed to run rebuild'
    print 'Resetting git'
    git reset HEAD~
    print 'Git reset. exiting'
    return
  }
  print 'Successfully finished rebuilding'
}
