let pkg = nix-locate 'gnome-authentication'
            | lines
            | parse -r '(?P<name>.+)\s+(.+) (?P<type>.) (?P<path>.+)'
            | where type == x
            | get path
            | first

^$pkg
