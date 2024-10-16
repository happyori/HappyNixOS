def 'l' [ target: path = '.' ] {
    ls -as $target | sort-by type name size
}

def 'll' [ target: path = '.' ] {
    ls -al $target | sort-by type name size
}

def 'lf' [ target: path = '.' ] {
    ls -af $target | sort-by type name size
}

def 'lld' [ target: path = '.' ] {
    ls -asd $target | sort-by type name size
}
