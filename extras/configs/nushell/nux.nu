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
  ...args
] {
  cd ~/.config/nixos/
  do $_amend_if_needed
  print "Rebuilding system with flake\n"
  if $trace {
    nh os ...$args -- --show-trace
  } else {
    nh os ...$args
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
  --skip (-s), # Skips validations with gittool
] {
  let ask = {|msg|
    let line_count = 0
    # kitten ask -t yesno -n "nixrebuild" -m $'Commit: ($msg)\nContinue with the build?' -d n 
    (kitten ask -t line
      -p `⮞ `
      -m $"Commit: ($msg)\nPlease enter how to proceed [btsC]\n• b -> Rebuild and switch on Boot\n• t -> Rebuild with test \(non-permanent rebuild)\n• s -> Rebuild and switch now\n• c -> [Default] Cancel")
    | tee { print }
  }
  cd ~/.config/nixos/
  if not $fast {
    print 'Starting nix editing'
    neovide --no-fork ~/.config/nixos/flake.nix | complete
    print 'Editing finished, starting the diff'
  }
  if not $skip {
    git -p difftool
  }
  let commitmsg = nixos-rebuild list-generations --json --flake $"($env.FLAKE)#(hostname)"
    | from json
    | where current
    | update generation {|g| $g.generation + 1 }
    | format pattern 'NixOSv2 generation -[{generation}]- {date}'
    | first
  print $'Generated commit msg -> ($commitmsg)'
  let response = do $ask $commitmsg | complete | get stdout | lines | last 4 | str join | from json | get response | str downcase
  let valid_responses = [ b t s ]

  if $response not-in $valid_responses {
    print "Aborting..."
    return
  }

  mut rebuild_command = "nux rebuild"

  print 'Proceeding'
  git add .;
  git commit -m $commitmsg

  if ( $response == b ) {
    $rebuild_command = ( $rebuild_command | append "boot" | str join " " )
  } else if ( $response == t ) {
    $rebuild_command = ( $rebuild_command | append "test" | str join " " )
  } else {
    $rebuild_command = ( $rebuild_command | append "switch" | str join " " )
  }

  if $trace { $rebuild_command = ( $rebuild_command | append "-t" | str join " " ) }

  print 'Attempting to rebuild'
  try {
    print $'Rebuilding with: ($rebuild_command)'
    nu -c $'source ~/.config/nixos/extras/configs/nushell/nux.nu; ($rebuild_command)'
  } catch {
    print 'Failed to run rebuild'
    print 'Resetting git'
    git reset HEAD~
    print 'Git reset. exiting'
    return
  }
  print 'Successfully finished rebuilding'
}
