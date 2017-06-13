ColinSeymour.co.uk
==================

This is the source repository for [colinseymour.co.uk](http://colinseymour.co.uk).

## How I deploy to my own server

- Add a new remote that is on my hosting server:
  `git add remote deploy user@hosting.srv`
- Add the following `post-receive` hook to it:

  ```
  #!/bin/sh
  PUBLIC_WWW=${HOME}/www/colinseymour
  rm -rf ${PUBLIC_WWW}/*
  git archive gh-pages | tar -x -C ${PUBLIC_WWW}
  exit
  ```
- deploy using: `git push deploy gh-pages --force`

## Todos

- [ ] Find a theme I like and customise it
