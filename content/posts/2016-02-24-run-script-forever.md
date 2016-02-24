---
title: Run script forever, without parallel execution
tags: bash, snippets
---

Execute a script every minute, but make sure it never runs two instances. This
snippet only works for blocking tasks, but can easily adapted to e.g. restart
a nonblocking development server.

```bash
#!/bin/bash

PIDFILE=path/to/pid-file

if [ -e $PIDFILE ]; then
    OLD_PID=$(cat $PIDFILE)
    if ps -p "$OLD_PID" > /dev/null
    then
        exit 0
    fi
fi

# good to go, no processes running
echo $$ > $PIDFILE

rsync $FROM $TO
```
