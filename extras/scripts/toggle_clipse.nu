let pids = ps | where name =~ 'clipse' | where ppid != 1
if ($pids | length) == 0 {
  pypr toggle clipse
} else {
  kill ($pids | get pid.0); sleep 0.2sec; pypr toggle clipse
}
