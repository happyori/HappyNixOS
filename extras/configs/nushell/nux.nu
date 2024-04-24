let _amend_if_needed = {
  print "Checking if additional amends needed"
  let changes = git status --porcelain | lines | length
  if $changes == 0 {
    print "No changes skipping amending"
    return
  }

  print "Changes found amending the commit"
  git add .;
  git commit --amend
}

# Nix switch using flakes
def "nux rebuild" [
  --trace (-t) # Adds --show-trace to the build
] {
  cd ~/.config/nixos/
  do $_amend_if_needed
  print "Rebuilding system with flake\n"
  if $trace {
    nh os switch -- --show-trace
  } else {
    nh os switch
  }
  do $_amend_if_needed
}

# Nix switch using flakes with updating configuration
def "nux update" [] {
  cd ~/.config/nixos/
  do $_amend_if_needed
  print "Updating system\n"
  nh os switch -u
  do $_amend_if_needed
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

# Edit my nix config from anywhere with multiple extra feautres
def "nux edit" [
  --fast (-f), # Allows to skip editing
  --trace (-t), # Adds --show-trace to the end build in case of errors
] {
  let ask = {|msg| kitten ask -t yesno -n "nixrebuild" -m $'Commit: ($msg)\nContinue with the build?' -d n }
  cd ~/.config/nixos/
  if not $fast {
    print 'Starting nix editing'
    neovide --no-fork ~/.config/nixos/flake.nix | complete
    print 'Editing finished, starting the diff'
  }
  git -p difftool
  let commitmsg = nixos-rebuild list-generations --json
    | from json
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
  git add .;
  git commit -m $commitmsg
  print 'Attempting to rebuild'
  try {
    if $trace { nux rebuild -t } else { nux rebuild }
  } catch {
    print 'Failed to run rebuild'
    print 'Resetting git'
    git reset HEAD~
    print 'Git reset. exiting'
    return
  }
  print 'Successfully finished rebuilding'
}