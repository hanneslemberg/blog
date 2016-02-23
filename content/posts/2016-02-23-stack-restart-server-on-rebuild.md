---
title: Restarting your server on rebuild
tags: TIL, stack, haskell, hakyll
---

e.g. this Hakyll blog:

Terminal 1:
```bash
stack build --file-watch --exec "killall blog watch"
```


Terminal 2:
```bash
while true; do ./watch.sh; sleep 1; done;
```

Content of watch.sh
```bash
stack exec blog rebuild
stack exec blog watch
```
