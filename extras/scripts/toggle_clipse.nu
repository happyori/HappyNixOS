let pid = ps | where name =~ 'clipse' | where ppid != 1 | get pid.0

kill $pid; sleep 0.2sec; pypr toggle clipse
