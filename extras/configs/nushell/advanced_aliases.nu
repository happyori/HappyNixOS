def 'l' [] {
    ls -as | sort-by type size
}

def 'll' [] {
    ls -al | sort-by type size
}

def 'lf' [] {
    ls -af | sort-by type size
}

def 'lld' [] {
    ls -asd | sort-by type size
}
