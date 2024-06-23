const gitname = "github:happyori/HappyNixVim"

# Run my nixvim configuration from github
export def nxvim [
  --file: path # Optional if -f specified, otherwise uses this path to run nixvim
  --find (-f) # Flag to run fd + fzf combo to select file in current directory
  --vim (-v) # Run nixvim instead of default nixvide
  --dry (-d) # Dry run, mostly for testing
  ...args # The rest of arguments passed to nixvi[m|de]
] {
  mut runCmd = $"($gitname)#"
  if $vim { $runCmd += "nvim" } else { $runCmd += "nixvide" }

  mut finalFile = $file

  if $find {
    $finalFile = (nix-shell -p fd fzf --command "fd -t f | fzf --preview 'cat {}'")
  }

  if not $find and $file == null {
    print "Please pass in file or use -f to select it"
    return
  }

  print -n "Current run command: " $runCmd "\n"
  print "Arguments passed: " $args
  print -n "Selected file: " $finalFile "\n"

  if $dry { return }

  nix run $runCmd $finalFile -- ...$args
}

