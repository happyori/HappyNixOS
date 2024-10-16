def 'l' [ ...args ] {
    ls -as ...$args | sort-by type name size
}

def 'll' [ ...args ] {
    ls -al ...$args | sort-by type name size
}

def 'lf' [ ...args ] {
    ls -af ...$args | sort-by type name size
}

def 'lld' [ ...args ] {
    ls -asd ...$args | sort-by type name size
}
