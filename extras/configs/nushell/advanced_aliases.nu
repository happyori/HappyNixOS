def 'l' [] {
    ls -as | sort-by type name size
}

def 'll' [] {
    ls -al | sort-by type name size
}

def 'lf' [] {
    ls -af | sort-by type name size
}

def 'lld' [] {
    ls -asd | sort-by type name size
}
